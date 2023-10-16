#!/bin/zsh
# Homebrew https://github.com/Homebrew/brew.git
git -C "$(brew --repo)" remote set-url origin https://mirrors.ustc.edu.cn/brew.git

# Homebrew Core https://github.com/Homebrew/brew-core.git
#git -C "$(brew --repo homebrew/core)" remote set-url origin https://mirrors.ustc.edu.cn/brew-core.git

# Homebrew Cask https://github.com/Homebrew/brew-cask.git
#git -C "$(brew --repo homebrew/cask)" remote set-url origin https://mirrors.ustc.edu.cn/brew-cask.git

# zsh
if [ "$HOMEBREW_BOTTLE_DOMAIN" == "" ]; then
  echo 'export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.ustc.edu.cn/homebrew-bottles' >> ~/.zshrc
fi
