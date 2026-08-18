#!/bin/bash

echo "Install environment conf files"
mkdir -p $HOME/.config/environment.d
cp ${HOME}/.local/share/app-configs/environment.d/* $HOME/.config/environment.d/

echo "Add bash functions"
if [[ ! -d $HOME/.bashrc.d ]]; then
  mkdir -p $HOME/.bashrc.d
fi

cp ${HOME}/.local/share/app-configs/bashrc.d/* $HOME/.bashrc.d/
source $HOME/.bashrc
