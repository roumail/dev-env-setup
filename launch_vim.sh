#!/usr/bin/env bash

# Check if VIM_CONFIG_DIR is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <VIM_CONFIG_DIR> [APP_CODE_DIR]" >&2
  exit 1
fi

VIM_CONFIG_DIR=$1

# Application code directory (default to current directory if no argument is provided)
APP_CODE_DIR=${2:-$(pwd)}

if [ ! -d "$VIM_CONFIG_DIR" ]; then
  echo "Error: VIM_CONFIG_DIR does not exist: $VIM_CONFIG_DIR" >&2
  exit 1
fi

docker run --rm -it \
  -v "$APP_CODE_DIR":/workspace \
  -v "$VIM_CONFIG_DIR/.vim":/root/.vim \
  -v "$VIM_CONFIG_DIR/.vimrc":/root/.vimrc \
   -w /workspace \
  custom-vim
