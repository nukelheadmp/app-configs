#!/bin/bash

echo "Checking environment variables"
if [[ -z ${ANSIBLE_VAULTS:-} ]]; then
  echo "Setting required variables"
  export ANSIBLE_VAULTS=${HOME}/.ansible/vaults
  export PLAYBOOKPATH=${HOME}/Projects
  export PYENV_PATH=${HOME}/.local/lib/python
fi

source ${HOME}/.local/share/app-configs/install-packages.sh

source ${HOME}/.local/share/app-configs/install-synology.sh

source ${HOME}/.local/share/app-configs/ca-trust.sh

source ${HOME}/.local/share/app-configs/check-ssh-agent.sh

source ${HOME}/.local/share/app-configs/config-git.sh

source ${HOME}/.local/share/app-configs/config-env.sh

source ${HOME}/.local/share/app-configs/clone_playbooks.sh

source ${HOME}/.local/share/app-configs/install-neovim.sh

source ${HOME}/.local/share/app-configs/install-ansible_plugins.sh

source ${HOME}/.local/share/app-configs/config-neovim.sh

echo "A reboot, or logging out and back in recommended."
read -p "Reboot now? [y/n]: " reboot_confirm
if [[ -n $reboot_confirm && ($reboot_confirm == "y" || $reboot_confirm == "Y") ]]; then
  reboot
fi
