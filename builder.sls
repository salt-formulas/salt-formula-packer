{% set kernel = salt['grains.item']('kernel')['kernel'] %}

{% set os = salt['grains.item']('os')['os'] %}

{% set os_arch = salt['grains.item']('osarch')['osarch'] %}

{% if pillar.packer.builder.version is defined %}
{% set packer_version = pillar.packer.builder.version %}
{% else %}
{% set packer_version = '0.3.10' %}
{% endif %}

{% set packer_base_url = 'https://dl.bintray.com/mitchellh/packer' %}

{% set packer_base_file_fragments = [ packer_version, '_', kernel|lower, '_', os_arch, '.zip' ] %}
{% set packer_base_file = packer_base_file_fragments|join("") %}

{% set packer_binaries = [ 'packer', 'packer-builder-openstack', 'packer-builder-virtualbox', 'packer-command-build', 'packer-command-fix', 'packer-command-inspect', 'packer-command-validate', 'packer-provisioner-file', 'packer-provisioner-shell' ] %}


{%- if pillar.packer.builder.enabled %}

include:
- packer.params

{% if kernel == "Linux" %}

packer_packages:
  pkg.installed:
  - names:
    - unzip

/srv/packer:
  file:
  - directory

{%- for image in pillar.packer.builder.images %}

{{ image.address }}:
  git.latest:
  - target: /srv/packer/{{ image.name }}
  - rev: {{ image.branch }}
  - require:
    - file: /srv/packer

{%- endfor %}

/usr/local/packer:
  file:
  - directory

packer_download_package:
  cmd.run:
  - name: wget {{ packer_base_url }}/{{ packer_base_file }}
  - unless: "[ -f /root/{{ packer_base_file }} ]"
  - cwd: /root

packer_unzip_package:
  cmd.run:
  - name: unzip {{ packer_base_file }} -d /usr/local/packer
  - unless: "[ -f /usr/local/packer/packer ]"
  - require:
    - pkg: packer_packages
    - file: /usr/local/packer
    - cmd: packer_download_package

{%- for binary in packer_binaries %}

/usr/bin/{{ binary }}:
  file.symlink:
  - target: /usr/local/packer/{{ binary }}
  - require:
    - cmd: packer_unzip_package

{%- endfor %}

{% elif kernel == "Windows" %}

packer_install_package:
  pkg.installed:
  - name: packer_x64_en

{%- endif %}

{%- endif %}
