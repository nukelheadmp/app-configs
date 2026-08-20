#!/bin/bash

echo "Install Neovim"
cd /opt/ansible-servers/
ansible-playbook -i localhost, -c local --ask-become-pass playbooks-local/install-neovim.yml
