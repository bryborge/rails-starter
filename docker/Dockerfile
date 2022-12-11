FROM phusion/passenger-ruby31 as builder
LABEL maintainer="Bryan Borgeson <bryborge@gmail.com>"

WORKDIR /app

RUN apt-get update \
  && apt-get install -y --no-install-recommends build-essential curl libpq-dev \
  && rm -rf /var/lib/apt/lists/* /usr/share/doc /usr/share/man \
  && apt-get clean \
  && useradd --create-home ruby \
  && chown ruby:ruby -R /app

USER ruby

COPY --chown=ruby:ruby Gemfile* ./
RUN bundle install --jobs "$(nproc)"

COPY --chown=ruby:ruby package.json *yarn* ./
RUN yarn install

ARG RAILS_ENV="production"
ENV RAILS_ENV="${RAILS_ENV}" \
    PATH="${PATH}:/home/ruby/.local/bin" \
    USER="ruby"

COPY --chown=ruby:ruby . .

RUN if [ "${RAILS_ENV}" != "development" ]; then \
  SECRET_KEY_BASE=dummyvalue rails assets:precompile; fi

CMD ["bash"]

################################################################################

FROM phusion/passenger-ruby31 as runner
LABEL maintainer="Bryan Borgeson <bryborge@gmail.com>"

WORKDIR /app

RUN apt-get update \
  && apt-get install -y --no-install-recommends build-essential curl libpq-dev \
  && rm -rf /var/lib/apt/lists/* /usr/share/doc /usr/share/man \
  && apt-get clean \
  && useradd --create-home ruby \
  && chown ruby:ruby -R /app

USER ruby

COPY --chown=ruby:ruby bin/ ./bin
RUN chmod 0755 bin/*

ARG RAILS_ENV="production"
ENV RAILS_ENV="${RAILS_ENV}" \
    PATH="${PATH}:/home/ruby/.local/bin" \
    USER="ruby"

COPY --chown=ruby:ruby --from=assets /usr/local/bundle /usr/local/bundle
COPY --chown=ruby:ruby --from=assets /app/public /public
COPY --chown=ruby:ruby . .

#ENTRYPOINT ["/app/bin/docker-entrypoint-web"]

# init script that performs better handling of the init process.
#   Link: https://blog.phusion.nl/2015/01/20/docker-and-the-pid-1-zombie-reaping-problem/
ENTRYPOINT ["/sbin/my_init"]

EXPOSE 80

CMD ["rails", "s"]
