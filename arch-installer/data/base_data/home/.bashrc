# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls="ls --color=auto"

# sudo autocomplete
complete -cf sudo

# Some utility functions
#-----------------------
em() {
    emacs-client "$@"
}

cim() {
    emacs-client-tui "$@"
}

# Extract pretty much everything
# $1 Path of the archive to extract
extract () {
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)   tar xjf $1     ;;
            *.tar.gz)    tar xzf $1     ;;
            *.bz2)       bunzip2 $1     ;;
            *.rar)       unrar e $1     ;;
            *.gz)        gunzip $1      ;;
            *.tar)       tar xf $1      ;;
            *.tbz2)      tar xjf $1     ;;
            *.tgz)       tar xzf $1     ;;
            *.zip)       unzip $1       ;;
            *.Z)         uncompress $1  ;;
            *.7z)        7z x $1        ;;
            *)     echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# Sway entry point
ssw() {
    sway-run
}

# Prompt stuff
#-------------
PROMPT_DIRTRIM=3
PROMPT_COMMAND=__prompt_command

__prompt_command() {
    local exit_code=$?

    local reset='\[\033[00m\]'
    local red='\[\033[01;31m\]'
    local green='\[\033[01;32m\]'
    local yellow='\[\033[01;33m\]'
    local white='\[\033[01;37m\]'
    local blue='\[\033[01;34m\]'

    local arrow="${blue}\[$(tput sc)\] \[$(tput rc)»\]"
    local begin="${blue}\[$(tput sc)\]  \[$(tput rc)╺─\]"
    local end="${blue}\[$(tput sc)\]  \[$(tput rc)─╸\]"

    local failed_code="${blue}[${red}${exit_code}${blue}]"
    local success_code="${blue}[${green}${exit_code}${blue}]"
    local path="${blue}[${reset}\w${blue}]"
    local name="${green}Frφ@Sadel${reset}"

    if [ $exit_code != 0 ]; then
        code=$failed_code
    else
        code=$success_code
    fi

    # Determine active Python virtualenv details.
    if test -z "$VIRTUAL_ENV"; then
        local _PYVENV=""
    else
        local _PYVENV="${blue}[$(basename \"$VIRTUAL_ENV\")]${reset} "
    fi

    PS1="${_PYVENV}${arrow} ${name}${begin}${code}${end}${path}${reset} "
}


# Eternal bash history.
# ---------------------
export HISTFILESIZE=
export HISTSIZE=
export HISTTIMEFORMAT="[%F %T] "
# Change the file location because certain bash sessions truncate
# .bash_history file upon close
export HISTFILE=~/.bash_eternal_history
# https://unix.stackexchange.com/questions/18212/bash-history-ignoredups-and-erasedups-setting-conflict-with-common-history/18443#18443
export HISTCONTROL=ignoredups:erasedups
shopt -s histappend
PROMPT_COMMAND="$PROMPT_COMMAND;history -n; history -w; history -c; history -r"

# Some useful envvars
#--------------------
export PYTHONDONTWRITEBYTECODE="NeverAgain"


# Source extra runcom
#--------------------
EXTRA_RUNCOM="$HOME/.bashrc.d"
if [ -d "$EXTRA_RUNCOM" ]; then
    for f in "$EXTRA_RUNCOM"/* "$EXTRA_RUNCOM"/.[^.]*; do
        [ -f "$f" ] && source "$f"; done
fi
