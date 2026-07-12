activate() {
  if [[ -z ${@:-} ]]; then
    echo "You must provide the name of a Python virtual environment"
    return
  elif [[ ! -d "${PYENV_PATH}/${@}" ]]; then
    echo "Virtual environment \"${@}\" does not exist."
    return
  else
    source ${PYENV_PATH}/${@}/bin/activate
  fi
}
