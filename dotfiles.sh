#!/bin/bash

set -e

automated_update_msg () {
    echo "AUTOMATED DOTFILES UPDATE | $(whoami)@$(hostname) (ﾟヮﾟ)"
}

sync_submodules () {
    VIMDIR=".vim/bundle"
    SUBMODULES="${VIMDIR}/ctrlp-matcher ${VIMDIR}/vim-fugitive ${VIMDIR}/vim-go"
    for submodule in ${SUBMODULES}; do
        echo "Updating ${submodule}..."
        cd ${submodule} >/dev/null
        git add --all :/ >/dev/null && git commit -m "$(automated_update_msg)"
        cd - >/dev/null
    done
}

provision_ubuntu () {
    echo 127.0.1.1 $(hostname) | sudo tee -a /etc/hosts
    curl -sL https://deb.nodesource.com/setup | sudo bash -
    sudo apt-get install -y tree git mercurial jq tmux htop make nodejs build-essential autojump
    VERSION="1.6"
    OS="linux"
    ARCH="amd64"
    sudo wget https://storage.googleapis.com/golang/go${VERSION}.${OS}-${ARCH}.tar.gz -O /usr/local/go.tar.gz
    sudo tar -C /usr/local -xzf /usr/local/go.tar.gz
    sudo rm /usr/local/go.tar.gz
    sudo apt-get install -y golang-go.tools
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
        FILES_TO_LINK=".vim .vimrc .bashrc .zshrc .oh-my-zsh .tmux.conf"
        for file in ${FILES_TO_LINK}; do
            rm -rf ${HOME}/${file}
        done
        cd ${DIR} >/dev/null
        git submodule update --init --recursive
        cd - >/dev/null
        for file in ${FILES_TO_LINK}; do
            ln -s ${DIR}/${file} ${HOME}/${file}
        done
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
