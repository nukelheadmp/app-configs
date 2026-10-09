curl -fsSL https://x.ai/cli/install.sh | bash

mkdir -p ${HOME}/.config/environment.d
cp ${HOME}/.local/share/app-configs/environment.d/grok.conf ${HOME}/.config/environment.d/
