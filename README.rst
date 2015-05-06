
======
Packer
======

Packer is an open source tool for creating identical machine images for multiple platforms from a single source configuration. Packer is lightweight, runs on every major operating system, and is highly performant, creating machine images for multiple platforms in parallel. 

Sample pillar
=============

Basic linux distros

.. code-block:: yaml

    packer:
      build:
        system:
          ubuntu:
            source:
              engine: git
              address: https://github.com/boxcutter/ubuntu.git
              revision: master
            template:
              ubuntu1404-salt:
                file: ubuntu1404.json
                provisioner: salt
                builders:
                - vmware
                - virtualbox
              ubuntu1504-desktop-salt:
                file: ubuntu1504-desktop.json
                provisioner: salt
                builders:
                - vmware
                - virtualbox

Usage
=====

Openstack image prepare guide

* Install cloud-init - add epel - package epel-centos 6, yum cloud-init
* Set network to DHCP
* /etc/udev.rules/70netrules - remove MAC address records

Read more
=========

* http://www.packer.io/docs/installation.html
* http://www.packer.io/intro/getting-started/setup.html
* https://github.com/mitchellh/packer-ubuntu-12.04-docker
* https://github.com/boxcutter
