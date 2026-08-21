#!/bin/bash

${HOME}/.local/share/app-configs/install-packages.sh

${HOME}/.local/share/app-configs/install-synology.sh

${HOME}/.local/share/app-configs/ca-trust.sh

${HOME}/.local/share/app-configs/check-ssh-agent.sh

${HOME}/.local/share/app-configs/config-git.sh

${HOME}/.local/share/app-configs/config-env.sh

${HOME}/.local/share/app-configs/clone_playbooks.sh

${HOME}/.local/share/app-configs/run_playbooks.sh

${HOME}/.local/share/app-configs/install-ansible_plugins.sh

echo "A reboot, or logging out and back in recommended."
read -p "Reboot now? [y/n]: " reboot_confirm
if [[ -n $reboot_confirm && ($reboot_confirm == "y" || $reboot_confirm == "Y") ]]; then
  reboot
fi
