FROM debian:latest
RUN apt-get update && apt-get install -y vim xclip curl git bash

# Set bash as default terminal for root user
RUN usermod -s /bin/bash root

# Install vim-plug
RUN curl -fLo /root/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

WORKDIR /root/workspace

CMD ["vim"]