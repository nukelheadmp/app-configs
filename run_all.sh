#!/bin/bash

echo "Installing required packages"
source /etc/os-release
if [[ $ID == "fedora" ]]; then
  sudo dnf install -y \
    ansible \
    keepassxc \
    python3 \
    python3-pip \
    sshpass
elif [[ $ID == "almalinux" ]]; then
  sudo dnf install -y \
    ansible-core \
    keepassxc \
    python3 \
    python3-pip \
    sshpass
else
  echo "Cound not determine OS.  Please install Ansible and sshpass manually."
  echo -n 1 -s -r -p "Press any key to continue..."
fi

echo "Add trusted CA roots"
${HOME}/.local/share/app-configs/ca-trust.sh

echo "Install Flathub and Synology Drive"
${HOME}/.local/share/app-configs/install-synology.sh

echo "Check SSH Agent"
${HOME}/.local/share/app-configs/check-ssh-agent.sh
check_result=${?}

if [[ $check_result > 0 ]]; then
  echo "You must configure KeePass with SSH Agent and load your key."
  exit 0
fi

echo "Configure git"
${HOME}/.local/share/app-configs/config-git.sh

echo "Checking environment variables"
if [[ -z ${ANSIBLE_VAULTS:-} ]]; then
  echo "Setting required variables"
  export ANSIBLE_VAULTS=$HOME/.ansible/vaults
  export PLAYBOOKPATH=/opt
  export PYENV_PATH=$HOME/.local/lib/python
fi

echo "Configure environment variables and functions"
${HOME}/.local/share/app-configs/config-env.sh

echo "Clone Ansible playbook repos"
${HOME}/.local/share/app-configs/clone_playbooks.sh

echo "Install Neovim"
cd /opt/ansible-servers/
ansible-playbook -i localhost, -c local --ask-become-pass playbooks-local/install-neovim.yml

echo "Clone Ansible Passbolt plugin repo"
git clone https://github.com/passbolt/passbolt-ansible-lookup-plugin.git $HOME/.local/share/passbolt-ansible-lookup-plugin
cd $HOME/.local/share/passbolt-ansible-lookup-plugin

echo "Set up python environment"
python3 -m venv $PYENV_PATH/ansible
activate ansible
pip install -r passbolt/passbolt_lookup/requirements.txt
pip install pywinrm ncclient jxmlease xmltodict

echo "Install Passbolt plugin"
ansible-galaxy collection install ./passbolt --force

if [[ ! -f $ANSIBLE_VAULTS/vault_passbolt.yml ]]; then
  echo "Copy Ansible/Passbolt config file"
  mkdir -p $ANSIBLE_VAULTS
  cp $HOME/.local/share/app-configs/files/vault_passbolt.yml $ANSIBLE_VAULTS/vault_passbolt.yml
  $EDITOR $ANSIBLE_VAULTS/vault_passbolt.yml
fi

echo "Install Collections"
ansible-galaxy collection install microsoft.ad --force
ansible-galaxy collection install juniper.device

echo "A reboot, or logging out and back in recommended."
read -p "Reboot now? [y/n]: " reboot_confirm
if [[ -n $reboot_confirm && ($reboot_confirm == "y" || $reboot_confirm == "Y") ]]; then
  reboot
fi
