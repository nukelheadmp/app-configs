#!/bin/bash

echo "Installing required packages"
source /etc/os-release
if [[ $ID == "fedora" ]]; then
  sudo dnf install -y \
    libheif-freeworld \
    libheif-tools \
    heif-pixbuf-loader
elif [[ $ID == "almalinux" ]]; then
  echo "I haven't taken the time to fix this yet..."
else
  echo "Cound not determine OS.  The distribution might not be compatible with this script."
  echo -n 1 -s -r -p "Press any key to continue..."
fi
