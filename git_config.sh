#!/bin/bash

user_name=$(git config user.name 2>/dev/null)
user_email=$(git config user.email 2>/dev/null)
force_change="n"

if [[ -n "${user_name:-}" ]]; then
  echo "Current settings:"
  echo "Name: $user_name"
  echo "Email: $user_email"
  read -p "Do you want to change settings? [y/n]: " force_change

  if [[ -z "${user_name:-}" || -z "${user_email}" || ( $force_change == "y" || $force_change == "Y" ) ]]; then
  read -p "Enter your full name: " user_name
  read -p "Enter your email: " user_email
  git config --global user.name "$user_name"
  git config --global user.email "$user_email"
fi

git config --global pull.rebase false
git config --global init.defaultBranch master
git config --global push.autoSetupRemote true

