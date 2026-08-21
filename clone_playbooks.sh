#!/bin/bash

echo "Clone Ansible playbook repos"
sudo git clone https://gitlab.priefert.com/infotech/ansible-network.git ${PLAYBOOKPATH}/ansible-network
sudo git clone https://gitlab.priefert.com/infotech/ansible-servers.git ${PLAYBOOKPATH}/ansible-servers
