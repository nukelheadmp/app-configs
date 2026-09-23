#!/bin/bash

echo "Clone Ansible playbook repos"
if [[ ! -d ${HOME}/Projects/ansible-network/ ]]; then
  git clone git@gitlab.priefert.com:infotech/ansible-network.git ${HOME}/Projects/ansible-network
else
  echo "Directory ${HOME}/Projects/ansible-network/ already exists."
fi

if [[ ! -d ${HOME}/Projects/ansible-servers/ ]]; then
  git clone git@gitlab.priefert.com:infotech/ansible-servers.git ${HOME}/Projects/ansible-servers
else
  echo "Directory ${HOME}/Projects/ansible-servers/ already exists."
fi

if [[ ! -d ${HOME}/Projects/switch_configs/ ]]; then
  git clone git@gitlab.priefert.com:infotech/switch_configs.git ${HOME}/Projects/switch_configs
else
  echo "Directory ${HOME}/Projects/switch_configs/ already exists."
fi
