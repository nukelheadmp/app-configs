_ansible-passbolt() {
  local directory="$1"
  shift

  if [[ -z "$1" ]]; then
    echo -e "Usage: ansible-${directory} <playbook> [options...]"
    return 1
  fi

  if [[ "$PWD" != "${PROJECTSDIR}/ansible-${directory}" ]]; then
    echo -e " -> Moving to ansible directory..."
    cd ${PROJECTSDIR}/ansible-${directory}
  fi

  local playbook="playbooks/${1}"

  if [[ ! -f "${playbook}" ]]; then
    echo -e "Error: Playbook not found: ${playbook}"
    return 1
  fi

  if [[ -z "${VIRTUAL_ENV:-}" || "${VIRTUAL_ENV}" != "${PYENV_PATH}/ansible" ]]; then
    activate ansible
  fi

  ansible-playbook "$playbook" "${@:2}" \
    -i inventories/production/ \
    --extra-vars @~/.ansible/vaults/vault_passbolt.yml \
    --ask-vault-pass
}

ansible-servers() { _ansible-passbolt servers "$@"; }
