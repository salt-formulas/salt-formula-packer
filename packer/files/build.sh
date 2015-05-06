#!/bin/bash

{%- set template = salt['pillar.get']('packer:build:system:'+system_name+':template:'+template_name) %}

#export $VMWARE_BOX_DIR='/srv/packer/build/vmware'
#export $VIRTUALBOX_BOX_DIR ='/srv/packer/build/virtualbox'
#export $PARALLELS_BOX_DIR='/srv/packer/build/parallels'

cd /srv/packer/templates/{{ system_name }}

packer build -only={{ builder }}-iso -var 'iso_path=/srv/packer/iso' -var 'cm={{ template.provisioner }}' -var 'version=current' {{ template.file }}

mv ./box/{{ builder }}/{{ template.file|split('.')[0] }}-{{ provisioner }}-current.box /srv/packer/build/{{ builder }}

cd /srv/packer/build/scripts
