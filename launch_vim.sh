#!/usr/bin/env bash

if [ "$#" -lt 2 ]; then
  echo "Usage: $0 <VIM_CONFIG_DIR> <APP_CODE_DIR>" >&2
  exit 1
fi

VIM_CONFIG_DIR=$1
APP_CODE_DIR=$2

if [ ! -d "$VIM_CONFIG_DIR" ]; then
  echo "Error: VIM_CONFIG_DIR does not exist: $VIM_CONFIG_DIR" >&2
  exit 1
fi

if [ ! -d "$APP_CODE_DIR" ]; then
  echo "Error: APP_CODE_DIR does not exist: $APP_CODE_DIR" >&2
  exit 1
fi

vim -u "$VIM_CONFIG_DIR/.vimrc"

# docker run --rm -it \
#   -v /Users/rohailtaimour/home/1_Projects/vim-configs:/vim-rc \
#   -v /Users/rohailtaimour/home/1_Projects/vim-test:/workspace \
#   custom-vim /vim-rc /workspace