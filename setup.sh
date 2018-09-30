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

git clone https://github.com/riywo/anyenv ~/.anyenv
## TODO
## change shell install *env.

## TODO
## install SDKman.

## TODO
## install powerline_shell.

git clone https://github.com/krhrtky/dotfiles.git ~/dotfiles

## ln
ln -s ~/dotfiles/config/zsh/.zshrc ~/.zshrc
ln -s ~/dotfiles/config/tmux/.tmux.conf ~/.tmux.conf
ln -s ~/dotfiles/config/vim/init.vim ~/.config/nvim/init.vim
