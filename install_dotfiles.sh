#!/bin/bash

rm -rf $HOME/.vim $HOME/.vimrc $HOME/.bashrc $HOME/.bash_profile
ln -s `pwd`/.vim $HOME/.vim
ln -s `pwd`/.vimrc $HOME/.vimrc
ln -s `pwd`/.bashrc $HOME/.bashrc
ln -s `pwd`/.bash_profile $HOME/.bash_profile
. $HOME/.bashrc
