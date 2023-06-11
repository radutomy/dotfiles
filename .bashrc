#-----------------------------# 
# SHELL - HISTORY             a 
#-----------------------------#

shopt -s histappend
HISTCONTROL=ignoreboth
HISTSIZE=5000
HISTFILESIZE=
HISTFILE=~/.bash.log

#-------------------------# 
# SHELL - FUNCTIONALITY   # 
#-------------------------# 

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# bash autocompletion (for apt, etc..)
if [ -f /etc/bash_completion ]; then
  . /etc/bash_completion
fi

# fzf CTRL+T and ALT+C in bash
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

#-------------------------# 
# SHELL - LOOK AND FEEL   # 
#-------------------------# 

shopt -s extglob 
shopt -qs globstar 
shopt -qs checkwinsize 
shopt -qs hostcomplete 
shopt -qs no_empty_cmd_completion 

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# remove annoying colored border from directories when ls
LS_COLORS=$LS_COLORS:'ow=1;34:tw=1;34:' ; export LS_COLORS

# PS1 configuration
export PS1="\[\e[32m\]\u\[\e[m\]\[\e[32m\]@\[\e[m\]\[\e[32m\]\h\[\e[m\]:\[\e[33m\]\w\[\e[m\] \[\e[35m\]\[\e[m\]\[\e[31m\]\[\e[m\]\[\e[37m\]\\$\[\e[m\] "

#-------------------------# 
# ALIASES - SYSTEM        # 
#-------------------------# 

alias la='ls -A --color=always'
alias l='ls -CF --color=always'
alias ls='command ls --human-readable --group-directories-first --color=always -I NTUSER\* -I ntuser\* -I AppData\*'
alias ll='command ls -alF --human-readable --group-directories-first --color=always -I NTUSER.DAT\* -I ntuser.dat\* -I AppData\*'
alias less='less --RAW-CONTROL-CHARS'
alias x='clear'

#-------------------------# 
# EXPORTS				  # 
#-------------------------# 

export LS_OPTS='--color=auto'

