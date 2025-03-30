#!/bin/zsh
# @hamuyuuki

set -e
set -u
set -v

# Setup .dotfiles
if [ -d $HOME/.dotfiles ]; then
  pushd $HOME/.dotfiles; git pull; popd
else
  git clone https://github.com/hamuyuuki/dotfiles $HOME/.dotfiles
fi

# Setup Rosseta2
if [[ "$(uname -m)" == arm64 ]]; then
  softwareupdate --install-rosetta --agree-to-license
fi

# Setup Homebrew
if [ -x "$(command -v brew)" ]; then
  brew update
else
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  if [[ "$(uname -m)" == arm64 ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ "$(uname -m)" == x86_64 ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
fi

# Install Homebrew packages
brew bundle --file=$HOME/.dotfiles/Brewfile --cleanup --no-lock

# Setup Prezto
if [ -d ${ZDOTDIR:-$HOME}/.zprezto ]; then
  pushd ${ZDOTDIR:-$HOME}/.zprezto
  git pull
  git submodule sync --recursive
  git submodule update --init --recursive
  popd
else
  git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
  setopt EXTENDED_GLOB
  for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
    ln -fs "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
  done
fi

# Setup Zsh
ln -fs ~/.dotfiles/.zshrc.local $HOME/.zshrc.local
if ! grep -qF ".zshrc.local" $HOME/.zshrc; then
  echo "source ~/.zshrc.local" >> $HOME/.zshrc
fi

# Setup Git
ln -fs $HOME/.dotfiles/.gitconfig $HOME/.gitconfig
ln -fs $HOME/.dotfiles/.gitignore $HOME/.gitignore

# Setup asdf
if ! grep -qF "asdf.sh" $HOME/.zshrc; then
  echo -e "\n. $(brew --prefix asdf)/libexec/asdf.sh" >> ${ZDOTDIR:-~}/.zshrc
fi
asdf plugin add kubectl
asdf plugin add minikube
asdf plugin add nodejs
asdf plugin add terraform

# Setup fzf
if [ ! -f $HOME/.fzf.zsh ]; then
  $(brew --prefix)/opt/fzf/install
fi

# Setup Mac settings
defaults write com.apple.AppleMultitouchMouse MouseButtonMode -string TwoButton
defaults write com.apple.driver.AppleBluetoothMultitouch.mouse  MouseButtonMode -string TwoButton
defaults write "Apple Global Domain" com.apple.mouse.scaling -int 15
defaults write "Apple Global Domain" com.apple.mouse.tapBehavior -int 1
defaults write "Apple Global Domain" com.apple.scrollwheel.scaling -int 1
defaults write "Apple Global Domain" com.apple.trackpad.scaling -int 50
defaults write "Apple Global Domain" com.apple.trackpad.scrolling -int 1
defaults write "Apple Global Domain" InitialKeyRepeat -int 15
defaults write "Apple Global Domain" KeyRepeat -int 2

# Setup Source Han Code JP
curl -L -o $HOME/Library/Fonts/SourceHanCodeJP.ttc https://github.com/adobe-fonts/source-han-code-jp/releases/download/2.012R/SourceHanCodeJP.ttc
