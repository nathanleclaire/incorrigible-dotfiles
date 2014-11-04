from ubuntu:latest

run apt-get update && apt-get install -y curl vim sudo openssh-client
add . /root/incorrigible-dotfiles
workdir /root/incorrigible-dotfiles
run mkdir .ssh
run touch .ssh/id_rsa
run ./dotfiles.sh install
run ./dotfiles.sh provision ubuntu

entrypoint ["bash"]
