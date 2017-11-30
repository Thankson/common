#! /usr/bin/env bash

set -eux
set -o pipefail

vundleDIR=~/.vim/bundle/vundle
passwd=steven

echo "###start###"

# install vundle soft
if [[ -d $vundleDIR ]];then
  echo "vundle already installed."
else
  echo $passwd | sudo -S git clone http://github.com/gmarik/vundle.git $vundleDIR
  echo "vundle has installed just now."
fi

# 安装ctags，ctags用于支持taglist，必需！
echo $passwd | sudo -S apt-get install -y ctags
# 安装taglist
echo $passwd | sudo -S apt-get install -y vim-scripts
echo $passwd | sudo -S apt-get install -y vim-addon-manager
echo $passwd | sudo -S vim-addons install taglist

# 安装pydiction（实现代码补全）
echo $passwd | sudo -S wget http://www.pythonclub.org/_media/python-basic/pydiction-1.2.zip
echo $passwd | sudo -S unzip pydiction-1.2.zip
mkdir -p ~/.vim/after/ftplugin/
mkdir -p ~/.vim/tools/pydiction/
echo $passwd | sudo -S cp pydiction-1.2/python_pydiction.vim ~/.vim/after/ftplugin
echo $passwd | sudo -S cp pydiction-1.2/complete-dict ~/.vim/tools/pydiction/complete-dict

cp .vimrc     ~/

cp .gitconfig ~/

echo "###end###"
