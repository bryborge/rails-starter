#!/bin/bash

set -euo pipefail

FORCE="${1:-false}"

# Only run this if the DB does not already exist; 
# or we were explicitly asked to refresh the DB

refresh-db() {
  # Grab DB values
  source "/app/.env"

  printf "\n ### Setting up database.\n"
  bundle exec rails db:reset

  printf "\n ### Migrating database.\n"
  bundle exec rails db:migrate

  printf "\n ### Setting up test database.\n"
  RAILS_ENV="test" bundle exec rake db:test:prepare

  printf "\n ### Done.\n"
}

run() {
  if [ "${FORCE}" == "force" ]; then
    refresh-db
  else
    echo "DB ALREADY EXISTS; NOT RECREATING IT; pass 'force' to this script to do so."
  fi
}

run
