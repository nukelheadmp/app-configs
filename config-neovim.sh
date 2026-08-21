#!/bin/bash

echo "Configure Neovim"
cd ${HOME}/Projects/ansible-servers/
ansible-playbook -i localhost, -c local --ask-become-pass playbooks-local/config-neovim.yml
