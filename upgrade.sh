#!/usr/bin/env bash

wakeonlan -i 192.168.1.129 90:2b:34:1e:8a:b8

ansible-playbook -i inventories playbook-upgrade.yml -kK