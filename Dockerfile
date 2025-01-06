FROM debian:latest
# vim-gtk3 for terminal support (xterm_clipboard feature)
# xclip for the mechanism allowing Vim to interact with the clipboard
RUN apt-get update && apt-get install -y vim-gtk3 xclip curl git bash

# Set bash as default terminal for root user
RUN usermod -s /bin/bash root

# Install vim-plug
RUN curl -fLo /root/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

WORKDIR /root/workspace

CMD ["vim"]