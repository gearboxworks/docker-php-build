![release](https://github.com/gearboxworks/docker-php/workflows/release/badge.svg?event=release)

![PHP 7.2.x](https://img.shields.io/badge/PHP-7.2.x-green.svg)
![PHP 7.1.x](https://img.shields.io/badge/PHP-7.1.x-green.svg)
![PHP 7.0.x](https://img.shields.io/badge/PHP-7.0.x-green.svg)
![PHP 5.6.36](https://img.shields.io/badge/PHP-5.6.36-green.svg)
![PHP 5.5.38](https://img.shields.io/badge/PHP-5.5.38-green.svg)
![PHP 5.4.45](https://img.shields.io/badge/PHP-5.4.45-green.svg)
![PHP 5.3.29](https://img.shields.io/badge/PHP-5.3.29-green.svg)
![PHP 5.2.4](https://img.shields.io/badge/PHP-5.2.4-green.svg)

![Gearbox](https://github.com/gearboxworks/gearbox.github.io/raw/master/Gearbox-100x.png)


# PHP Docker Container for Gearbox
This is the repository for the [PHP](https://php.org/) Docker container implemented for [Gearbox](https://github.com/gearboxworks/gearbox).
It currently provides versions 5.2.4 5.3.29 5.4.45 5.5.38 5.6.36 7.0.x 7.1.x 7.2.x


## Supported tags and respective build directories
`7.2.6`, `7.2`, `latest` _([7.2.6/](https://github.com/gearboxworks/php-docker/blob/master/7.2.6/))_

`7.1.18`, `7.1` _([7.1.18/](https://github.com/gearboxworks/php-docker/blob/master/7.1.18/))_

`7.0.30`, `7.0` _([7.0.30/](https://github.com/gearboxworks/php-docker/blob/master/7.0.30/))_

`5.6.36`, `5.6` _([5.6.36/](https://github.com/gearboxworks/php-docker/blob/master/5.6.36/))_

`5.5.38`, `5.5` _([5.5.38/](https://github.com/gearboxworks/php-docker/blob/master/5.5.38/))_

`5.4.45`, `5.4` _([5.4.45/](https://github.com/gearboxworks/php-docker/blob/master/5.4.45/))_

`5.3.29`, `5.3` _([5.3.29/](https://github.com/gearboxworks/php-docker/blob/master/5.3.29/))_

`5.2.4`, `5.2` _([5.2.4/](https://github.com/gearboxworks/php-docker/blob/master/5.2.4/))_


## Using this container.
If you want to use this container as part of Gearbox, then use the Docker Hub method.
Or you can use the GitHub method to build and run the container.


## Using it from Docker Hub

### Links
(Docker Hub repo)[https://hub.docker.com/r/gearbox/php/]

(Docker Cloud repo)[https://cloud.docker.com/swarm/gearbox/repository/docker/gearbox/php/]


### Setup from Docker Hub
A simple `docker pull gearbox/php` will pull down the latest version.


### Runtime from Docker Hub
start - Spin up a Docker container with the correct runtime configs.

`docker run -d --name php-7.1 --restart unless-stopped --network gearboxnet -p 9000:9000 -v $PROJECT_ROOT:/project --mount type=bind,source=/srv/sites,target=/srv/sites gearbox/php:7.1`

stop - Stop a Docker container.

`docker stop php-7.1`

run - Run a Docker container in the foreground, (all STDOUT and STDERR will go to console). The Container be removed on termination.

`docker run --rm --name php-7.1 --network gearboxnet -p 9000:9000 -v $PROJECT_ROOT:/project --mount type=bind,source=/srv/sites,target=/srv/sites gearbox/php:7.1`

shell - Run a shell, (/bin/bash), within a Docker container.

`docker run --rm --name php-7.1 -i -t --network gearboxnet -p 9000:9000 -v $PROJECT_ROOT:/project --mount type=bind,source=/srv/sites,target=/srv/sites gearbox/php:7.1 /bin/bash`

rm - Remove the Docker container.

`docker container rm php-7.1`


## Using it from GitHub repo

### Setup from GitHub repo
Simply clone this repository to your local machine

`git clone https://github.com/gearboxworks/php-docker.git`


### Building from GitHub repo
`make build` - Build Docker images. Build all versions from the base directory or specific versions from each directory.


`make list` - List already built Docker images. List all versions from the base directory or specific versions from each directory.


`make clean` - Remove already built Docker images. Remove all versions from the base directory or specific versions from each directory.


`make push` - Push already built Docker images to Docker Hub, (only for Gearbox admins). Push all versions from the base directory or specific versions from each directory.


### Runtime from GitHub repo
When you `cd` into a version directory you can also perform a few more actions.

`make start` - Spin up a Docker container with the correct runtime configs.


`make stop` - Stop a Docker container.


`make run` - Run a Docker container in the foreground, (all STDOUT and STDERR will go to console). The Container be removed on termination.


`make shell` - Run a shell, (/bin/bash), within a Docker container.


`make rm` - Remove the Docker container.


`make test` - Will issue a `stop`, `rm`, `clean`, `build`, `create` and `start` on a Docker container.


