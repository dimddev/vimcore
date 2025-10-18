# VIMCORE

A refined, boot-strapped Vim configuration bundle for modern development workflows.

What it is:

vimcore is a single-repository solution combining your ~/.vimrc and a setup script to install dependencies and initialize your Vim environment.
It’s designed for systems like OpenBSD / FreeBSD (and other Unix-like OSes) to spin up a consistent Vim setup with minimal effort.

## Features

Unified .vimrc that captures your personal editor preferences (mappings, appearances, plugins, etc).

setup.sh script to automate installation of required dependencies (Go, Git, jq, curl, fzf, ripgrep, Vim, powerline fonts, etc).

Vim-plug bootstrap logic (via vim-plug) so that once you link the config, plugins are installed automatically.

Undo directory for Vim (~/.cache/vim/undo) is created during setup.

Companion support for Go tools (e.g., installing revive linter) built in.

## Prerequisites

A Unix-like OS (tested on OpenBSD / FreeBSD) with root or sudo/doas privileges for package installs.

vim (or an equivalent supported build) already installed or ready to be installed via your package manager.

curl, git, go among other dependencies which setup.sh will fetch.

## Setup Instructions

Clone the repository:

git clone https://github.com/dimddev/vimcore.git ~/vimcore


Run the setup script:

cd ~/vimcore
./setup.sh


This installs dependencies and links your config.

Use Vim and enjoy your custom configuration.
