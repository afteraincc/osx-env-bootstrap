#!/bin/bash

function bootstrap() {
  local module=$1
  local level=$2

  log "\033[33m ------ $module begin ------ \033[0m" $level
  if [ "$(type -t bootstrap_${module})" == function ]; then
    bootstrap_${module} $level
    if [ $? -eq 0 ]; then
      log "\033[32m $module bootstrap success \033[0m" $level
    else
      log "\033[31m $module bootstrap fail \033[0m" $level
    fi
  else
    log "\033[31m $module is not defined \033[0m" $level
  fi
  log "\033[32m ------ $module end ------ \033[0m" $level
}

function command_exist() {
  # return 0 = true, 1 = false
  local command=$1

  if which $command > /dev/null; then
    return 0
  else
    return 1
  fi
}

function log() {
  local log=$1
  local level=$2

  for ((i=1;i<$level;i++)); do
    echo -n -e "    "
  done
  echo -e "$log"
}

function bootstrap_ohmyzsh() {
  # return 0 = true, 1 = false
  local level=$1

  log "\033[33m installing \033[0m" $level
  curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -o ohmyzsh_install.sh
  if [ $? -ne 0 ]; then
    rm -rf ./ohmyzsh_install.sh
    return 1
  fi
  chmod +x ./ohmyzsh_install.sh
  sh -c ./ohmyzsh_install.sh
  if [ $? -ne 0 ]; then
    rm -rf ./ohmyzsh_install.sh
    return 1
  fi

  log "\033[32m install success \033[0m" $level
  rm -rf ./ohmyzsh_install.sh
  return 0
}

function bootstrap_zsh() {
  # return 0 = true, 1 = false
  local level=$1

  bootstrap ohmyzsh 3
  if [ $? -ne 0 ]; then
    return 1
  fi

  #log "\033[33m configuring \033[0m" $level
  #chsh -s /bin/zsh
  #if [ $? -ne 0 ]; then
  #  return 1
  #fi
  #log "\033[32m configure success \033[0m" $level

  return 0
}

function bootstrap_vim() {
  # return 0 = true, 1 = false
  local level=$1

  log "\033[33m configuring \033[0m" $level
  cp ./_vimrc ~/.vimrc && mkdir ~/.vim/plugged
  if [ $? -ne 0 ]; then
    return 1
  fi
  log "\033[32m configure success \033[0m" $level

  return 0
}

function bootstrap_rbenv() {
  # return 0 = true, 1 = false
  local level=$1

  log "\033[33m configuring \033[0m" $level
  grep rbenv ~/.zshrc > /dev/null
  if [ $? -ne 0 ]; then
    echo 'if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi' >> ~/.zshrc
    if [ $? -ne 0 ]; then
      return 1
    fi
  fi
  log "\033[32m configure success \033[0m" $level

  return 0
}

function bootstrap_krew() {
  # return 0 = true, 1 = false
  local level=$1
  log "\033[33m configuring \033[0m" $level
  grep -e "PATH.*krew" ~/.zshrc > /dev/null
  if [ $? -ne 0 ]; then
    echo 'export PATH="${PATH}:${HOME}/.krew/bin"' >> ~/.zshrc
    if [ $? -ne 0 ]; then
      return 1
    fi
  fi
  kubectl krew install access-matrix ctx ns
  if [ $? -ne 0 ]; then
    return 1
  fi
  log "\033[32m configure success \033[0m" $level

  return 0
}

function bootstrap_kubectl() {
  # return 0 = true, 1 = false
  local level=$1

  log "\033[33m configuring \033[0m" $level
  grep -e "alias k.*kubectl" ~/.zshrc > /dev/null
  if [ $? -ne 0 ]; then
    echo 'alias k="kubectl"' >> ~/.zshrc
    if [ $? -ne 0 ]; then
      return 1
    fi
  fi
  log "\033[32m configure success \033[0m" $level

  return 0
}

function bootstrap_nodejs() {
  # return 0 = true, 1 = false
  local level=$1

  log "\033[33m configuring \033[0m" $level
  npm config set registry https://registry.npm.taobao.org
  if [ $? -ne 0 ]; then
    return 1
  fi
  #npm set disturl https://npm.taobao.org/dist
  #if [ $? -ne 0 ]; then
  #  return 1
  #fi
  log "\033[32m configure success \033[0m" $level

  return 0
}

function bootstrap_vsc() {
  # return 0 = true, 1 = false
  local level=$1

  log "\033[33m configuring \033[0m" $level
  defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false
  if [ $? -ne 0 ]; then
    return 1
  fi
  log "\033[32m configure success \033[0m" $level

  return 0
}

function bootstrap_brew() {
  # return 0 = true, 1 = false
  local level=$1

  command_exist "brew"
  if [ $? -ne 0 ]; then
    log "\033[33m installing \033[0m" $level
    curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh -o brew_install.sh
    if [ $? -ne 0 ]; then
      rm -rf ./brew_install.sh
      return 1
    fi
    chmod +x ./brew_install.sh
    /bin/bash -c ./brew_install.sh
    if [ $? -ne 0 ]; then
      rm -rf ./brew_install.sh
      return 1
    fi
    log "\033[32m install success \033[0m" $level
  fi

  log "\033[33m configuring repo \033[0m" $level
  source ./homebrew-switch.sh
  if [ $? -ne 0 ]; then
    return 1
  fi
  log "\033[32m configure repo success \033[0m" $level

  log "\033[33m installing formula \033[0m" $level
  brew install argocd axel bats-core colima dos2unix exif exiftool ffmpeg flux git graphviz helm hugo imagemagick ipcalc krew kubectx kubevela mpv node packer qrencode rbenv sqlite terraform vim wget youtube-dl
  if [ $? -ne 0 ]; then
    return 1
  fi
  log "\033[32m install formula success \033[0m" $level

  log "\033[33m installing cask formula \033[0m" $level
  brew install android-file-transfer android-studio caffeine docker drawio firefox gas-mask gimp github chromium hex-fiend iterm2 joplin karabiner-elements keepassxc macdown meld rar sequel-pro sqlitestudio youdaodict visual-studio-code vlc vmware-fusion wireshark xmind xquartz
  #brew install v2rayu
  if [ $? -ne 0 ]; then
    return 1
  fi
  chmod 700 ~/Applications
  log "\033[32m install cask formula success \033[0m" $level

  bootstrap zsh 2
  if [ $? -ne 0 ]; then
    return 1
  fi

  bootstrap vim 2
  if [ $? -ne 0 ]; then
    return 1
  fi

  bootstrap rbenv 2
  if [ $? -ne 0 ]; then
    return 1
  fi

  bootstrap krew 2
  if [ $? -ne 0 ]; then
    return 1
  fi

  bootstrap kubectl 2
  if [ $? -ne 0 ]; then
    return 1
  fi

  bootstrap nodejs 2
  if [ $? -ne 0 ]; then
    return 1
  fi

  bootstrap vsc 2

  return 0
}

function bootstrap_ssh() {
  # return 0 = true, 1 = false
  local level=$1

  if [ ! -e ~/.ssh/ ]; then
    mkdir ~/.ssh/
  fi
  if [ ! -e ~/.ssh/config ]; then
    touch ~/.ssh/config
  fi
  grep ControlMaster ~/.ssh/config > /dev/null
  if [ $? -ne 0 ]; then
cat>>~/.ssh/config<<EOF
Host *
    ForwardAgent yes
    ControlMaster auto
    ControlPath ~/.ssh/master-%r@%h:%p
    #ForwardX11 yes
    UseKeychain yes
    AddKeysToAgent yes
EOF
  fi

  return 0
}

function main() {
  bootstrap brew 1
  bootstrap ssh 1
}

main
