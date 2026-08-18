#!/bin/bash

sudo flatpak remote-add --system --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
sudo flatpak install --system --noninteractive -y flathub com.synology.SynologyDrive
