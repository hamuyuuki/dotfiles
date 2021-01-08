#!/bin/bash
# @hamuyuuki

set -e
set -u
set -v

# Install apt packages
sudo apt update
sudo add-apt-repository ppa:longsleep/golang-backports && \
  sudo apt-get update
sudo apt install -y \
  autoconf \
  bison \
  build-essential \
  ctags \
  git \
  golang-1.13 \
  libdb-dev \
  libffi-dev \
  libgdbm6 \
  libgdbm-dev \
  libncurses5-dev \
  libreadline6-dev \
  libssl-dev \
  libyaml-dev \
  tmux \
  zlib1g-dev \
  zsh

# Setup Git
ln -s ~/.dotfiles/guest_machine/.gitconfig ~/.gitconfig
ln -s ~/.dotfiles/guest_machine/.gitignore ~/.gitignore

# Clone dotfiles repository
git clone https://github.com/hamuyuuki/dotfiles ~/.dotfiles

# Setup Z Shell
zsh -c '
  git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"

  setopt EXTENDED_GLOB
  for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
    ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
  done
'

ln -s ~/.dotfiles/guest_machine/.zshrc.local ~/.zshrc.local
echo "source ~/.zshrc.local" >> ~/.zshrc

sudo chsh -s /bin/zsh $USER

# Setup Ctags
ln -s ~/.dotfiles/guest_machine/.ctags ~/.ctags

# Setup fzf
git clone https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

# Setup Golang
go get github.com/motemen/ghq

# Setup nodebrew
curl -L git.io/nodebrew | perl - setup

# Setup rbenv
git clone git://github.com/sstephenson/rbenv.git ~/.rbenv
git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
git clone https://github.com/rkh/rbenv-update.git ~/.rbenv/plugins/rbenv-update

# Setup tmux
ln -s ~/.dotfiles/guest_machine/.tmux.session ~/.tmux.session