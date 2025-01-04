# Setup Vim in a Container
The purpose of this project is to allow you to open any directory of your choice 
in a pre-configured Vim environment running inside a Docker container. This lets you:

* Mount your custom Vim configs and plugins.
* Mount any local project directory.
* Quickly bootstrap the same Vim environment on different machines (Windows, macOS, etc.).

## Directory Structure
You’ll need three main directories:

vim-rc (this repo’s directory, containing Docker build instructions, docker-compose.yml, etc.)

```bash
vim-rc
├── Dockerfile
├── docker-compose.yml
├── README.md
└── assets/
```

vim-configs (where your .vimrc and .vim/ config live)

```bash
vim-configs
├── .vim/
│   └── config/
│       ├── plugins/
│       └── ...
└── .vimrc
```
Your project directory (the one you want to edit with Vim). For example, go-tutorial.

```bash
/home/go-tutorial
├── main.go
├── go.mod
├── ...
```

## Docker Compose Overview
Within vim-rc, you have:

A Dockerfile that:

* Installs Vim (plus optional packages like curl, git).
* Sets a WORKDIR /root/workspace.
* Uses a simple CMD ["vim"] or similar instruction to launch Vim.

A docker-compose.yml file that:

* Builds from the Dockerfile.
* Mounts your vim configs into the container (e.g., /root/.vimrc, /root/.vim) or another path (depending on your strategy).
* Mounts your project directory into /root/workspace.

## Quick Start
Clone or copy the `vim-rc` repository to your machine.

Ensure you have Docker desktop installed.

Place your `.vimrc` and `.vim` folder in vim-configs. You can also checkout the 
git repo [here]()

Build the Docker image:

```bash
cd vim-test
docker compose build vim
```
This will use the local Dockerfile to create a custom Vim image.

Run the containerized Vim, overriding the `HOST_MYAPP_DIR` environment variable 
to point to the directory you want to edit. For example:

```bash
HOST_MYAPP_DIR=/Users/rohailtaimour/home/1_Projects/go-tutorial \
docker compose run --rm vim
```
HOST_MYAPP_DIR is used in docker-compose.yml to mount that local folder into 
`/root/workspace` (or another path).
Your Vim configs are also mounted so the container sees .vimrc and .vim/ 
exactly as on your host.
The container automatically CDs to /root/workspace and launches Vim.

4. Example .vimrc and .vim Folder
Inside vim-configs, you might organize your config like this:

```bash
vim-configs
├── .vimrc
└── .vim
    └── config
        ├── plugins
        │   ├── init.vim
        │   ├── airline.vim
        │   ├── fern.vim
        │   └── ...
        ├── settings.vim
        ├── keymaps.vim
        ├── ui.vim
        └── ...
```

In your .vimrc, you can source these files, for example:

```bash
" Load plugins
source /root/.vim/config/plugins/init.vim

" Load other config
source /root/.vim/config/settings.vim
source /root/.vim/config/keymaps.vim
source /root/.vim/config/ui.vim
...
```