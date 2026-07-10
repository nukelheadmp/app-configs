#!/bin/bash

sudo dnf install -y \
  dnf-plugins-core \
  openssl

sudo dnf install -y \
  https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
  https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y

sudo dnf install -y akmod-nvidia xorg-x11-drv-nvidia-cuda

sudo usermod -aG render,video $USER

sudo reboot
