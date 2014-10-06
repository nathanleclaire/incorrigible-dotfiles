# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

alias e="emacsclient"

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
#if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
#   . /etc/bash_completion
#fi

function parse_git_branch () {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/|\1|/'
}

function parse_box () {
	if env | grep -q ^BOX_NAME=
	then
		echo "{c:$BOX_NAME}"
	else
		HOSTNAME=$(hostname)
		if [[ ${HOSTNAME} =~ [0-9a-f]{12} ]] ; then
			echo "{c:${HOSTNAME}}"
		fi
		echo ""
	fi
}

RED="\[\033[0;31m\]"
YELLOW="\[\033[0;33m\]"
GREEN="\[\033[0;32m\]"
LIGHT_GRAY="\[\033[0;37m\]"
NO_COLOUR="\[\033[0m\]"

PS1="$RED\$(parse_box)$YELLOW\$(parse_git_branch)$GREEN\w$NO_COLOUR\$ "

[[ $- = *i* ]] && bind TAB:menu-complete

export TERM=xterm-256color
bind '"\eOC":forward-word'
bind '"\eOD":backward-word'

alias phpunit="phpunit --colors"
export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced

export GOPATH=$HOME/go
export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin

function newbox () {
    docker run -it --name $1 \
       --volumes-from=volume_container \
       -v /var/run/docker.sock:/var/run/docker.sock \
       -e BOX_NAME=$1 \
       nathanleclaire/devbox
}
function da () {
	docker start $1 && docker attach $1
}
alias drm="docker rm"
alias dps="docker ps"

if [ $(uname -s) = "Darwin" ]; then
	export DOCKER_HOST=tcp://boot2docker:2375
else
    unset DOCKER_HOST
fi

function half() {
	convert -resize 50% $1 $1
}

docker-enter() {
    boot2docker ssh '[ -f /var/lib/boot2docker/nsenter ] || docker run --rm -v /var/lib/boot2docker/:/target jpetazzo/nsenter'
    boot2docker ssh -t sudo /var/lib/boot2docker/docker-enter "$@"
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

export EDITOR=vim
