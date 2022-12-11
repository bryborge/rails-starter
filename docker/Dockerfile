FROM phusion/passenger-ruby31 as builder
LABEL maintainer="Bryan Borgeson <bryborge@gmail.com>"

WORKDIR /app

RUN apt-get update \
  && apt-get install -y --no-install-recommends build-essential curl libpq-dev \
  && rm -rf /var/lib/apt/lists/* /usr/share/doc /usr/share/man \
  && apt-get clean
#  && apt-get clean \
#  && useradd --create-home ruby \
#  && chown ruby:ruby -R /app

#USER ruby

COPY Gemfile* ./
RUN bundle install --jobs "$(nproc)"

#COPY package.json *yarn* ./
#RUN yarn install

ARG RAILS_ENV="production"
ENV RAILS_ENV="${RAILS_ENV}"
#ENV RAILS_ENV="${RAILS_ENV}" \
#    PATH="${PATH}:/home/ruby/.local/bin" \
#    USER="ruby"

COPY . .

RUN if [ "${RAILS_ENV}" != "development" ]; then \
  SECRET_KEY_BASE=dummyvalue bundle exec rails assets:precompile; fi

CMD ["bash"]

################################################################################

FROM phusion/passenger-ruby31 as runner
LABEL maintainer="Bryan Borgeson <bryborge@gmail.com>"

WORKDIR /app

# Copy over bundler build files and app code
COPY --from=builder /usr/local/rvm/ /usr/local/rvm/

# Nginx and Passenger are disabled by default. Enable them.
RUN rm -f /etc/service/nginx/down && \
    rm /etc/nginx/sites-enabled/default

RUN apt-get update \
  && apt-get install -y --no-install-recommends build-essential curl libpq-dev \
  && rm -rf /var/lib/apt/lists/* /usr/share/doc /usr/share/man \
  && apt-get clean
#  && apt-get clean \
#  && useradd --create-home ruby \
#  && chown ruby:ruby -R /app

#USER ruby

COPY bin/ ./bin
RUN chmod 0755 bin/*

ARG RAILS_ENV="production"
ENV RAILS_ENV="${RAILS_ENV}"
#ENV RAILS_ENV="${RAILS_ENV}" \
#    PATH="${PATH}:/home/ruby/.local/bin" \
#    USER="ruby"

#COPY --from=assets /usr/local/bundle /usr/local/bundle
#COPY --from=assets /app/public /public
COPY ./docker/nginx.conf /etc/nginx/sites-enabled/nginx.conf
COPY . .

# init script that performs better handling of the init process in a container context.
#   Link: https://blog.phusion.nl/2015/01/20/docker-and-the-pid-1-zombie-reaping-problem/
ENTRYPOINT ["/sbin/my_init"]

EXPOSE 80
