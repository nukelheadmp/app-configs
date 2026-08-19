#!/bin/bash

echo "Install git"
sudo dnf install git

echo "Clone app-configs"
git clone --depth 1 https://github.com/nukelheadmp/app-configs.git ${HOME}/.local/share/app-configs

echo "Run all configs"
${HOME}/.local/share/app-configs/run_all.sh
