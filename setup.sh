#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status
set -e

# Function to print a status message
log() {
    echo -e "\033[1;32m[INFO]\033[0m $1"
}

# Function to handle errors
error_exit() {
    echo -e "\033[1;31m[ERROR]\033[0m $1"
    exit 1
}

log "Updating package lists..."
if ! sudo apt update; then
    error_exit "Failed to update package lists."
fi

log "Installing required dependencies..."
if ! sudo apt install -y git jq yq curl fzf ripgrep vim; then
    error_exit "Failed to install dependencies."
fi

cd /root || error_exit "Failed to change directory to /root."

# Clone and build Vim from the dimddev/vimcore repository
log "Cloning dimddev/vimcore..."
if [[ ! -d /root/vimcore ]]; then
    if ! git clone https://github.com/dimddev/vimcore.git; then
        error_exit "Failed to clone the vimcore repository."
    fi
    if ! ln -s /root/vimcore/.vimrc /root/.vimrc; then
        error_exit "Failed to create symbolic link for .vimrc."
    fi
else
    log "vimcore directory already exists. Pulling the latest changes..."
    if ! cd /root/vimcore || ! git pull; then
        error_exit "Failed to update the vimcore repository."
    fi
fi

# Set up vim-plug
log "Setting up vim-plug..."
if ! curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim; then
    error_exit "Failed to download vim-plug."
fi

# Install plugins
log "Installing Vim plugins..."
if ! vim +PlugInstall +qall; then
    error_exit "Failed to install Vim plugins."
fi

log "Setup complete! Vim has been installed from vimcore, and plugins have been configured."

