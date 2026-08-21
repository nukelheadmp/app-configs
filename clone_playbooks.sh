#!/bin/bash

echo "Clone Ansible playbook repos"
if [[ ! -d ${HOME}/Projects/ansible-network/ ]]; then
  sudo git clone git@gitlab.priefert.com:infotech/ansible-network.git ${HOME}/Projects/ansible-network
else
  echo "Directory ${HOME}/Projects/ansible-network/ already exists."
fi

if [[ ! -d ${HOME}/Projects/ansible-servers/ ]]; then
  sudo git clone git@gitlab.priefert.com:infotech/ansible-servers.git ${HOME}/Projects/ansible-servers
else
  echo "Directory ${HOME}/Projects/ansible-servers/ already exists."
fi
