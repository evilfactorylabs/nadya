# check is $NOW_TOKEN exists?
if [[ -z "$NOW_TOKEN" ]]; then
  echo
  echo "> NOW_TOKEN is empty. Deployment cancelled."
  echo
  exit 1
fi

# is this on master branch or something else?
if [[ $TRAVIS_BRANCH == 'master' ]]; then
  ENV_TARGET=production
else
  ENV_TARGET=staging
fi

CHANGES=$(git --no-pager diff --name-only $TRAVIS_COMMIT_RANGE)

deploy_web() {
  # deploy web to target environment
  echo "> Deploying app with $ENV_TARGET environment..."
  cd ./web && now --target $ENV_TARGET --token=$NOW_TOKEN --scope evilfactory
  cd ..
}

deploy_app() {
  # deploy app to target environment
  echo "> Deploying web with $ENV_TARGET environment..."
  cd app && now --target $ENV_TARGET --token=$NOW_TOKEN --scope evilfactory
  cd ..
}

[ -n "$(grep '^web' <<< "$CHANGES")" ] && deploy_web
[ -n "$(grep '^app' <<< "$CHANGES")" ] && deploy_app

echo "> Done"
