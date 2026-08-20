#!/bin/bash

echo "Configure Neovim"
cd /opt/ansible-servers/
ansible-playbook -i localhost, -c local --ask-become-pass playbooks-local/config-neovim.yml
