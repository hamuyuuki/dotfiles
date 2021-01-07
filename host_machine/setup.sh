#!/bin/bash
# @hamuyuuki

set -e
set -u
set -v

# Clone dotfiles repository
git clone https://github.com/hamuyuuki/dotfiles ~/.dotfiles

# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install Homebrew packages
brew bundle --file=~/.dotfiles/host_machine/Brewfile

# Setup Karabiner-Elements
mkdir -p ~/.config/karabiner
ln -s ~/.dotfiles/host_machine/karabiner.json ~/.config/karabiner/karabiner.json

# Setup Vagrant
mkdir -p ~/vagrant/ubuntu
ln -s ~/.dotfiles/host_machine/Vagrantfile ~/vagrant/ubuntu/Vagrantfile
