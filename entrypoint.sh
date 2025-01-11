#!/bin/bash
set -e

INIT_FILE="/root/.vim/config/plugins/init.vim"

if [ -f "$INIT_FILE" ]; then
    echo "Found $INIT_FILE. Installing Vim plugins..."
    # Run vim-plug in headless mode to install plugins
    # vim -E: Enables "Ex mode," which is non-interactive.
    # </dev/null: Prevents Vim from waiting for input during the build.
    # Ensure the container installs plugins into the host-mounted directory at runtime
    vim -E -u "$INIT_FILE" +PlugInstall +qall </dev/null || {
        echo "Vim plugin installation failed!" >&2
        exit 1
    }
    # Remove the copied init file to avoid conflict with the mounted volume
    echo "Removing $INIT_FILE to avoid conflicts with volume mount..."
    rm -f "$INIT_FILE"
else
    echo "Vim initialization file not found at $INIT_FILE. Skipping plugin installation."
fi

# Launch a Bash session to keep the container running
exec /bin/bash
