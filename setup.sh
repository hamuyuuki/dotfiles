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
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Install Homebrew packages
brew bundle --file=$HOME/.dotfiles/Brewfile

# Setup Zsh
ln -fs ~/.dotfiles/.zshrc.local $HOME/.zshrc.local
if ! grep -qF ".zshrc.local" $HOME/.zshrc; then
  echo "source ~/.zshrc.local" >> $HOME/.zshrc
fi

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

# Setup Git
ln -fs $HOME/.dotfiles/.gitconfig $HOME/.gitconfig
ln -fs $HOME/.dotfiles/.gitignore $HOME/.gitignore

# Setup fzf
if [ ! -f $HOME/.fzf.zsh ]; then
  $(brew --prefix)/opt/fzf/install
fi

# Setup Mac settings
defaults write com.apple.AppleMultitouchMouse MouseButtonMode -string TwoButton
defaults write com.apple.dock mru-spaces -bool false
defaults write com.apple.dock orientation -string left
defaults write com.apple.driver.AppleBluetoothMultitouch.mouse  MouseButtonMode -string TwoButton
defaults write com.apple.controlcenter "NSStatusItem Visible Bluetooth" -bool true
defaults write com.apple.controlcenter "NSStatusItem Visible WiFi" -bool true
defaults write "Apple Global Domain" com.apple.mouse.scaling -int 15
defaults write "Apple Global Domain" com.apple.scrollwheel.scaling -int 1
defaults write "Apple Global Domain" com.apple.trackpad.scaling -int 5
defaults write "Apple Global Domain" com.apple.trackpad.scrolling -int 1
defaults write "Apple Global Domain" InitialKeyRepeat -int 15
defaults write "Apple Global Domain" KeyRepeat -int 2

# Setup BetterTouchTool
open -a /Applications/BetterTouchTool.app --args $HOME/.dotfiles/better_touch_tool/Default.bttpreset

# Setup Ricty Diminished
chmod 744 $HOME/.dotfiles/ricty_diminished/fix_ricty_diminished.pe
$HOME/.dotfiles/ricty_diminished/fix_ricty_diminished.pe $HOME/Library/Fonts/RictyDiminishedDiscord-Bold.ttf
$HOME/.dotfiles/ricty_diminished/fix_ricty_diminished.pe $HOME/Library/Fonts/RictyDiminishedDiscord-BoldOblique.ttf
$HOME/.dotfiles/ricty_diminished/fix_ricty_diminished.pe $HOME/Library/Fonts/RictyDiminishedDiscord-Oblique.ttf
$HOME/.dotfiles/ricty_diminished/fix_ricty_diminished.pe $HOME/Library/Fonts/RictyDiminishedDiscord-Regular.ttf
