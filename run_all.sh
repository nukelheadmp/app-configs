#!/bin/bash

${HOME}/.local/share/app-configs/ca-trust.sh

${HOME}/.local/share/app-configs/config-git.sh

${HOME}/.local/share/app-configs/install-python.sh

${HOME}/.local/share/app-configs/install-flathub.sh

${HOME}/.local/share/app-configs/install-synology.sh

${HOME}/.local/share/app-configs/install-keepassxc.sh

${HOME}/.local/share/app-configs/install-ansible.sh

${HOME}/.local/share/app-configs/clone_repos.sh

${HOME}/.local/share/app-configs/run_playbooks.sh

${HOME}/.local/share/app-configs/install-grokcli.sh

source ${HOME}/.local/share/app-configs/check-ssh-agent.sh

echo "A reboot, or logging out and back in recommended."
read -p "Reboot now? [y/n]: " reboot_confirm
if [[ -n $reboot_confirm && ($reboot_confirm == "y" || $reboot_confirm == "Y") ]]; then
  reboot
fi
