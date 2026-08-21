#!/bin/bash

if [[ ! -d ${HOME}/.local/share/passbolt-ansible-lookup-plugin/ ]]; then
  echo "Clone Ansible Passbolt plugin repo"
  git clone https://github.com/passbolt/passbolt-ansible-lookup-plugin.git ${HOME}/.local/share/passbolt-ansible-lookup-plugin
  cd ${HOME}/.local/share/passbolt-ansible-lookup-plugin
else
  echo "Directory ${HOME}/.local/share/passbolt-ansible-lookup-plugin/ already exists."
fi

echo "Set up python environment"
python3 -m venv ${HOME}/.local/lib/python/ansible
activate ansible
pip install -r passbolt/passbolt_lookup/requirements.txt
pip install pywinrm ncclient jxmlease xmltodict

echo "Install Passbolt plugin"
ansible-galaxy collection install ./passbolt --force

if [[ ! -f ${HOME}/.ansible/vaults/vault_passbolt.yml ]]; then
  echo "Copy Ansible/Passbolt config file"
  mkdir -p ${HOME}/.ansible/vaults
  cp ${HOME}/.local/share/app-configs/files/vault_passbolt.yml ${HOME}/.ansible/vaults/vault_passbolt.yml
fi

echo "Install Collections"
ansible-galaxy collection install microsoft.ad --force
ansible-galaxy collection install juniper.device
