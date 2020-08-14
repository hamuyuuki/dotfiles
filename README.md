# Host Machine(Mac OS)

- [Homebrew](https://brew.sh/index_ja)
- [Virtualbox](https://www.virtualbox.org/)
- [Vagrant](https://www.vagrantup.com/)
  - Use Vagrantfile in this repository
- [Visual Studio Code](https://code.visualstudio.com/)
- [Ricty Diminished Discord](https://github.com/edihbrandon/RictyDiminished)
- [BetterTouchTool](https://folivora.ai/)
  - Use Default.bttpreset in this repository
- [iTerm2](https://www.iterm2.com/)
  - Use Molokai.json in this repository
- [Clipper](https://github.com/wincent/clipper)
  - ```sh
    brew install clipper
    git clone git://git.wincent.com/clipper.git
    cd clipper
    cp contrib/darwin/tcp-port/com.wincent.clipper.plist ~/Library/LaunchAgents/
    launchctl load -w -S Aqua ~/Library/LaunchAgents/com.wincent.clipper.plist
    ```

# Guest Machine(Ubuntu 18.04 LTS)

```
curl -sL https://raw.githubusercontent.com/hamuyuuki/dotfiles/master/setup.sh | bash
```

