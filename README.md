# Dev env setup

This project contains docker-compose files for dev tools like vim and bash. The 
vim setup in particular is meant to allow opening any directory in a pre-configured
Vim environment running inside a Docker container. This lets you:

* Mount custom Vim configs and plugins.
* Mount any project directory from your host machine.
* Quickly bootstrap the same Vim environment on different machines (Windows, 
macOS, etc.).
* Experiment with config changes or even have multiple different containers 
running under different configurations

## TODO:

* Update documentation 
* vim-rc to have a better name

## Directory Structure
Apart from this repository, you'd also need the `dotfiles` repository, as well 
as the directory you want to load. 

The dotfile's repo is where the .vimrc and .vim/ config would live, but you 
can also pass different config paths if you desire a different setup.

```bash
dotfiles/vim-rc/
├── .vim/
│   └── config/
│       ├── plugins/
│       └── ...
└── .vimrc
```

Within this repository, we have a base dockerfile containing bash niceties and 
a setup for vim. The idea is for the `bash` setup to be integrated so that 
`:term` opens our pre-configured bash terminal, with a persistent `bash_history` 
and some autocompletion, etc.

## Quick Start
Clone or copy the `dotfiles` repository to your machine.

Ensure you have Docker desktop installed. Build the Docker image:

```bash
cd dev-env-setup
HOST_MYAPP_DIR=/Users/rohailtaimour/home/1_Projects/go-tutorial docker compose build vim
```
Please note that we use a `.env` to point to the config directory 
`HOST_VIM_CONFIG_DIR` but pass the `HOST_MYAPP_DIR` dynamically on the command 
line.

```bash
HOST_MYAPP_DIR=/Users/rohailtaimour/home/1_Projects/go-tutorial docker compose run --rm vim
```

`HOST_MYAPP_DIR` is the directory that vim will be launched inside, with a mount 
to the location `/root/workspace`.
Your Vim configs are also mounted so the container sees `.vimrc` and `.vim/` 
as you'd prefer. For example, you could launch multiple instances with different 
configs


## Known caveats

Running vim inside a container presents challenges to access the host 
clipboard and viceversa. The current vim settings only allow vim to have access 
to the clipboard inside the container. To access the clipboard on the host, we'd
need to setup some sort of sync of the clipboards. Of the different options 
available to do this, using ssh to copy the clipboard between container and host 
seems the most straightforward but hasn't been considered yet in detail. 

The other option, is to rely on bracketed paste, which means that we can use the 
standard ctrl/cmd+c/v since we're running vim inside a terminal emulator.