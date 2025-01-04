FROM debian:latest
RUN apt update && apt install -y vim curl git

# Install vim-plug
RUN curl -fLo /root/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Copy the launch script
COPY launch_vim.sh /usr/local/bin/launch_vim.sh
RUN chmod +x /usr/local/bin/launch_vim.sh

ENTRYPOINT ["/usr/local/bin/launch_vim.sh"]