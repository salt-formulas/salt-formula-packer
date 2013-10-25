
include:
- packer.params
{%- if pillar.packer.builder is defined %}
- packer.builder
{%- endif %}
