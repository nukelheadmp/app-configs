#!/bin/bash

if [[ -z ${PROJECTSDIR:-} ]]; then
  export PROJECTSDIR=$HOME/Projects
  export PYENV_PATH=$HOME/.local/lib/python
  export ANSIBLE_VAULTS=$HOME/.ansible/vaults
  cp $PROJECTSDIR/installation-scripts/env/projects.sh $HOME/.config/environment.d/
fi

sudo dnf install -y \
  ansible \
  python3 \
  sshpass

mkdir -p $PROJECTSDIR
git clone https://github.com/passbolt/passbolt-ansible-lookup-plugin.git $PROJECTSDIR/passbolt-ansible-lookup-plugin
cd $PROJECTSDIR/passbolt-ansible-lookup-plugin

python3 -m venv $PYENV_PATH/ansible
source $PYENV_PATH/ansible/bin/activate
pip install -r passbolt/passbolt_lookup/requirements.txt
pip install pywinrm

ansible-galaxy collection install ./passbolt --force

mkdir -p $ANSIBLE_VAULTS

cp vault_passbolt.yml $ANSIBLE_VAULTS/vault_passbolt.yml
