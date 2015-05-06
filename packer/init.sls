
{%- if pillar.packer is defined %}
include:
{%- if pillar.packer.build is defined %}
- packer.build
{%- endif %}
{%- endif %}
