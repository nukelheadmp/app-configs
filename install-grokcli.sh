curl -fsSL https://x.ai/cli/install.sh | bash

mkdir -p ${HOME}/.config/environment.d
if [[ ! -f ${HOME}/.config/environment.d/grok.conf ]]; then
  echo "Copying template grok.conf"
  cp ${HOME}/.local/share/app-configs/environment.d/grok.conf ${HOME}/.config/environment.d/
else
  echo "grok.conf already present, skipping."
fi
