{%- from "packer/map.jinja" import build with context %}
{%- if build.enabled %}

{% set source_file = 'packer_'+build.version+'_'+grains.kernel|lower+'_'+ grains.osarch+'.zip' %}

{% if grains.kernel == "Linux" %}

packer_packages:
  pkg.installed:
  - names:
    - unzip

/srv/packer:
  file.directory

/srv/packer/templates:
  file.directory:
  - mode: 0777
  - require:
    - file: /srv/packer

/srv/packer/iso:
  file.directory:
  - require:
    - file: /srv/packer

{% if pillar.virtualbox is defined %}

/srv/packer/virtualbox:
  file.directory:
  - mode: 0777
  - require:
    - file: /srv/packer

{% endif %}

{% if pillar.vmware_workstation is defined %}

/srv/packer/vmware:
  file.directory:
  - mode: 0777
  - require:
    - file: /srv/packer

{% endif %}

/usr/local/packer:
  file.directory

packer_download_package:
  cmd.run:
  - name: wget {{ build.source_url }}/{{ source_file }}
  - unless: test -e /root/{{ source_file }}
  - cwd: /root

packer_unzip_package:
  cmd.run:
  - name: unzip -o {{ source_file }} -d /usr/local/packer
  - unless: test -e /usr/local/packer/packer
  - require:
    - pkg: packer_packages
    - file: /usr/local/packer
    - cmd: packer_download_package

{%- for binary in build.binaries %}

/usr/bin/{{ binary }}:
  file.symlink:
  - target: /usr/local/packer/{{ binary }}
  - require:
    - cmd: packer_unzip_package

{%- endfor %}

{% elif grains.kernel == "Windows" %}

packer_install_package:
  pkg.installed:
  - name: packer_x64_en

{%- endif %}

{%- endif %}