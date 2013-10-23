
# Packer.io

Packer is an open source tool for creating identical machine images for multiple platforms from a single source configuration. Packer is lightweight, runs on every major operating system, and is highly performant, creating machine images for multiple platforms in parallel. 

## Sample pillar

    packer:
      builder:
        enabled: true
        version: 0.3.9
        images:
        - name: somelinux
          source: git@repo.domain.com:packer/ubuntu.git

## Read more

* http://www.packer.io/docs/installation.html
* http://www.packer.io/intro/getting-started/setup.html
* https://github.com/mitchellh/packer-ubuntu-12.04-docker
