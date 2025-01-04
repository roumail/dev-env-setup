FROM debian:latest
RUN apt update && apt install -y vim curl git

# Install vim-plug
RUN curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim


# Copy vim configuration files
ARG VIM_CONFIG_DIR
COPY ${VIM_CONFIG_DIR}/.vim/config/plugins/init.vim /root/.vim/config/plugins/init.vim

# Run vim-plug in headless mode to install plugins
# vim -E: Enables "Ex mode," which is non-interactive.
# </dev/null: Prevents Vim from waiting for input during the build.
# || true: Ensures the build doesn't fail due to plugin installation errors.
RUN vim -E -u /root/.vimrc +PlugInstall +qall </dev/null || true

COPY launch_vim.sh /usr/local/bin/launch_vim.sh
RUN chmod +x /usr/local/bin/launch_vim.sh

# CMD ["vim"]
ENTRYPOINT ["/usr/local/bin/launch_vim.sh"]