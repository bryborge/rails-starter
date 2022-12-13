#!/usr/bin/env bash

set -o errexit
set -o pipefail

HOME="/app"

provision_local_env() {
  if test -f $HOME/.env; then
    echo "### Removing existing env."
    rm $HOME/.env
  fi

  echo "### Creating new env file from dist."
  cp $HOME/.env.dist $HOME/.env
  source $HOME/.env

  if test -f $HOME/config/database.yml; then
    echo "### Removing existing database config."
    rm $HOME/config/database.yml
  fi

  echo "### Creating new database.yml from dist."
  envsubst < $HOME/config/database.yml.dist > $HOME/config/database.yml
}

provision_local_dbs() {
  echo "### Setting up databases."
  bundle exec rails db:drop
  bundle exec rails db:create
  bundle exec rails db:seed

  echo "### Migrating database."
  bundle exec rails db:migrate

  echo "### Setting up test database."
  RAILS_ENV="test" bundle exec rake db:test:prepare
}

case $PASSENGER_APP_ENV in

  development)
    provision_local_env
    provision_local_dbs
    ;;

  # production)
  #   ;;

  *)
    echo "### init script complete."
    ;;
esac
