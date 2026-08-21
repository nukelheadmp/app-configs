#!/bin/bash

echo "Checking environment variables"
if [[ -z ${ANSIBLE_VAULTS:-} ]]; then
  echo "Setting required variables"
  export ANSIBLE_VAULTS=${HOME}/.ansible/vaults
  export PLAYBOOKPATH=${HOME}/Projects
  export PYENV_PATH=${HOME}/.local/lib/python
fi

echo "Install environment conf files"
mkdir -p ${HOME}/.config/environment.d
cp ${HOME}/.local/share/app-configs/environment.d/* ${HOME}/.config/environment.d/

echo "Add bash functions"
if [[ ! -d ${HOME}/.bashrc.d ]]; then
  mkdir -p ${HOME}/.bashrc.d
fi

cp ${HOME}/.local/share/app-configs/bashrc.d/* ${HOME}/.bashrc.d/
