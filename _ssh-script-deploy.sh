# source ~/.bash_profile

echo "WWW_SUBDOMAIN" $WWW_SUBDOMAIN
echo "API_SUBDOMAIN" $API_SUBDOMAIN
echo "BRANCH" $BRANCH
echo "DOMAIN" $DOMAIN
echo "PROJECT_DIRECTORY" $PROJECT_DIRECTORY
echo "ENV" $ENV

if [[ -z $WWW_SUBDOMAIN || -z $API_SUBDOMAIN || -z $BRANCH || -z $DOMAIN || -z $PROJECT_DIRECTORY || -z $ENV ]]; then
  echo "Invalid configuration"
  exit 1
fi

mkdir -p ~/bin && ln -fs /usr/local/bin/node12 ~/bin/node && ln -fs /usr/local/bin/npm12 ~/bin/npm && source $HOME/.bash_profile

npm install -g yarn@1.22

node -v
yarnpkg -v

cd $PROJECT_DIRECTORY/$ENV

echo "Current directory:" $(pwd)

echo "👉 Pulling from the server…"
git fetch origin --tags
git checkout $BRANCH

git pull origin $BRANCH

echo $ENV:`git rev-parse --abbrev-ref HEAD`:`git rev-parse HEAD` > .version
echo "🥁 VERSION: "$(cat .version)
cp .version apps/api/
cp .version apps/www/

echo "👩‍💻 Installing both API and WWW"
yarnpkg install --frozen-lockfile --ignore-platform --ignore-optional
yarnpkg lerna bootstrap --ci --force-local

echo "👉 Running API migrations…"
NODE_ENV=production ENV=$ENV yarnpkg workspace api db:migrate:up

echo "👉 Restarting API server…"
devil www restart $API_SUBDOMAIN.$DOMAIN
curl --fail -I https://$API_SUBDOMAIN.$DOMAIN

echo "👉 Bulding WWW…"
yarnpkg workspace www rimraf .next/static
yarnpkg workspace www rimraf .next/server
NODE_ENV=production ENV=$ENV yarnpkg workspace www build

echo "👉 Restarting WWW server…"
devil www restart $WWW_SUBDOMAIN.$DOMAIN
curl --fail -I https://$WWW_SUBDOMAIN.$DOMAIN

echo "👉 Done! 😱 👍"
