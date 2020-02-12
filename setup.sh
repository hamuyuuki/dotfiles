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
        sudo apt-get -y install git
        symlink "$dotfiles/.gitconfig" "$HOME/.gitconfig"
        symlink "$dotfiles/.gitignore" "$HOME/.gitignore"
    }

    clone_dotfiles() {
        if [ -d "$dotfiles" ]; then
            (cd "$dotfiles" && git pull --rebase)
        else
            git clone https://github.com/hamuyuuki/dotfiles "$dotfiles"
        fi
    }

    init_zsh() {
        sudo apt-get -y install zsh
        sudo chsh -s /bin/zsh $USER
        if [ ! -d "${ZDOTDIR:-$HOME}/.zprezto" ]; then
            git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"

            symlink "$HOME/.zprezto/runcoms/zlogin" "$HOME/.zlogin"
            symlink "$HOME/.zprezto/runcoms/zshrc" "$HOME/.zshrc"
            symlink "$HOME/.zprezto/runcoms/zshenv" "$HOME/.zshenv"
            symlink "$HOME/.zprezto/runcoms/zprofile" "$HOME/.zprofile"
            symlink "$HOME/.zprezto/runcoms/zpreztorc" "$HOME/.zpreztorc"
            symlink "$HOME/.zprezto/runcoms/zlogout" "$HOME/.zlogout"

            zsh -c 'setopt EXTENDED_GLOB'
            # zsh -c 'prompt steeef'
        fi
    }

    init_vim() {
        sudo apt-get -y install vim
        sudo apt-get -y install gcc
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
        sudo apt-get -y install tmux
        symlink "$dotfiles/.tmux.session" "$HOME/.tmux.session"
    }

    init_ctags() {
        sudo apt-get -y install ctags
        symlink "$dotfiles/.ctags" "$HOME/.ctags"
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
        fi
    }

    init_golang() {
        sudo add-apt-repository ppa:longsleep/golang-backports
        sudo apt-get update
        sudo apt-get -y install golang-go
    }

    init_ghq() {
        go get github.com/motemen/ghq
    }

    init_node() {
        curl -L git.io/nodebrew | perl - setup
    }

    init_yarn() {
        curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
        echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
        sudo apt-get update && sudo apt-get -y install yarn
    }

    init_docker() {
        sudo apt-get remove docker docker-engine docker.io containerd runc
        sudo apt-get install apt-transport-https ca-certificates curl gnupg-agent software-properties-common
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
        sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
        sudo apt-get update
        sudo apt-get install docker-ce docker-ce-cli containerd.io
        sudo usermod -aG docker $USER
    }

    init_docker_compose() {
        sudo curl -L https://github.com/docker/compose/releases/download/1.21.1/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
        sudo chmod 0755 /usr/local/bin/docker-compose
    }

    init_git
    clone_dotfiles
    init_zsh
    init_tmux
    init_ctags
    init_fzf
    init_rbenv
    init_golang
    init_ghq
    init_node
    init_yarn
    init_docker
    init_docker_compose
    init_vim
}

setup
