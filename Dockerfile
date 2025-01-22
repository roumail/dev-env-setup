# Base Stage: Install common packages
ARG BASE_IMAGE=debian:stable-slim
FROM ${BASE_IMAGE} AS base
# https://stackoverflow.com/questions/53681522/share-variable-in-multi-stage-dockerfile-arg-before-from-not-substituted
ARG BASE_IMAGE
ARG DEV_IMAGE_NAME=dev-env
ARG DOTFILES_BASENAME
LABEL version="1.0.0"
LABEL org.opencontainers.image.authors="rohailt"
LABEL org.opencontainers.image.source="https://github.com/rohailt/dev-env-setup"
LABEL maintainer.email="sigmagraphinc@gmail.com"
LABEL org.opencontainers.image.base="$BASE_IMAGE"
LABEL org.opencontainers.image.name="$DEV_IMAGE_NAME"
LABEL org.opencontainers.image.description="Base stage for development environment with common utilities."
LABEL stage="base"
LABEL org.opencontainers.image.created=$(date)


RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    git \
    tar \
    bash \
    tmux \
    bat \
    fontconfig \
    tree \
    ca-certificates \
    # For terminal support (xterm_clipboard feature)    
    vim-nox \  
    # Clipboard integration
    xclip \  
    fd-find \
    ripgrep \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* && \
    ln -s /usr/bin/batcat /usr/bin/bat && \
    ln -s $(which fdfind) /usr/bin/fd 

ENV SHELL=/bin/bash

# Font Installation Stage: Handle fonts in a separate stage
FROM base AS fonts
LABEL stage="fonts"
LABEL org.opencontainers.image.description="Stage for ensuring fonts and installed and configured."

COPY dev-env-setup/nerd-fonts/ /usr/share/fonts

# Rebuild font cache
RUN fc-cache -fv

FROM base AS tools
LABEL stage="tools"

RUN curl -fsSL https://starship.rs/install.sh | sh -s -- -y && \
    curl -fsSL https://astral.sh/ruff/install.sh | sh && \
    curl -LsSf https://astral.sh/uv/install.sh | env UV_UNMANAGED_INSTALL="/usr/local/bin" sh && \
    curl -fLo /root/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim && \
    arch=$(uname -m) && \
    fzf_arch="" && \
    if [ "$arch" = "x86_64" ]; then \
        fzf_arch="amd64"; \
    elif [ "$arch" = "aarch64" ]; then \
        fzf_arch="arm64"; \
    else \
        echo "Unsupported architecture: $arch" && exit 1; \
    fi && \
    curl -fsSL "https://github.com/junegunn/fzf/releases/download/v0.58.0/fzf-0.58.0-linux_${fzf_arch}.tar.gz" -o /tmp/fzf.tar.gz && \
    tar -xzf /tmp/fzf.tar.gz -C /usr/local/bin && \
    chmod +x /usr/local/bin/fzf && \
    rm /tmp/fzf.tar.gz && \
    rm -rf /var/lib/apt/lists/*

# Bash Stage: Default bash command
FROM base AS bash
LABEL stage="bash"
ARG DOTFILES_BASENAME
LABEL org.opencontainers.image.description="Stage for configuring bash with tools."

# Copy fonts from the previous stage
COPY --from=fonts /usr/share/fonts /usr/share/fonts

# Copy Starship binary from the tools stage
COPY --from=tools /usr/local/bin/starship /usr/local/bin/starship

# Copy uv binaries and environment from tools stage
COPY --from=tools /usr/local/bin/uv /usr/local/bin/uv

# Copy ruff binary from tools stage
COPY --from=tools /root/.local/bin/ruff /usr/local/bin/ruff

# Copy fzf binary from tools stage
COPY --from=tools /usr/local/bin/fzf /usr/local/bin/fzf
# Vim plug directories
COPY --from=tools /root/.vim/autoload /root/.vim/autoload

# Copy starship configuration
COPY ${DOTFILES_BASENAME}/bash-rc/starship.toml /root/.config/starship.toml

# Copy bashrc and other dotfiles
COPY ${DOTFILES_BASENAME}/bash-rc/.fzf-config /root/.fzf-config
COPY ${DOTFILES_BASENAME}/bash-rc/.bashrc /root/.bashrc
COPY ${DOTFILES_BASENAME}/bash-rc/.editorconfig /root/.editorconfig
COPY ${DOTFILES_BASENAME}/bash-rc/.terminfo /root/.terminfo

CMD ["/bin/bash"]

# Vim Plugins install
FROM bash AS vim_plugins
LABEL stage="vim_plugins"
LABEL org.opencontainers.image.description="Stage for configuring Vim with plugins."
ARG DOTFILES_BASENAME
# Copy vim-plug and plugin initialization file
COPY ${DOTFILES_BASENAME}/vim-rc/custom/plug.vim  /root/.vim/custom/plug.vim
# Add coc-settings to ~/.vim directory
COPY ${DOTFILES_BASENAME}/vim-rc/custom/coc-settings.json  /root/.vim/coc-settings.json
COPY dev-env-setup/entrypoint.sh /usr/local/bin/entrypoint.sh

# Install Node.js, npm, and Pyright
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | sh && \
    apt-get install -y nodejs && \
    npm install -g dockerfile-language-server-nodejs && \
    npm i -g bash-language-server && \
    npm install -g @microsoft/compose-language-service && \
    npm install -g pyright && \
    rm -rf /var/lib/apt/lists/*

# Make the script executable
RUN chmod +x /usr/local/bin/entrypoint.sh

CMD ["/usr/local/bin/entrypoint.sh"]

# Install Python 3.11 and Jupyter using uv
FROM vim_plugins AS jupyter
LABEL stage="jupyter"
LABEL org.opencontainers.image.description="Stage for configuring a python installation with a jupyter notebook interface."

RUN uv python install 3.11 && \
    uv venv .venv --python 3.11 && \
    . .venv/bin/activate && \ 
    uv pip install jupyter

ENV PATH="/root/workspace/.venv/bin:$PATH"

# Default command for Jupyter stage
CMD ["jupyter", "notebook", "--allow-root", "--ip", "0.0.0.0", "--no-browser", "&"]