# Rails Starter

A Dockerized Ruby on Rails application boilerplate for local development!

## Built With

*   [Docker](https://docs.docker.com/get-docker/) - Engine for building/containerizing applications
*   [Docker Compose](https://docs.docker.com/compose/install/) - Container orchestration tool

## Getting Started

These instructions will walk you through the process of setting up this project on a development machine.

### Prerequisites

*   Docker
*   Docker Compose
*   Git

### Installing

1.  Clone the project (replacing `<my-project>` with the desired project name), delete `.git` directory, and
    reinitialize git.

    ```shell
    git clone --depth=1 git@github.com:sonofborge/rails-starter.git <my-project> && \
    cd $_ && \
    rm -rf .git && \
    git init
    ```

2.  Drop into a shell on a temporary docker container based on the Ruby image version specified in
    `docker/dev/Dockerfile`.

    ```shell
    docker run --rm -v ${PWD}:/var/app/current -w /var/app/current -it ruby:3.1.0 /bin/bash
    ```

3.  From within the container, install rails.

    ```shell
    gem install rails
    ```

4.  Still inside the container, generate your new rails application using whatever
    [flags](https://guides.rubyonrails.org/command_line.html#rails-new) you wish to pass.

    For example:

    ```shell
    rails new . --database=postgresql --webpack=react --skip-test --api
    ```

    Once this completes, you can exit the container.

    ```shell
    exit
    ```

5.  Move the `database.yml` file at the root of the project into the `config/` directory, replacing the one
    rails generated for us.

    ```shell
    mv database.yml config/database.yml
    ```

6.  Create a `.env` file and set the `PROJECT_NAME` variable to the name of the project root directory.

    ```shell
    echo "PROJECT_NAME=${PWD##*/}" >> .env.dist && \
    cp .env{.dist,}
    ```

7.  We're now ready to spin it all up.

    ```shell
    docker-compose up -d
    ```

8.  In a browser, navigate to `localhost:<PORT>`, where `<PORT>` is the port number specified in your `.env` file.

## License

This project is licensed under the MIT License - see the [LICENSE](./LICENSE.md) file for details.
