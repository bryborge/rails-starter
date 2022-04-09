FROM ruby:3.1.0

ARG RAILS_ROOT=/var/app/current
ARG PACKAGES="npm"

ENV RAILS_ENV=development

RUN apt update && \
    apt install -y ${PACKAGES} && \
    npm install -g yarn

RUN mkdir -p $RAILS_ROOT
COPY . $RAILS_ROOT
WORKDIR $RAILS_ROOT

RUN bundle install
