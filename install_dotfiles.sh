#!/bin/bash

rm -rf $HOME/.vim $HOME/.vimrc $HOME/.bashrc
ln -s `pwd`/.vim $HOME/.vim
ln -s `pwd`/.vimrc $HOME/.vimrc
ln -s `pwd`/.bashrc $HOME/.bashrc
. $HOME/.bashrc
