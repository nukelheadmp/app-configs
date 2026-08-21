#!/bin/bash

echo "Install Neovim"
cd ${HOME}/Projects/ansible-servers/
ansible-playbook -i localhost, -c local --ask-become-pass playbooks-local/install-neovim.yml
