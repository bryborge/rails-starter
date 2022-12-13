#!/usr/bin/env bash

# net-ssh bug; this can be removed once we remove capistrano
#   - https://stackoverflow.com/questions/10391298/error-non-absolute-home-via-netssh
export HOME="/app"

set -o errexit  # Short-circuit the script run immediately when any command fails
set -o pipefail # If a command in a pipeline fails use that as the return code of the whole pipeline

setup_local() {
  if test -f $HOME/.env; then
    echo "Removing existing .env"
    rm $HOME/.env
  fi

  # boostrap env with .env
  echo "Creating .env from .env.dist"
  cp $HOME/.env.dist $HOME/.env
  source $HOME/.env

  # Copy configs from dist and populate from ENV
  if test -f $HOME/config/database.yml; then
    echo "Removing existing database.yml"
    rm $HOME/config/database.yml
  fi

  echo "Creating new database.yml from .dist"
  envsubst < $HOME/config/database.yml.dist > $HOME/config/database.yml

  echo "Enabling nginx configuration"
  envsubst < $HOME/docker/nginx.conf > /etc/nginx/sites-enabled/nginx.conf
}

# setup_ecs() {
#   envsubst < $HOME/docker/nginx.conf > /etc/nginx/sites-enabled/rails.conf
#   # Set this here instead of Dockerfile to make it clear it is only used for ECS
#   AWS_PROFILE="default"

#   fetch-task() {
#     # https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task-metadata-endpoint-v4.html
#     curl -s "${ECS_CONTAINER_METADATA_URI_V4}"/task
#   }

#   parse-region() {
#     # It isn't possible to get ECS region directly: https://github.com/aws/containers-roadmap/issues/337
#     # fetch it from the `.AvailabilityZone` and remove the last char
#     fetch-task | jq -r '.AvailabilityZone' | sed 's/.$//' # "us-west-2d" -> "us-west-2"
#   }

#   parse-cluster-arn() {
#     fetch-task | jq -r '.Cluster'
#   }

#   fetch-tags() {
#     aws ecs list-tags-for-resource --resource-arn "$(parse-cluster-arn)"
#   }

#   fetch-tag-stage() {
#     fetch-tags | jq -r '.tags[] | select(.key | contains("Stage")) | .value'
#   }

#   fetch-tag-environment() {
#     fetch-tags | jq -r '.tags[] | select(.key | contains("Environment")) | .value'
#   }

#   fetch-database-yml() {
#     aws secretsmanager get-secret-value --secret-id "/account-service/${STAGE}/database_yml" | jq -r '.SecretString'
#   }

#   fetch-application-yml() {
#     aws secretsmanager get-secret-value --secret-id "/account-service/${STAGE}/application_yml" | jq -r '.SecretString'
#   }

#   configure-aws() {
#     aws configure set region "$AWS_REGION"
#   }

#   configure-nginx() {
#     envsubst < $HOME/docker/nginx.conf > /etc/nginx/sites-enabled/rails.conf
#   }

#   precompile-assets() {
#     RAILS_ENV=$1
#     export RAILS_ENV
#     cd $HOME
#     bundle exec rails assets:precompile
#   }

#   # main
#   AWS_REGION=$(parse-region)
#   STAGE=$(fetch-tag-stage)
#   ENVIRONMENT=$(fetch-tag-environment) # export separately to avoid masking: https://github.com/koalaman/shellcheck/wiki/SC2155
#   export ENVIRONMENT                   # export needed for envsubst'ing nginx.conf

#   configure-aws
#   fetch-database-yml > $HOME/config/database.yml
#   fetch-application-yml > $HOME/config/application.yml
#   configure-nginx
#   precompile-assets $ENVIRONMENT
# }

# main
if [ "${LOCAL}" = true ]; then
  setup_local
  $HOME/docker/scripts/provision-dbs.sh
# else
#   setup_ecs
fi
