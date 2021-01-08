#!/bin/bash
# @hamuyuuki

set -e
set -u
set -v

# Clone dotfiles repository
git clone https://github.com/hamuyuuki/dotfiles ~/.dotfiles

# Install apt packages
sudo apt update
sudo apt install -y git

# Setup Git
ln -s ~/.dotfiles/guest_machine/.gitconfig ~/.gitconfig
ln -s ~/.dotfiles/guest_machine/.gitignore ~/.gitignore
