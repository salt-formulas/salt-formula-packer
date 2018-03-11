{%- from "packer/map.jinja" import build with context %}
{%- if build.enabled %}

{% set source_file = 'packer_'+build.version+'_'+grains.kernel|lower+'_'+ grains.osarch+'.zip' %}

{% if grains.kernel == "Linux" %}

Install Unzip:
  pkg.installed:
    - name: unzip

Create Initial Packer Directory:
  file.directory:
    - name: /srv/packer

Create Template Directory:
  file.directory:
    - name: /srv/packer/templates
    - require:
      - file: /srv/packer

Create ISO Directory:
  file.directory:
    - name: /srv/packer/iso
    - require:
      - file: /srv/packer

Create Packer build Scripts Director:
  file.directory:
    - name: /srv/packer/build/scripts
    - makedirs: true
    - require:
      - file: /srv/packer

{% if pillar.virtualbox is defined %}

 Create Virtualbox Build Directory:
  file.directory:
    - name : /srv/packer/build/virtualbox
    - makedirs: true
    - require:
      - file: /srv/packer

{% endif %}

{% if pillar.vmware_workstation is defined %}

Create VMware Workstation Build Directory:
  file.directory:
    - name: /srv/packer/build/vmware
    - makedirs: true
    - require:
      - file: /srv/packer

{% endif %}

Create Packer Binary folder:
  file.directory:
    - name: /usr/local/packer

Download Packer Binary:
  cmd.run:
    - name: wget {{ build.source_url }}/{{ source_file }}
    - unless: test -e /root/{{ source_file }}
    - cwd: /root

Unzip Packer binary:
  cmd.run:
    - name: unzip -o {{ source_file }} -d /usr/local/packer
    - unless: test -e /usr/local/packer/packer
    - require:
      - pkg: Install Unzip
      - file: /usr/local/packer
      - cmd: Download Packer Binary

{%- for binary in build.binaries %}

/usr/bin/{{ binary }}:
  file.symlink:
    - target: /usr/local/packer/{{ binary }}
    - require:
      - cmd: Unzip Packer binary

{%- endfor %}

{% elif grains.kernel == "Windows" %}

packer_install_package:
  pkg.installed:
    - name: packer_x64_en

{%- endif %}

{%- endif %}
