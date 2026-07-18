_ansible-passbolt() {
  local localhost
  local directory

  if [[ "$1" == "local" ]]; then
    localhost=1
    directory="servers"
  else
    localhost=0
    directory="$1"
  fi
  shift

  if [[ -z "$1" ]]; then
    echo -e "Usage: ansible-${directory} <playbook> [options...]"
    return 1
  fi

  if [[ "$PWD" != "${PROJECTSDIR}/ansible-${directory}" ]]; then
    echo -e " -> Moving to ansible directory..."
    cd ${PROJECTSDIR}/ansible-${directory}
  fi

  local playbook="playbooks/${1}.yml"

  if [[ ! -f "${playbook}" ]]; then
    echo -e "Error: Playbook not found: ${playbook}"
    return 1
  fi

  if [[ -z "${VIRTUAL_ENV:-}" || "${VIRTUAL_ENV}" != "${PYENV_PATH}/ansible" ]]; then
    activate ansible
  fi

  if [[ $localhost == 1 ]]; then
    ansible-playbook "$playbook" "${@:2}" \
      -i "localhost," -c local \
      --ask-become-pass
  else
    ansible-playbook "$playbook" "${@:2}" \
      -i inventories/production/ \
      --extra-vars @~/.ansible/vaults/vault_passbolt.yml \
      --ask-vault-pass
  fi
}

ansible-local() { _ansible-passbolt local "$@"; }
ansible-servers() { _ansible-passbolt servers "$@"; }
ansible-network() { _ansible-passbolt network "$@"; }

# Completion for ansible-local, ansible-servers, ansible-network
_ansible_passbolt_completions() {
  local cur prev base_dir playbook_dir command_name
  COMPREPLY=()
  cur="${COMP_WORDS[COMP_CWORD]}"

  # Only complete the playbook name (first argument to the wrapper)
  if [[ ${COMP_CWORD} -eq 1 ]]; then
    command_name="${COMP_WORDS[0]}"

    case "$command_name" in
    ansible-local)
      base_dir="${PROJECTSDIR}/ansible-servers"
      ;;
    ansible-servers)
      base_dir="${PROJECTSDIR}/ansible-servers"
      ;;
    ansible-network)
      base_dir="${PROJECTSDIR}/ansible-network"
      ;;
    *)
      return 0
      ;;
    esac

    playbook_dir="${base_dir}/playbooks"

    if [[ -d "$playbook_dir" ]]; then
      # Suggest playbook names without .yml extension
      COMPREPLY=($(compgen -W "$(find "$playbook_dir" -maxdepth 1 -name '*.yml' -printf '%f\n' | sed 's/\.yml$//')" -- "$cur"))
    fi
  fi
}

# Apply the same completion function to all three commands
complete -F _ansible_passbolt_completions ansible-local
complete -F _ansible_passbolt_completions ansible-servers
complete -F _ansible_passbolt_completions ansible-network
