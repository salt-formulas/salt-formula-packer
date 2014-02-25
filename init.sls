
include:
{%- if pillar.packer.builder is defined %}
- packer.builder
{%- endif %}
