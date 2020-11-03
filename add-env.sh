#!/bin/bash
set -e

echo '#!/bin/bash' > $(dirname $0)/tmp.sh
echo 'set -e' >> $(dirname $0)/tmp.sh
echo '' >> $(dirname $0)/tmp.sh

echo '# Environment variables:' >> $(dirname $0)/tmp.sh

echo $WWW_SUBDOMAIN >> $(dirname $0)/tmp.sh
echo $API_SUBDOMAIN >> $(dirname $0)/tmp.sh
echo $BRANCH >> $(dirname $0)/tmp.sh
echo $DOMAIN >> $(dirname $0)/tmp.sh
echo $PROJECT_DIRECTORY >> $(dirname $0)/tmp.sh
echo $ENV >> $(dirname $0)/tmp.sh

# declare -px | while read line; do
#   echo $line >> $(dirname $0)/tmp.sh
# done

echo '' >> $(dirname $0)/tmp.sh
echo '# Commands:' >> $(dirname $0)/tmp.sh
cat $(dirname $0)/_ssh-script-deploy.sh >> $(dirname $0)/tmp.sh

mv $(dirname $0)/tmp.sh $(dirname $0)/ssh-script-deploy.sh
chmod +x $(dirname $0)/ssh-script-deploy.sh
