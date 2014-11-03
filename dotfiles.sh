#!/bin/bash

automated_update_msg () {
    echo "AUTOMATED DOTFILES UPDATE | $(whoami)@$(hostname) (ﾟヮﾟ)"
}

sync_submodules () {
    VIMDIR=".vim/bundle"
    SUBMODULES=".emacs.d ${VIMDIR}/ctrlp-matcher ${VIMDIR}/vim-fugitive ${VIMDIR}/vim-go"
    for submodule in ${SUBMODULES}; do
        echo "Updating ${submodule}..."
        cd ${submodule} >/dev/null
        git add --all :/ >/dev/null && git commit -m "$(automated_update_msg)"
        cd - >/dev/null
    done
}

provision_ubuntu () {
    curl -sL https://deb.nodesource.com/setup | sudo bash -
    sudo apt-get install -y tree git mercurial jq tmux htop make nodejs build-essential autojump
}

provision_osx () {
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    brew install wget jq cmake autojump tmux weechat mercurial gnutls node tree autojump
}

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
case "$1" in
    diff)
        cd ${DIR} >/dev/null
        git diff
        cd - >/dev/null
        ;;
    install)
        rm -rf ${HOME}/.vim ${HOME}/.vimrc ${HOME}/.bashrc ${HOME}/.emacs.d ${HOME}/.tmux.conf
        cd ${DIR} >/dev/null
        git submodule update --init --recursive
        cd - >/dev/null
        ln -s ${DIR}/.vim ${HOME}/.vim
        ln -s ${DIR}/.vimrc ${HOME}/.vimrc
        ln -s ${DIR}/.bashrc ${HOME}/.bashrc
        ln -s ${DIR}/.emacs.d ${HOME}/.emacs.d
        ln -s ${DIR}/.tmux.conf ${HOME}/.tmux.conf
        . ${HOME}/.bashrc
        ;;
    provision)
        case "$2" in 
            ubuntu)
                provision_ubuntu
                ;;
            osx)
                provision_osx
                ;;
            *)
                echo "Unknown OS specified.  Usage: dotfiles provision [ubuntu|osx]"
                exit 1
        esac
        if [[ $(which git) != "" ]]; then 
            git config --global user.name "Nathan LeClaire"
            git config --global user.email "nathan.leclaire@gmail.com"
            git config --global core.editor vim
            git config --global push.default simple
        fi
        if [[ ! -e ~/.ssh/id_rsa ]]; then
            ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa
        fi
        ;;
    sync)
        cd ${DIR} >/dev/null
        git fetch origin
        if [[ "$2" == "" ]]; then
            MSG=$(automated_update_msg)
        else
            MSG=$2
        fi
        sync_submodules
        git add --all :/ && \
            git commit -m "${MSG}"
        git rebase origin/master
        git push origin master
        cd - >/dev/null
        ;;
    *)
        echo "Usage: dotfiles [diff|install|sync]"
        exit 1
esac
