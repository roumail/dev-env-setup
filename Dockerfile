FROM debian:latest
RUN apt update && apt install -y vim curl git

# Install vim-plug
RUN curl -fLo /root/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

WORKDIR /root/workspace

CMD ["vim"]