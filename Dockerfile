FROM debian:latest
RUN apt update && apt install -y vim curl git

# Install vim-plug
RUN curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Run vim-plug in headless mode to install plugins
# vim -E: Enables "Ex mode," which is non-interactive.
# </dev/null: Prevents Vim from waiting for input during the build.
# || true: Ensures the build doesn't fail due to plugin installation errors.
RUN vim -E -u /root/.vimrc +PlugInstall +qall </dev/null || true

CMD ["vim"]
