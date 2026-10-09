#!/bin/bash

echo "Installing required packages"
source /etc/os-release
if [[ $ID == "fedora" ]]; then
  sudo dnf install -y \
    ansible \
    sshpass
elif [[ $ID == "almalinux" ]]; then
  sudo dnf install -y \
    ansible-core \
    sshpass
else
  echo "Cound not determine OS.  The distribution might not be compatible with this script."
  echo -n 1 -s -r -p "Press any key to continue..."
fi

mkdir -p ${HOME}/.config/environment.d
cp ${HOME}/.local/share/app-configs/environment.d/ansible.conf ${HOME}/.config/environment.d/

mkdir -p ${HOME}/.bashrc.d
cp ${HOME}/.local/share/app-configs/bashrc.d/ansible.sh ${HOME}/.bashrc.d/

if [[ ! -d ${HOME}/.local/share/passbolt-ansible-lookup-plugin/ ]]; then
  echo "Clone Ansible Passbolt plugin repo"
  git clone https://github.com/passbolt/passbolt-ansible-lookup-plugin.git ${HOME}/.local/share/passbolt-ansible-lookup-plugin
else
  echo "Directory ${HOME}/.local/share/passbolt-ansible-lookup-plugin/ already exists."
fi

cd ${HOME}/.local/share/passbolt-ansible-lookup-plugin

echo "Set up python environment"
python3 -m venv ${HOME}/.local/lib/python/ansible
source ${HOME}/.local/lib/python/ansible/bin/activate
pip install -r passbolt/passbolt_lookup/requirements.txt
pip install pan-os-python pywinrm ncclient jxmlease xmltodict

echo "Install Passbolt plugin"
ansible-galaxy collection install ./passbolt --force

if [[ ! -f ${HOME}/.ansible/vaults/vault_passbolt.yml ]]; then
  echo "Copy Ansible/Passbolt config file"
  mkdir -p ${HOME}/.ansible/vaults
  cp ${HOME}/.local/share/app-configs/files/vault_passbolt.yml ${HOME}/.ansible/vaults/vault_passbolt.yml
fi

echo "Install Collections"
ansible-galaxy collection install community.network
ansible-galaxy collection install microsoft.ad --force
ansible-galaxy collection install juniper.device
ansible-galaxy collection install paloaltonetworks.panos
