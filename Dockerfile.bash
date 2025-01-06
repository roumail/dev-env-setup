FROM debian:latest AS base

RUN apt-get update && apt-get install -y --no-install-recommends \
    bash-completion \
    curl \
    git \
    bash \
    fontconfig \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Font Installation Stage: Handle fonts in a separate stage
FROM base AS fonts

# Copy pre-downloaded fonts from the host
COPY nerd-fonts/ /usr/share/fonts

# Rebuild font cache
RUN fc-cache -fv

# Tools Stage: Install Starship prompt
FROM base AS tools

# Install Starship prompt
RUN curl -fsSL https://starship.rs/install.sh | sh -s -- -y

# Final Stage: Build the runtime image
FROM base

# Copy fonts from the previous stage
COPY --from=fonts /usr/share/fonts /usr/share/fonts

# Copy Starship binary from the tools stage
COPY --from=tools /usr/local/bin/starship /usr/local/bin/starship

# Set default working directory and command
WORKDIR /root/workspace
CMD ["/bin/bash"]