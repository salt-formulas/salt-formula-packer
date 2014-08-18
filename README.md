
# Packer.io

Packer is an open source tool for creating identical machine images for multiple platforms from a single source configuration. Packer is lightweight, runs on every major operating system, and is highly performant, creating machine images for multiple platforms in parallel. 

## Sample pillar

### Basic linux distros

    packer:
      builder:
        enabled: true
        version: 0.3.10
        template:
          someos:
            source: git
            address: 'git@repo.domain.com:packer/someos.git'
            branch: 'master'

## Usage

Build plain image

    packer build ubuntu1404.json

Build image with Salt provisioner

    packer build -var 'provisioner=salt' ubuntu1404.json

Build image with Puppet provisioner

    packer build -var 'provisioner=puppet' ubuntu1404.json

## Read more

* http://www.packer.io/docs/installation.html
* http://www.packer.io/intro/getting-started/setup.html
* https://github.com/mitchellh/packer-ubuntu-12.04-docker
