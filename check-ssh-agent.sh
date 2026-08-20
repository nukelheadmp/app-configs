#!/bin/bash
# TODO: clean this up...

echo "Check SSH Agent"

local agent_status
set -euo pipefail

has_agent() {
  [[ -n "${SSH_AUTH_SOCK:-}" && -S "$SSH_AUTH_SOCK" ]]
}

if ! has_agent; then
  echo "SSH agent is not running (SSH_AUTH_SOCK unset or not a socket)."
  status=2
elif ssh-add -l >/dev/null 2>&1; then
  # ssh-add -l exit codes:
  #   0 = identities present
  #   1 = agent running, no identities
  #   2 = cannot connect to agent
  echo "SSH agent is running and has keys:"
  ssh-add -l
  status=0
else
  status=$?
  if [[ $status -eq 1 ]]; then
    echo "SSH agent is running but has no keys loaded."
    status=1
  else
    echo "Cannot talk to SSH agent (exit $status)."
    status=2
  fi
fi

if [[ $status > 0 ]]; then
  echo "You must configure KeePass with SSH Agent and load your key."
  echo "Configure your SSH Agent and run ~/.local/share/app-configs/run_all.sh again."
  exit 0
fi
