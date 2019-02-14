#!/bin/sh
# @hamuyuuki

set -e
set -u

setup() {
    dotfiles=$HOME/.dotfiles

    symlink() {
        [ -e "$2" ] || ln -s "$1" "$2"
    }

    package_install() {
        if [ `uname` = "Darwin" ];then
            brew install $1
        else
            sudo yum -y install $1
        fi
    }

    init_git() {
        package_install git
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
        package_install zsh
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

            echo "alias ll='ls -al'" >> "$HOME/.zshrc"
            echo "alias t='tmux attach -t tmux || tmux new-session -s tmux \; source-file ~/.tmux.session'" >> "$HOME/.zshrc"
            echo "autoload -U compinit" >> "$HOME/.zshrc"
            echo "compinit" >> "$HOME/.zshrc"
            echo "autoload history-search-end" >> "$HOME/.zshrc"
            echo "zle -N history-beginning-search-backward-end history-search-end" >> "$HOME/.zshrc"
            echo "zle -N history-beginning-search-forward-end history-search-end" >> "$HOME/.zshrc"
            echo "bindkey '^[OA' history-beginning-search-backward-end" >> "$HOME/.zshrc"
            echo "bindkey '^[OB' history-beginning-search-forward-end" >> "$HOME/.zshrc"
            echo "bindkey '^P' history-beginning-search-backward-end" >> "$HOME/.zshrc"
            echo 'alias stv=''STV_PATH=`pwd | sed -e "s|$HOME/src|/vagrant|"`; ssh vagrant -t "cd $STV_PATH; bash --login"''' >> "$HOME/.zshrc"
            echo 'alias stpdc=''cd /Users/yuuki_ito/src/github.com/pixta-dev/pixta-dev-containers; STV_PATH=`pwd | sed -e "s|$HOME/src|/vagrant|"`; ssh vagrant -t "cd $STV_PATH; bash --login"''' >> "$HOME/.zshrc"
        fi
    }

    init_vim() {
        package_install vim
        package_install gcc
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
        package_install tmux
        symlink "$dotfiles/.tmux.session" "$HOME/.tmux.session"
    }

    init_ctags() {
        package_install ctags
        symlink "$dotfiles/.ctags" "$HOME/.ctags"
    }

    init_ag() {
        package_install the_silver_searcher
    }

    init_fzf() {
        package_install fzf
    }

    init_rbenv() {
        git clone git://github.com/sstephenson/rbenv.git ~/.rbenv
        git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
        echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> "$HOME/.zshrc"
        echo 'eval "$(rbenv init -)"' >> "$HOME/.zshrc"
        exec $SHELL -l
    }

    init_golang() {
        package_install golang
        echo 'export GOPATH=$HOME' >> "$HOME/.zshrc"
        echo 'export PATH=$PATH:$GOPATH/bin' >> "$HOME/.zshrc"
        exec $SHELL -l
    }

    init_ghq() {
        go get github.com/motemen/ghq
        echo 'function fzf-src () { cd $(ghq list -p | fzf)  }' >> "$HOME/.zshrc"
        echo 'zle -N fzf-src' >> "$HOME/.zshrc"
        echo 'bindkey "^]" fzf-src' >> "$HOME/.zshrc"
    }

    init_virtualbox() {
        brew cask install virtualbox
    }

    init_vagrant() {
        brew cask install vagrant
        ghq get https://github.com/coreos/coreos-vagrant.git
        symlink "$dotfiles/Vagrantfile" "$HOME/src/github.com/coreos/coreos-vagrant/Vagrantfile"
    }

    init_node() {
        brew install nodebrew
    }

    init_git
    clone_dotfiles
    init_zsh
    init_tmux
    init_ctags
    init_ag
    init_fzf
    init_rbenv
    init_golang
    init_ghq
    init_virtualbox
    init_vagrant
    init_node
    init_vim
}

setup
