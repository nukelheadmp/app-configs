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
  echo "Cound not determine OS.  The distribution might not be compatible with this script."
  echo -n 1 -s -r -p "Press any key to continue..."
fi
