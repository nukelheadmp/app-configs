#!/bin/bash

cd ${HOME}/Projects/ansible-servers/
ansible-playbook -i localhost, -c local --ask-become-pass playbooks-local/config-env.yml

cd ${HOME}/Projects/ansible-servers/
ansible-playbook -i localhost, -c local --ask-become-pass playbooks-local/install-neovim.yml

cd ${HOME}/Projects/ansible-servers/
ansible-playbook -i localhost, -c local --ask-become-pass playbooks-local/config-neovim.yml
