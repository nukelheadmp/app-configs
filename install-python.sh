#!/bin/bash

echo "Installing required packages"
source /etc/os-release
if [[ $ID == "fedora" ]]; then
  sudo dnf install -y \
    python3 \
    python3-pip \
elif [[ $ID == "almalinux" ]]; then
  sudo dnf install -y \
    python3 \
    python3-pip \
else
  echo "Cound not determine OS.  The distribution might not be compatible with this script."
  echo -n 1 -s -r -p "Press any key to continue..."
fi

mkdir -p ${HOME}/.bashrc.d
cp ${HOME}/.local/share/app-configs/bashrc.d/python.sh ${HOME}/.bashrc.d/
