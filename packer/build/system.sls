{%- from "packer/map.jinja" import build with context %}
{%- if build.enabled %}

include:
- packer.build.service

{%- for system_name, system in build.system.iteritems() %}

packer_system_{{ system_name }}:
  git.latest:
  - name: {{ system.source.address }}
  - target: /srv/packer/templates/{{ system_name }}
  - rev: {{ system.source.revision }}
  - require:
    - file: /srv/packer/templates

{%- for template_name, template in system.get('template', {}).iteritems() %}

{%- if pillar.virtualbox is defined %}

/srv/packer/build/scripts/{{ template_name }}-virtualbox.sh:
  file.managed:
  - source: salt://packer/files/build.sh
  - mode: 755
  - template: jinja
  - defaults:
      builder: 'virtualbox'
      provisioner: '{{ template.provisioner }}'
      system_name: "{{ system_name }}"
      template_name: "{{ template_name }}"

{%- endif %}

{%- if pillar.vmware_workstation is defined %}

{%- endif %}

{%- endfor %}

{%- endfor %}

{#
packer_systems_mode:
  cmd.run:
  - name: chmod 0777 /srv/packer/templates -R
#}

{%- endif %}