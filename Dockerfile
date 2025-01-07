# Base Stage: Install common packages
FROM debian:latest AS base

RUN apt-get update && apt-get install -y --no-install-recommends \
    bash-completion \
    curl \
    git \
    bash \
    fontconfig \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

ENV SHELL=/bin/bash

# Font Installation Stage: Handle fonts in a separate stage
FROM base AS fonts

# Copy pre-downloaded fonts from the host
COPY nerd-fonts/ /usr/share/fonts

# Rebuild font cache
RUN fc-cache -fv

FROM base AS tools

# Install starship
RUN curl -fsSL https://starship.rs/install.sh | sh -s -- -y

# Install uv
RUN curl -LsSf https://astral.sh/uv/install.sh | env UV_UNMANAGED_INSTALL="/usr/local/bin" sh

# Bash Stage: Default bash command
FROM base AS bash

# Copy fonts from the previous stage
COPY --from=fonts /usr/share/fonts /usr/share/fonts

# Copy Starship binary from the tools stage
COPY --from=tools /usr/local/bin/starship /usr/local/bin/starship

# Copy uv binaries and environment from tools stage
COPY --from=tools /usr/local/bin/uv /usr/local/bin/uv

CMD ["/bin/bash"]

# Vim Stage: Default command for Vim
FROM bash AS vim

RUN apt-get update && apt-get install -y --no-install-recommends \
    # For terminal support (xterm_clipboard feature)    
    vim-gtk3 \  
    # Clipboard integration
    xclip && \  
    rm -rf /var/lib/apt/lists/*

# Install vim-plug for plugin management
RUN curl -fLo /root/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Run vim-plug in headless mode to install plugins
# vim -E: Enables "Ex mode," which is non-interactive.
# </dev/null: Prevents Vim from waiting for input during the build.
# || true: Ensures the build doesn't fail due to plugin installation errors.
RUN vim -E -u /root/.vimrc +PlugInstall +qall </dev/null || true

CMD ["vim"]

# Install Python 3.11 and Jupyter using uv
FROM bash AS jupyter

RUN uv python install 3.11 && \
    uv venv .venv --python 3.11 && \
    . .venv/bin/activate && \ 
    uv pip install jupyter

ENV PATH="/root/workspace/.venv/bin:$PATH"

# Default command for Jupyter stage
CMD ["jupyter", "notebook", "--allow-root", "--ip", "0.0.0.0", "--no-browser"]