# Rails Starter

A Dockerized Ruby on Rails application boilerplate for development and production.

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

    ```sh
    git clone --depth=1 git@github.com:sonofborge/rails-starter.git <my-project> \
    && cd $_ \
    && rm -rf .git
    ```

2.  Drop into a shell on a temporary docker container based on the Ruby image version specified in
    `docker/Dockerfile`.

    ```sh
    docker run --rm -v ${PWD}:/app -w /app -it ruby:<version> /bin/bash
    ```

3.  From within the container, install rails.

    ```sh
    gem install rails
    ```

4.  Still inside the container, generate your new rails application using whatever
    [flags](https://guides.rubyonrails.org/command_line.html#rails-new) you wish to pass.

    For example:

    ```sh
    rails new . --database=postgresql --skip-test --skip-puma
    ```

    When prompted to overwrite files, select `a` to continue. Once this completes, you can exit the container.

    ```sh
    exit
    ```

5.  Create a `.env` file and set the `PROJECT_NAME` variable to the name of the project root directory.

    ```sh
    echo "PROJECT_NAME=${PWD##*/}" >> .env.dist && cp .env{.dist,}
    ```

6.  We're now ready to spin it all up.

    ```sh
    docker compose up -d
    ```

7.  In a browser, navigate to `localhost:<PORT>`, where `<PORT>` is the port number specified in your `.env` file.

## License

This project is licensed under the MIT License - see the [LICENSE](./LICENSE) file for details.
