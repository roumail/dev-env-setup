# Dev env setup

This project contains docker-compose files for dev tools like vim and bash. The
Vim setup, in particular, allows you to open any directory in a pre-configured
Vim environment running inside a Docker container. This project is designed to
work alongside the [dotfiles](git@github.com:roumail/dotfiles.git) repo,
which contains various configuration files. It's expected to be checked
out next to this project so we can use `..` to reference files within that
directory.

## Features

- Vim Configs and Plugins: Pre-configured Vim environment with essential plugins.
- Directory Mounting: Mount any project directory from your host machine into the container.
- Cross-Platform Bootstrap: Quickly set up the same Vim environment across different machines (Windows, macOS, etc.).
- Config Experimentation: Easily experiment with configuration changes or run multiple containers with different configurations.
- Host-Based Plugin Persistence: Store Vim plugins on the host machine, reducing image size and ensuring persistence across container rebuilds.

## Directory Structure

Apart from this repository and the dotfiles repository, you typically load the directory you want to work on as well. This folder is specified using a .env file, which expects the following values:

- HOST_APP_DIR: The path to the project directory on your host machine.
- BASE_IMAGE: The base Docker image that includes your project dependencies.
- DEV_IMAGE_NAME: A descriptive name for your development environment image (e.g.
  , vim_env_go_tutorial).
- PLUGINS_DIR: A directory to hold plugins installed in container

```bash
/path/to/
├── dev-env-setup/         # This repository
├── dotfiles/              # Your dotfiles repository
└── your-project/          # The project you are working on

```

As a concrete example, if we wanted to host this repo inside a containerized
vim session, we'd use the following build command:
`HOST_APP_DIR=$(pwd) docker-compose --env-file .env build vim`

with the `.env`

```bash
BASE_IMAGE=debian:stable-slim
DEV_IMAGE_NAME=dev_env_test
PLUGINS_DIR=~/vim_plugins/
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
PLUGINS_DIR=~/vim_plugins/
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
the container and the built image will be name `DEV_IMAGE_NAME`. At this point, 
if you have an empty `$PLUGINS_DIR` it will be populated at runtime with the 
result of installing the plugins.

## Known caveats

### Clipboard Sync

Running Vim inside a container presents challenges for clipboard access between the host and the container. Currently, Vim can only access the container's clipboard. To enable clipboard sharing between the host and the container, consider the following options:

1. SSH with X11 Forwarding:

- Install xclip or xsel inside the container.
- Use ssh -X to enable X11 forwarding for clipboard commands.
- Manually sync the clipboard or automate the process with scripts.

2. Bracketed Paste: Use terminal emulators that support bracketed paste (e.g., iTerm2, Alacritty) to allow standard Ctrl/Cmd+C/V operations.
3. Clipboard Sharing Tools: Explore tools like clipboardctl or xsel that facilitate clipboard sharing between the host and the container.
