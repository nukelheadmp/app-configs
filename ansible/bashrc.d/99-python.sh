activate() {
  if [[ -z ${@:-} ]]; then
    echo "You must provide the name of a Python virtual environment"
    return
  elif [[ ! -d "${PYENV_PATH}/${@}" ]]; then

    echo "Virtual environment \"${@}\" does not exist."
    read -p "Would you like to create it? (y/n): " response

    if [[ -n $response && ($response == "y" || $response == "Y") ]]; then
      python3 -m venv $PYENV_PATH/${@}
      source ${PYENV_PATH}/${@}/bin/activate
    fi

    return

  else
    source ${PYENV_PATH}/${@}/bin/activate
  fi
}
