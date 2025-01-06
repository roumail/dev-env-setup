FROM dev-env_bash:latest

# Install Vim and supporting tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    # For terminal support (xterm_clipboard feature)
    vim-gtk3 \  
    # Clipboard integration
    xclip && \  
    rm -rf /var/lib/apt/lists/*

# Install vim-plug for plugin management
RUN curl -fLo /root/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Set the default working directory
WORKDIR /root/workspace

# Default command for the container
CMD ["vim"]