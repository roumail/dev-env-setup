#!/usr/bin/env bash

docker run --rm -it \
  -v $(pwd)/.vim:/root/.vim \
  -v ~/.vim/autoload:/root/.vim/autoload \
  -v ~/.vim/plugged:/root/.vim/plugged \
  -v $(pwd)/.vimrc:/root/.vimrc \
  custom-vim
