#!/bin/bash
# check-ssh-agent.sh — verify SSH agent is running and has identities loaded
set -euo pipefail

has_agent() {
  [[ -n "${SSH_AUTH_SOCK:-}" && -S "$SSH_AUTH_SOCK" ]]
}

if ! has_agent; then
  echo "SSH agent is not running (SSH_AUTH_SOCK unset or not a socket)."
  exit 2
fi

# ssh-add -l exit codes:
#   0 = identities present
#   1 = agent running, no identities
#   2 = cannot connect to agent
if ssh-add -l >/dev/null 2>&1; then
  echo "SSH agent is running and has keys:"
  ssh-add -l
  exit 0
else
  status=$?
  if [[ $status -eq 1 ]]; then
    echo "SSH agent is running but has no keys loaded."
    exit 1
  else
    echo "Cannot talk to SSH agent (exit $status)."
    exit 2
  fi
fi
