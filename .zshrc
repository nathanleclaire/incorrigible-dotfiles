# Path to your oh-my-zsh installation.
export ZSH=/root/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="robbyrussell"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

# User configuration

export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
# export MANPATH="/usr/local/man:$MANPATH"

source $ZSH/oh-my-zsh.sh

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
export TERM=xterm-256color

alias phpunit="phpunit --colors"
export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced

export GOPATH=$HOME/go
export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin

function newbox () {
    docker run -it --name $1 \
       --volumes-from=volume_container \
       -v /var/run/docker.sock:/var/run/docker.sock \
       nathanleclaire/devbox
}
function da () {
	docker start $1 && docker attach $1
}
alias drm="docker rm"
alias dps="docker ps"

function half() {
	convert -resize 50% $1 $1
}

dps-monitor() {
   while true
   do
       clear
       docker ps | cut -c -$(tput cols)
       sleep 0.5
   done
}

cleanimages() {
    docker rmi $(docker images | grep none | awk '{ print $3; }')
}

cleancontainers() {
    docker rm $(docker ps -aq)
}

sfserver() {
    if [ $# -eq 0 ]; then
        PORT=8000
    else
        PORT=$1
    fi
    echo "=> Running static file server in $(pwd) on port ${PORT}..."
    docker run --rm -it -v $(pwd):/data -p $PORT:8000 nathanleclaire/sfserver
}

rreplace () {
    find . -type f -exec sed -i "s/$1/$2/" {} \;
}

export EDITOR=vim

if [[ $(uname -s) == "Darwin" ]]; then
    export JAVA_HOME=$(/usr/libexec/java_home)
    export EC2_HOME=/usr/local/ec2/ec2-api-tools-1.7.1.1/
    export PATH=$PATH:$EC2_HOME/bin
    export DOCKER_HOST=tcp://boot2docker:2376
    export DOCKER_CERT_PATH=/Users/nathanleclaire/.boot2docker/certs/boot2docker-vm
    export DOCKER_TLS_VERIFY=1
fi

if [[ $(which git) != "" ]]; then
    git config --global user.email "nathan.leclaire@gmail.com"
    git config --global user.name "Nathan LeClaire"
fi


pageburn() { 
    cd .themes/pageburner && \
    git commit -am "Update theme" && \
    cd - && \
    git add .themes/pageburner && \
    git commit -am "Update submodule" 
}

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
