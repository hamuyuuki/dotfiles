#!/bin/sh
# @hamuyuuki

set -e
set -u

setup() {
    dotfiles=$HOME/.dotfiles

    if [ -d "$dotfiles" ]; then
        (cd "$dotfiles" && git pull --rebase)
    else
        git clone https://github.com/hamuyuuki/dotfiles "$dotfiles"
    fi

    zsh
    vim
    git
    tmux
    ctags

    has() {
        type "$1" > /dev/null 2>&1
    }

    symlink() {
        [ -e "$2" ] || ln -s "$1" "$2"
    }

    zsh() {
        sudo yum -y install zsh
        sudo chsh -s /bin/zsh
        symlink "$dotfiles/.zshrc" "$HOME/.zshrc"
    }

    vim() {
        symlink "$dotfiles/.vimrc" "$HOME/.vimrc"
        vim -N -u NONE -i NONE -V1 -e -s --cmd "source .vimrc" --cmd NeoBundleInstall! --cmd qall!
    }

    git() {
        symlink "$dotfiles/.gitconfig" "$HOME/.gitconfig"
    }

    tmux() {
        sudo yum -y install tmux
        symlink "$dotfiles/.tmux.conf" "$HOME/.tmux.conf"
    }

    ctags() {
        sudo yum -y install ctags
        symlink "$dotfiles/.ctags" "$HOME/.ctags"
    }

}

setup
