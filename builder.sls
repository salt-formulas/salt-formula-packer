
{% if pillar.packer.builder.version is defined %}
{% set packer_version = pillar.packer.builder.version %}
{% else %}
{% set packer_version = '0.5.2' %}
{% endif %}

{% set packer_base_url = 'https://dl.bintray.com/mitchellh/packer' %}

{% set packer_base_file_fragments = [ packer_version, '_', grains.kernel|lower, '_', grains.osarch, '.zip' ] %}
{% set packer_base_file = packer_base_file_fragments|join("") %}

{% set packer_binaries = [ 'packer', 'packer-builder-digitalocean', 'packer-command-build', 'packer-post-processor-vagrant', 'packer-provisioner-puppet-masterless', 'packer-builder-amazon-chroot', 'packer-builder-openstack', 'packer-command-fix', 'packer-provisioner-ansible-local', 'packer-provisioner-salt-masterless', 'packer-builder-amazon-ebs', 'packer-builder-virtualbox', 'packer-command-inspect', 'packer-provisioner-chef-solo', 'packer-provisioner-shell', 'packer-builder-amazon-instance', 'packer-builder-vmware', 'packer-command-validate', 'packer-provisioner-file' ] %}

{%- if pillar.packer.builder.enabled %}

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

{%- for image in pillar.packer.builder.images %}
{{ image.address }}:
  git.latest:
  - target: /srv/packer/templates/{{ image.name }}
  - rev: {{ image.branch }}
  - require:
    - file: /srv/packer/templates
  - require_in:
    - cmd: packer_templates_mode
{%- endfor %}

/usr/local/packer:
  file.directory

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

packer_templates_mode:
  cmd.run:
  - name: chmod 0777 /srv/packer/templates -R

{% elif grains.kernel == "Windows" %}

packer_install_package:
  pkg.installed:
  - name: packer_x64_en

{%- endif %}

{%- endif %}
