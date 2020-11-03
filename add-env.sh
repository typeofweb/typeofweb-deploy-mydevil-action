#!/bin/bash
set -e

# https://github.com/JimCronqvist/action-ssh/blob/7737f1192ddd8376686e9d6354dea44592c942bf/entrypoint.sh#L14-L21
echo '# Environment variables:' >> ./ssh-script-deploy.sh
env -0 | while read -r -d '' line; do
  [[ ! ${line} =~ ^(HOSTNAME=|HOME=|INPUT_) ]] && echo "${line%%=*}='$(echo "${line#*=}" | sed "s/'/'\\\\''/g")'" >> ~/ssh-script-deploy.sh
done
echo '' >> ./ssh-script-deploy.sh
echo '# Commands:' >> ./ssh-script-deploy.sh
