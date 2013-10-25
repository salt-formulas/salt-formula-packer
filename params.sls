
{% set kernel = salt['grains.item']('kernel')['kernel'] %}

{% set os = salt['grains.item']('os')['os'] %}

{% set os_arch = salt['grains.item']('osarch')['osarch'] %}

{% if pillar.packer.builder.version is defined %}
{% set packer_version = pillar.packer.builder.version %}
{% else %}
{% set packer_version = '0.3.10' %}
{% endif %}

{% set packer_base_url = 'https://dl.bintray.com/mitchellh/packer' %}

{% set packer_base_file_fragments = [ packer_version, '_', kernel|lower, '_', os_arch, '.zip' ] %}
{% set packer_base_file = ""|join(packer_base_file_fragments) %}

{% set packer_binaries = [ 'packer', 'packer-builder-openstack', 'packer-builder-virtualbox', 'packer-command-build', 'packer-command-fix', 'packer-command-inspect', 'packer-command-validate', 'packer-provisioner-file', 'packer-provisioner-shell' ] %}
