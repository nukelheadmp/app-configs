#!/bin/bash

user_name=$(git config user.name 2>/dev/null)
user_email=$(git config user.email 2>/dev/null)

if [[ -z "${user_name:-}" || -z "${user_email}" ]]; then
  read -p "Enter your full name: " user_name
  read -p "Enter your email: " user_email
  git config --global user.name "$user_name"
  git config --global user.email "$user_email"
fi

git config --global pull.rebase false
git config --global init.defaultBranch master
git config --global push.autoSetupRemote true
