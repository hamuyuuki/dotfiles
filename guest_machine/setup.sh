#!/bin/bash
# @hamuyuuki

set -e
set -u
set -v

# Install apt packages
sudo apt update

sudo apt install -y \
  apt-transport-https \
  ca-certificates \
  curl \
  gnupg-agent \
  software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo add-apt-repository ppa:longsleep/golang-backports
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt-get update

sudo apt install -y \
  autoconf \
  bison \
  build-essential \
  ctags \
  docker-ce \
  docker-ce-cli \
  containerd.io \
  gcc \
  git \
  golang-go \
  libdb-dev \
  libffi-dev \
  libgdbm6 \
  libgdbm-dev \
  libncurses5-dev \
  libreadline6-dev \
  libssl-dev \
  libyaml-dev \
  tmux \
  yarn \
  vim \
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

# Setup Docker
sudo usermod -aG docker $USER

# Setup Docker Compose
sudo curl -L https://github.com/docker/compose/releases/download/1.21.1/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
sudo chmod 0755 /usr/local/bin/docker-compose

# Setup fzf
git clone https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

# Setup Golang
go get github.com/x-motemen/ghq

# Setup nodebrew
curl -L git.io/nodebrew | perl - setup

# Setup rbenv
git clone git://github.com/sstephenson/rbenv.git ~/.rbenv
git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
git clone https://github.com/rkh/rbenv-update.git ~/.rbenv/plugins/rbenv-update

# Setup tmux
ln -s ~/.dotfiles/guest_machine/.tmux.session ~/.tmux.session

# Setup Vim
ln -s ~/.dotfiles/guest_machine/.vimrc ~/.vimrc

mkdir -p ~/.vim/bundle ~/.vim/colors ~/.vim/plugin
git clone https://github.com/Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim
git clone https://github.com/Shougo/vimproc.vim ~/.vim/bundle/vimproc.vim
cd ~/.vim/bundle/vimproc.vim && make && cd

vim -N -u NONE -i NONE -V1 -e -s --cmd "source .vimrc" --cmd NeoBundleInstall! --cmd qall! | true
