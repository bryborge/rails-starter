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
    make init
    ```

3.  We're now ready to spin it all up.

    ```sh
    make up
    ```

4.  In a browser, navigate to `localhost:<HOST_APP_PORT>`, where `<HOST_APP_PORT>` is the port number specified in your
    `.env` file (defaults to `3000`).

## License

This project is licensed under the MIT License - see the [LICENSE](./LICENSE) file for details.
