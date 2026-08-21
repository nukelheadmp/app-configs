#!/bin/bash

echo "Clone Ansible playbook repos"
sudo git clone git@gitlab.priefert.com:infotech/ansible-network.git ${HOME}/Projects/ansible-network
sudo git clone git@gitlab.priefert.com:infotech/ansible-servers.git ${HOME}/Projects/ansible-servers
