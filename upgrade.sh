#!/usr/bin/env bash

export ANSIBLE_CONFIG=./ansible.cfg

ansible-playbook -i inventories/inventory.yml playbook-upgrade.yml

