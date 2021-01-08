#!/bin/bash
# @hamuyuuki

set -e
set -u
set -v

# Clone dotfiles repository
git clone https://github.com/hamuyuuki/dotfiles ~/.dotfiles

# Install apt packages
sudo apt update
sudo apt install -y \
  git \
  tmux \
  zsh

# Setup Git
ln -s ~/.dotfiles/guest_machine/.gitconfig ~/.gitconfig
ln -s ~/.dotfiles/guest_machine/.gitignore ~/.gitignore

# Setup tmux
ln -s ~/.dotfiles/guest_machine/.tmux.session ~/.tmux.session

# Setup Z Shell
git clone --recursive https://github.com/sorin-ionescu/prezto.git ~/.zprezto

zsh -c "setopt EXTENDED_GLOB"
for rcfile in ~/.zprezto/runcoms/^README.md(.N); do
  ln -s "$rcfile" "~/.${rcfile:t}"
done

ln -s ~/.dotfiles/guest_machine/.zshrc.local ~/.zshrc.local
echo "source ~/.zshrc.local" >> ~/.zshrc

sudo chsh -s /bin/zsh $USER
