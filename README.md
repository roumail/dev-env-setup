# Dev env setup

This project contains docker-compose files for dev tools like vim and bash. The 
vim setup in particular is meant to allow opening any directory in a pre-configured
Vim environment running inside a Docker container. This project is meant to work 
together with the [dotfiles](git@github.com:roumail/dotfiles.git) repo, 
which contains the different configuration files. It's expected to be checked 
out next to this project so we can use `..` to reference files inside that
directory.

The aim of the project is to support:
* Vim configs and plugins.
* Mount any project directory from your host machine.
* Quickly bootstrap the same Vim environment on different machines (Windows, 
macOS, etc.).
* Experiment with config changes or even have multiple different containers 
running under different configurations

## Directory Structure
Apart from this repository, the `dotfiles` repository, normally we'd be loading 
the directory we want to work on as well. This folder is specified using a
`.env` file which expects three values
`HOST_APP_DIR`, `BASE_IMAGE` and `DEV_IMAGE_NAME`. 

The `BASE_IMAGE` is used to allow us to add our dev dependencies on top of any 
project dependencies defined in their own docker-compose file. 

As a concrete example, if we wanted to host this repo inside a containerized 
vim session, we'd use the following build command:
`HOST_APP_DIR=$(pwd) docker-compose --env-file .env build vim`

with the `.env`

```bash
BASE_IMAGE=debian:slim
DEV_IMAGE_NAME=dev_env_test:latest
```

## Quick Start
Clone or copy the `dotfiles` repository to your machine, `next` to this project.

Ensure you have Docker desktop installed. Let's assume we're interested in working 
with a project checked out here: `/Users/rohailtaimour/home/1_Projects/go-tutorial` 
which has a dependency on `go` version `1.2.4`.

The contents of the `.env` file in this case would be

```bash
HOST_APP_DIR=/path/to/go-tutorial
BASE_IMAGE=golang:1.23.4
DEV_IMAGE_NAME=go_tutorial
```

```bash
cd /path/to/go-tutorial
docker-compose --env-file .env -f /path/to/dev-env-setup/docker-compose.yml build vim
```
This would ensure that we're able to have an environment, configured with `Go` 
for our project. 

```bash
docker-compose --env-file .env -f /path/to/dev-env-setup/docker-compose.yml run --rm vim
```

The directory `HOST_APP_DIR` will point to the location `/root/workspace` in 
the container and the built image will be name `DEV_IMAGE_NAME`. 

## Known caveats

Running vim inside a container presents challenges to access the host 
clipboard and viceversa. The current vim settings only allow vim to have access 
to the clipboard inside the container. To access the clipboard on the host, we'd
need to setup some sort of sync of the clipboards. Of the different options 
available to do this, using ssh to copy the clipboard between container and host 
seems the most straightforward but hasn't been considered yet in detail. 

The other option, is to rely on bracketed paste, which means that we can use the 
standard ctrl/cmd+c/v since we're running vim inside a terminal emulator.