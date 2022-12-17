# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
export HISTCONTROL=ignoredups:ignorespace
export HISTSIZE="20000"
export HISTFILESIZE="20000"
export HISTTIMEFORMAT="%a, %d %b %Y %T "
export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced
export GOPATH=$HOME/go
export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin
export EDITOR=vim

nocolor="\[\e[0m\]"
lightblue="\[\e[38;5;111m\]"
lightgray="\[\e[38;5;101m\]"
lightgreen="\[\e[38;5;113m\]"
red="\[\e[38;5;196m\]"

if [[ $(uname -s) != "Darwin" ]]; then
    # append to the history file, don't overwrite it
    shopt -s histappend

    # check the window size after each command and, if necessary,
    # update the values of LINES and COLUMNS.
    shopt -s checkwinsize

    [[ $- = *i* ]] && bind TAB:menu-complete

    bind '"\eOC":forward-word'
    bind '"\eOD":backward-word'
else
    PATH="/opt/homebrew/opt/gnu-sed/libexec/gnubin:$PATH"
fi

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

export PROMPT_COMMAND=__prompt_command

parse_git_branch() {
    git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/|\1|/'
}

last_cmd_status() {
    if [[ "$1" -eq 0 ]]; then
        echo "${lightgreen}•"
    else
        echo "${red}•"
    fi
}

__prompt_command() {
    local EXIT="$?"

    # Append this terminal's history list to history file.  This will write the
    # history after every command without needing to 'exit' first.
    history -a

    if [[ $COLUMNS -lt 80 ]]; then
        PS1="$ "
    else
        PS1="$(last_cmd_status "$EXIT")${lightblue}$(parse_git_branch)${lightgray}\w\$ ${nocolor}"
    fi
}

half() {
	convert -resize 50% $1 $1
}

watchcmd() {
    while true; do
        "$1"
        sleep 1
        clear
    done
}

gcimage() {
    docker rmi $(docker images | grep none | awk '{ print $3; }')
}

gccontainer() {
    docker rm $(docker ps -aq)
}

rreplace() {
    find . -type f -exec sed -i "s/$1/$2/" {} \;
}


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

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
    alias phpunit="phpunit --colors"
fi

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

if [[ $(which git) != "" ]]; then
    git config --global user.email "nathan.leclaire@gmail.com"
    git config --global user.name "Nathan LeClaire"
fi

alias dm="docker-machine"

lg () {
    rg -p "$@" | less -RFX
}

if [[ $(which python3) != "" ]]; then
    alias python=python3
fi
if [[ $(uname) = "Linux" ]]; then
    alias pbcopy='xsel --clipboard --input'
    alias pbpaste='xsel --clipboard --output'
fi
#. "$HOME/.cargo/env"
