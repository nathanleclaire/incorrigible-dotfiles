#!/bin/bash

rm -rf ${HOME}/.vim ${HOME}/.vimrc ${HOME}/.bashrc ${HOME}/.bash_profile
ln -s $(pwd)/.vim ${HOME}/.vim
ln -s $(pwd)/.vimrc ${HOME}/.vimrc
ln -s $(pwd)/.bashrc ${HOME}/.bashrc
ln -s $(pwd)/.emacs.d ${HOME}/.emacs.d
. ${HOME}/.bashrc
