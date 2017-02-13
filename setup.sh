#!/bin/sh
# @hamuyuuki

set -e
set -u

setup() {
    dotfiles=$HOME/.dotfiles

    symlink() {
        [ -e "$2" ] || ln -s "$1" "$2"
    }

    init_git() {
        sudo yum -y install git
        symlink "$dotfiles/.gitconfig" "$HOME/.gitconfig"
    }

    clone_dotfiles() {
        if [ -d "$dotfiles" ]; then
            (cd "$dotfiles" && git pull --rebase)
        else
            git clone https://github.com/hamuyuuki/dotfiles "$dotfiles"
        fi
    }

    init_zsh() {
        sudo yum -y install zsh
        sudo chsh -s /bin/zsh vagrant
        if [ ! -d "${ZDOTDIR:-$HOME}/.zprezto" ]; then
          git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"

          symlink "$HOME/.zprezto/runcoms/zlogin" "$HOME/.zlogin"
          symlink "$HOME/.zprezto/runcoms/zshrc" "$HOME/.zshrc"
          symlink "$HOME/.zprezto/runcoms/zshenv" "$HOME/.zshenv"
          symlink "$HOME/.zprezto/runcoms/zprofile" "$HOME/.zprofile"
          symlink "$HOME/.zprezto/runcoms/zpreztorc" "$HOME/.zpreztorc"
          symlink "$HOME/.zprezto/runcoms/zlogout" "$HOME/.zlogout"

          zsh -c 'setopt EXTENDED_GLOB && prompt steeef'

          echo "alias ll='ls -al'" >> "$HOME/.zshrc"
          echo "alias t='tmux attach -t tmux || tmux new-session -s tmux \; source-file ~/.tmux.session'" >> "$HOME/.zshrc"
        fi
    }

    init_vim() {
        sudo yum -y install vim gcc
        symlink "$dotfiles/.vimrc" "$HOME/.vimrc"
        if [ ! -d "$HOME/.vim/bundle" ]; then mkdir -p $HOME/.vim/bundle; fi
        if [ ! -d "$HOME/.vim/plugin" ]; then mkdir -p $HOME/.vim/plugin; fi
        if [ ! -d "$HOME/.vim/colors" ]; then mkdir -p $HOME/.vim/colors; fi
        if [ ! -d "$HOME/.vim/bundle/neobundle.vim" ]; then git clone https://github.com/Shougo/neobundle.vim $HOME/.vim/bundle/neobundle.vim; fi
        if [ ! -d "$HOME/.vim/bundle/vimproc.vim" ]; then git clone https://github.com/Shougo/vimproc.vim $HOME/.vim/bundle/vimproc.vim; fi
        if [ ! -d "$HOME/.vim/bundle/vimproc.vim/lib/vimproc_linux64.so" ]; then cd $HOME/.vim/bundle/vimproc.vim && make && cd; fi
        vim -N -u NONE -i NONE -V1 -e -s --cmd "source .vimrc" --cmd NeoBundleInstall! --cmd qall!
    }


    init_tmux() {
        sudo yum -y install tmux
        symlink "$dotfiles/.tmux.session" "$HOME/.tmux.session"
    }

    init_ctags() {
        sudo yum -y install ctags
        symlink "$dotfiles/.ctags" "$HOME/.ctags"
    }

    init_git
    clone_dotfiles
    init_zsh
    init_tmux
    init_ctags
    init_vim
}

setup
