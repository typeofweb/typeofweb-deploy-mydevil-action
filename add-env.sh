#!/bin/bash
set -e

echo '#!/bin/bash' > $(dirname $0)/tmp.sh
echo 'set -e' >> $(dirname $0)/tmp.sh
echo '' >> $(dirname $0)/tmp.sh

# https://github.com/JimCronqvist/action-ssh/blob/7737f1192ddd8376686e9d6354dea44592c942bf/entrypoint.sh#L14-L21
echo '# Environment variables:' >> $(dirname $0)/tmp.sh
declare -px | while read line; do
  echo $line >> $(dirname $0)/tmp.sh
done
echo '' >> $(dirname $0)/tmp.sh
echo '# Commands:' >> $(dirname $0)/tmp.sh
cat $(dirname $0)/_ssh-script-deploy.sh >> $(dirname $0)/tmp.sh

mv $(dirname $0)/tmp.sh $(dirname $0)/ssh-script-deploy.sh
