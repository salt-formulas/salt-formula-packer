{% set kernel = salt['grains.item']('kernel')['kernel'] %}

{% set os = salt['grains.item']('os')['os'] %}

{% set os_arch = salt['grains.item']('osarch')['osarch'] %}

{% if pillar.packer.builder.version is defined %}
{% set packer_version = pillar.packer.builder.version %}
{% else %}
{% set packer_version = '0.3.10' %}
{% endif %}

{% set packer_binaries = ['packer', 'packer-builder-openstack', 'packer-builder-virtualbox'] %}
