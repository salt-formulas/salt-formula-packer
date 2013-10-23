{% set kernel = salt['grains.item']('kernel')['kernel'] %}

{% set os = salt['grains.item']('os')['os'] %}

{% set os_arch = salt['grains.item']('osarch')['osarch'] %}

{% set packer_binaries = [''] %}
