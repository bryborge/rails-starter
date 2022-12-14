# Base Image
#   - Repo: https://hub.docker.com/r/phusion/passenger-ruby31
#   - Docs: https://github.com/phusion/passenger-docker
FROM phusion/passenger-ruby31 as builder
LABEL maintainer="Bryan Borgeson <bryborge@gmail.com>"

WORKDIR /app

RUN apt-get update \
  && apt-get install -y --no-install-recommends build-essential curl libpq-dev \
  && rm -rf /var/lib/apt/lists/* /usr/share/doc /usr/share/man \
  && apt-get clean

COPY --chown=app:app Gemfile* .
RUN bundle install --jobs "$(nproc)"

CMD ["bash"]

################################################################################

FROM phusion/passenger-ruby31 as runner
LABEL maintainer="Bryan Borgeson <bryborge@gmail.com>"

WORKDIR /app

# Copy over bundler build files.
COPY --chown=app:app --from=builder /usr/local/rvm/ /usr/local/rvm/

# Enable Nginx and Passenger.
RUN rm -f /etc/service/nginx/down && \
    rm /etc/nginx/sites-enabled/default

RUN apt-get update \
  && apt-get install -y --no-install-recommends build-essential curl gettext libpq-dev \
  && rm -rf /var/lib/apt/lists/* /usr/share/doc /usr/share/man \
  && apt-get clean

COPY --chown=app:app . .

# Configure Nginx.
COPY ./docker/nginx/00_app_env.conf /etc/nginx/conf.d/00_app_env.conf
COPY ./docker/nginx/app.conf /etc/nginx/sites-enabled/app.conf

# Bootstrap application for given environment.
RUN mkdir -p /etc/my_init.d
COPY ./docker/bootstrap.sh /etc/my_init.d/bootstrap.sh

# Better handling of the init process in a container context.
#   - Article: https://blog.phusion.nl/2015/01/20/docker-and-the-pid-1-zombie-reaping-problem/
ENTRYPOINT ["/sbin/my_init"]

EXPOSE 80
