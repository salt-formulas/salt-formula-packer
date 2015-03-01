{%- from "packer/map.jinja" import build with context %}
{%- if build.enabled %}

include:
- packer.build.service

{%- for template_name, template in build.template.iteritems() %}
{{ template.source.address }}:
  git.latest:
  - target: /srv/packer/templates/{{ template_name }}
  - rev: {{ template.source.revision }}
  - require:
    - file: /srv/packer/templates
  - require_in:
    - cmd: packer_templates_mode
{%- endfor %}

packer_templates_mode:
  cmd.run:
  - name: chmod 0777 /srv/packer/templates -R

{%- endif %}