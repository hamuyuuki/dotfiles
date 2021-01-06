#!/bin/bash
# @hamuyuuki

set -e
set -u
set -v

# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install Homebrew packages
brew bundle
