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

    init_vim
}

setup
