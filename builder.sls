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


{%- endfor %}

/usr/local/packer:
  file:
  - directory

packer_download_package:
  cmd.run:
  - name: wget https://dl.bintray.com/mitchellh/packer/{{ pillar.packer.builder.version }}_{{ kernel|lower }}_{{ os_arch }}.zip
  - unless: "[ -f /root/{{ pillar.packer.builder.version }}_{{ kernel|lower }}_{{ os_arch }}.zip ]"
  - cwd: /root

packer_unzip_package:
  cmd.run:
  - name: unzip {{ pillar.packer.builder.version }}_{{ kernel|lower }}_{{ os_arch }}.zip -d /usr/local/packer
  - unless: "[ -f /usr/local/packer/packer ]"
  - require:
    - pkg: packer_packages
    - file: /usr/local/packer
    - cmd: packer_download_package

/usr/bin/packer:
  file.symlink:
  - target: /usr/local/packer/packer
  - require:
    - cmd: packer_unzip_package

/usr/bin/packer-builder-openstack:
  file.symlink:
  - target: /usr/local/packer/packer-builder-openstack
  - require:
    - cmd: packer_unzip_package

/usr/bin/packer-builder-virtualbox:
  file.symlink:
  - target: /usr/local/packer/packer-builder-virtualbox
  - require:
    - cmd: packer_unzip_package

/usr/bin/packer-command-build:
  file.symlink:
  - target: /usr/local/packer/packer-command-build
  - require:
    - cmd: packer_unzip_package

/usr/bin/packer-command-fix:
  file.symlink:
  - target: /usr/local/packer/packer-command-fix
  - require:
    - cmd: packer_unzip_package

/usr/bin/packer-command-inspect:
  file.symlink:
  - target: /usr/local/packer/packer-command-inspect
  - require:
    - cmd: packer_unzip_package

/usr/bin/packer-command-validate:
  file.symlink:
  - target: /usr/local/packer/packer-command-validate
  - require:
    - cmd: packer_unzip_package

/usr/bin/packer-provisioner-file:
  file.symlink:
  - target: /usr/local/packer/packer-provisioner-file
  - require:
    - cmd: packer_unzip_package

/usr/bin/packer-provisioner-shell:
  file.symlink:
  - target: /usr/local/packer/packer-provisioner-shell
  - require:
    - cmd: packer_unzip_package

{% elif kernel == "Windows" %}

packer_install_package:
  pkg.installed:
  - name: packer_x64_en

{%- endif %}

{%- endif %}
