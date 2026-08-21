#!/bin/bash

echo "Configure prompts"
cd ${HOME}/Projects/ansible-servers/
ansible-playbook -i localhost, -c local --ask-become-pass playbooks-local/config-env.yml

echo "Install Neovim"
cd ${HOME}/Projects/ansible-servers/
ansible-playbook -i localhost, -c local --ask-become-pass playbooks-local/install-neovim.yml

echo "Configure Neovim"
cd ${HOME}/Projects/ansible-servers/
ansible-playbook -i localhost, -c local --ask-become-pass playbooks-local/config-neovim.yml
