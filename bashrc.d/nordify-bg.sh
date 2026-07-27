nordify-bg() {

  if [[ -z "${VIRTUAL_ENV:-}" || "${VIRTUAL_ENV}" != "${PYENV_PATH}/ign" ]]; then
    activate ign
  fi

  python $HOME/.local/lib/nordify-bg.py ${1} ${2}

  deactivate

}
