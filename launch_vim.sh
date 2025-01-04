#!/usr/bin/env bash

if [ -z "$1" ]; then
  echo "Usage: $0 <VIM_CONFIG_DIR> <APP_CODE_DIR>" >&2
  exit 1
fi

VIM_CONFIG_DIR=$1

# Application code directory (default to current directory if no argument is provided)
APP_CODE_DIR=${2:-$(pwd)}

if [ ! -d "$VIM_CONFIG_DIR" ]; then
  echo "Error: VIM_CONFIG_DIR does not exist: $VIM_CONFIG_DIR" >&2
  exit 1
fi

vim -u "$VIM_CONFIG_DIR/.vimrc"

# docker run --rm -it \
#   -v /Users/rohailtaimour/home/1_Projects/vim-configs:/vim-rc \
#   -v /Users/rohailtaimour/home/1_Projects/vim-test:/workspace \
#   custom-vim /vim-rc /workspace