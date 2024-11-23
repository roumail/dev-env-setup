#!/usr/bin/env bash

if [ ! -d "$VIM_CONFIG_DIR" ]; then
  echo "Error: VIM_CONFIG_DIR does not exist: $VIM_CONFIG_DIR" >&2
  exit 1
fi

# Application code directory (default to current directory if no argument is provided)
APP_CODE_DIR=${1:-$(pwd)}

docker run --rm -it \
  -v "$APP_CODE_DIR":/workspace \
  -v "$VIM_CONFIG_DIR/.vim":/root/.vim \
  -v "$HOME/.vim/autoload":/root/.vim/autoload \
  -v "$HOME/.vim/plugged:"/root/.vim/plugged \
  -v "$VIM_CONFIG_DIR/.vimrc":/root/.vimrc \
   -w /workspace \
  custom-vim
