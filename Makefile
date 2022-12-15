RAILS_ENV ?= development
RUN := run --rm
DOCKER_COMPOSE_RUN := docker compose $(RUN)
DOCKER_RUN := docker $(RUN)

default: compose-test

init:
	${DOCKER_RUN} \
		-v ${PWD}:/app \
		-w /app -it ruby:3.1.2 \
		/bin/bash -c "gem install rails; rails new . --database=postgresql --skip-test --force"
	@echo "APP_NAME=${PWD##*/}" >> .env.dist && cp .env{.dist,}

# test:
# 	bundle exec rspec ${T}

# deploy:
# 	${DOCKER_COMPOSE_RUN} --no-deps app bundle exec cap production deploy

# rollback:
# 	${DOCKER_COMPOSE_RUN} --no-deps app bundle exec cap production deploy:rollback

# compose-web:
# 	${DOCKER_COMPOSE_RUN} --service-ports web

# compose-db-prepare: compose-db-create compose-db-migrate

# compose-db-create:
# 	${DOCKER_COMPOSE_RUN} -e "RAILS_ENV=${RAILS_ENV}" web bundle exec rake db:create

# compose-db-migrate:
# 	${DOCKER_COMPOSE_RUN} -e "RAILS_ENV=development" web bundle exec rake db:migrate
# 	${DOCKER_COMPOSE_RUN} -e "RAILS_ENV=test" web bundle exec rake db:migrate

# compose-db-rollback:
# 	${DOCKER_COMPOSE_RUN} -e "RAILS_ENV=development" web bundle exec rake db:rollback
# 	${DOCKER_COMPOSE_RUN} -e "RAILS_ENV=test" web bundle exec rake db:rollback

# compose-db-console:
# 	${DOCKER_COMPOSE_RUN} -e "RAILS_ENV=${RAILS_ENV}" web bundle exec rails dbconsole

# compose-rails-console:
# 	${DOCKER_COMPOSE_RUN} -e "RAILS_ENV=${RAILS_ENV}" web bundle exec rails c

# compose-bash:
# 	${DOCKER_COMPOSE_RUN} -e "RAILS_ENV=${RAILS_ENV}" web bash

# compose-down:
# 	docker compose down

# compose-rails-generate:
# 	${DOCKER_COMPOSE_RUN} web bundle exec rails g ${CMD}

# compose-bundle:
# 	${DOCKER_COMPOSE_RUN} web bundle ${CMD}

compose-test:
	${DOCKER_COMPOSE_RUN} -e "RAILS_ENV=test" web bundle exec rspec ${T}

# compose-build:
# 	docker compose build

# compose-rebuild:
# 	docker compose build --force-rm --no-cache

.PHONY: test
