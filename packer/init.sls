
include:
{%- if pillar.packer.build is defined %}
- packer.build
{%- endif %}
