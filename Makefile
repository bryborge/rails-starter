RAILS_ENV ?= development
RUBY_VERSION ?= `cat .ruby-version`

default: bash

# PROJECT INITIALIZATION #######################################################

init:
	docker run --rm \
		-v ${PWD}:/app \
		-w /app -it ruby:${RUBY_VERSION} \
		/bin/bash -c "gem install rails; rails new . --database=postgresql --skip-test --force"
	@printf "APP_NAME=%s" `basename ${PWD}` >> .env.dist
	@cp .env{.dist,}

# BASE COMMANDS ################################################################

up:
	docker compose up -d

down:
	docker compose down

build:
  docker compose build

rebuild:
	docker compose build --force-rm --no-cache

# EXEC COMMANDS ################################################################

bash:
	docker compose exec -e "RAILS_ENV=${RAILS_ENV}" web bash

console:
	docker compose exec -e "RAILS_ENV=${RAILS_ENV}" web bundle exec rails c

dbconsole:
	docker compose exec -e "RAILS_ENV=${RAILS_ENV}" web bundle exec rails dbconsole

# RAILS COMMANDS ###############################################################

bundle:
 	docker compose exec -e "RAILS_ENV=${RAILS_ENV}" web bundle ${CMD}

test:
	docker compose exec -e "RAILS_ENV=test" web bundle exec rspec ${T}

################################################################################

.PHONY: test
