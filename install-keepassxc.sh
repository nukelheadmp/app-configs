#!/bin/bash

echo "Installing required packages"
source /etc/os-release
if [[ $ID == "fedora" ]]; then
  sudo dnf install -y \
    keepassxc
elif [[ $ID == "almalinux" ]]; then
  flatpak install --noninteractive -y flathub org.keepassxc.KeePassXC
else
  echo "Cound not determine OS.  The distribution might not be compatible with this script."
  echo -n 1 -s -r -p "Press any key to continue..."
fi
