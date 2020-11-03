#!/bin/bash
set -e

echo '#!/bin/bash' > ./tmp.sh
echo 'set -e' >> ./tmp.sh
echo '' >> ./tmp.sh

# https://github.com/JimCronqvist/action-ssh/blob/7737f1192ddd8376686e9d6354dea44592c942bf/entrypoint.sh#L14-L21
echo '# Environment variables:' >> ./tmp.sh
declare -px | while read line; do
  echo $line >> ./tmp.sh
done
echo '' >> ./tmp.sh
echo '# Commands:' >> ./tmp.sh
cat ./_ssh-script-deploy.sh >> ./tmp.sh

mv ./tmp.sh ./ssh-script-deploy.sh
