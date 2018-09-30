#!/bin/sh
CURRENT_DIR=`pwd`

## Homebrew
echo "[info] install Homebrew."
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

(
  cd ~/dotfiles
  CURRENT_DIR=`pwd`
  echo "[info] change dir ${CURRENT_DIR}"
  echo "[info] bundle Brewfile."
  brew bundle
)

CURRENT_DIR=`pwd`
echo "[info] change dir ${CURRENT_DIR}"

sudo echo "/usr/local/bin/zsh" >> /etc/shells

## ln
