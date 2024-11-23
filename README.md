# Setup Vim

Requirements:
* vim-plug
* Docker
* Vim installation on mac OS x
* Vim-plug installation and installation of plugins on host machine
* Environment variable `VIM_CONFIG_DIR` pointing to checkout of 
`https://github.com/roumail/vim-rc`
* `launch_vim.sh` in your path, so you can launch vim in a directory of your 
choice

## Host Machine Setup
Before running the Docker container, ensure that the following directories are 
present on your host machine:

`~/.vim/autoload`: This directory must contain the plug.vim file, which is the 
core script for vim-plug. Install it with:

```bash
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```
`~/.vim/plugged`: This directory is where vim-plug installs plugins. It will 
be populated after running :PlugInstall in Vim.

## Launching Vim
Use the provided `launch_script.sh` to start the containerized Vim environment in 
the directory where you want to launch vim. This script would need to have the 
configuration parameter `VIM_CONFIG_DIR` declared, since otherwise, we don't 
have a way to access the `.vimrc` and modular configuration files in the
 `.vim` directory for the container. Please ensure that the autoload and 
 plugged directories are available in the container for plugin management.

## Notes for Windows Users
This setup has been tested on macOS only. If you are using Windows:

Replace paths in the `launch_script` with appropriate Windows paths.

Ensure Docker's volume mounting is correctly configured for Windows file paths.
Example modification for Windows (PowerShell):

```powershell
docker run --rm -it `
  -v "${PWD}\.vim:/root/.vim" `
  -v "$HOME\.vim\autoload:/root/.vim/autoload" `
  -v "$HOME\.vim\plugged:/root/.vim/plugged" `
  -v "${PWD}\.vimrc:/root/.vimrc" `
  custom-vim
```

## Process for changing .vimrc

When modifying the .vimrc, such as uncommenting a plugin configuration like 
airline, you would need to kill the current session and relaunch vim using the 
`launch_script`

## Testing Plugin Installation
To verify that plugins are installed and configured correctly:

Launch Vim in the container:
```bash
./launch_script.sh
```
Run :PlugStatus to check the status of installed plugins.
If plugins are missing, run :PlugInstall to install them.
