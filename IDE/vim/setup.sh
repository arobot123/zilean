#!/bin/bash

CUR_PATH=$(dirname $(realpath ${BASH_SOURCE[0]}))
TARGET_PATH=$HOME/.vim

cd $CUR_PATH || exit 1


# 插件管理器
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

rsync -avPz vimrc config $TARGET_PATH/

# 进入vim编辑
vim