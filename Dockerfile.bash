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

# Install Starship prompt
FROM base AS tools

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

# Set default working directory and command
WORKDIR /root/workspace
CMD ["/bin/bash"]

# Install Python 3.11 and Jupyter using uv
FROM bash AS jupyter

WORKDIR /root/workspace

RUN uv python install 3.11 && \
    uv venv .venv --python 3.11 && \
    . .venv/bin/activate && \ 
    uv pip install jupyter

ENV PATH="/root/workspace/.venv/bin:$PATH"

# Default command for Jupyter stage
CMD ["jupyter", "notebook", "--allow-root", "--ip", "0.0.0.0", "--no-browser"]