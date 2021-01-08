#!/bin/sh
# @hamuyuuki

set -e
set -u

setup() {
    dotfiles=$HOME/.dotfiles

    symlink() {
        [ -e "$2" ] || ln -s "$1" "$2"
    }

    init_vim() {
        if [ ! -f "$HOME/.vimrc" ]; then
            sudo apt-get -y install vim
            sudo apt-get -y install gcc

            symlink "$dotfiles/.vimrc" "$HOME/.vimrc"

            mkdir -p $HOME/.vim/bundle
            mkdir -p $HOME/.vim/plugin
            mkdir -p $HOME/.vim/colors

            git clone https://github.com/Shougo/neobundle.vim $HOME/.vim/bundle/neobundle.vim
            git clone https://github.com/Shougo/vimproc.vim $HOME/.vim/bundle/vimproc.vim
            cd $HOME/.vim/bundle/vimproc.vim && make && cd

            vim -N -u NONE -i NONE -V1 -e -s --cmd "source .vimrc" --cmd NeoBundleInstall! --cmd qall!
        fi
    }

    init_fzf() {
        if [ ! -d "$HOME/.fzf" ]; then
            git clone https://github.com/junegunn/fzf.git ~/.fzf
            ~/.fzf/install
        fi
    }

    init_rbenv() {
        if [ ! -d "$HOME/.rbenv" ]; then
            git clone git://github.com/sstephenson/rbenv.git ~/.rbenv
            git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
            git clone https://github.com/rkh/rbenv-update.git ~/.rbenv/plugins/rbenv-update

            sudo apt-get -y install autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm6 libgdbm-dev libdb-dev
        fi
    }

    init_golang() {
        if [ ! -d "$HOME/src" ]; then
            sudo add-apt-repository ppa:longsleep/golang-backports
            sudo apt-get update
            sudo apt-get -y install golang-go

            go get github.com/motemen/ghq
        fi
    }

    init_node() {
        if ! which nodebrew; then
            curl -L git.io/nodebrew | perl - setup
        fi
    }

    init_yarn() {
        if ! which yarn; then
            curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
            echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
            sudo apt-get update && sudo apt-get -y install yarn
        fi
    }

    init_docker() {
        if ! which docker; then
            sudo apt-get -y remove docker docker-engine docker.io containerd runc
            sudo apt-get -y install apt-transport-https ca-certificates curl gnupg-agent software-properties-common
            curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
            sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
            sudo apt-get -y update
            sudo apt-get -y install docker-ce docker-ce-cli containerd.io
            sudo usermod -aG docker $USER
        fi
    }

    init_docker_compose() {
        if ! which docker-compose; then
            sudo curl -L https://github.com/docker/compose/releases/download/1.21.1/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
            sudo chmod 0755 /usr/local/bin/docker-compose
        fi
    }

    init_fzf
    init_rbenv
    init_golang
    init_node
    init_yarn
    init_docker
    init_docker_compose
    init_vim
}

setup
