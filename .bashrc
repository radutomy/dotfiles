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

#-------------------------# 
# EXPORTS		  # 
#-------------------------# 

# PS1 configuration
export PS1="\[\e[32m\]\u\[\e[m\]\[\e[32m\]@\[\e[m\]\[\e[32m\]\h\[\e[m\]:\[\e[33m\]\w\[\e[m\] \[\e[35m\]\[\e[m\]\[\e[31m\]\[\e[m\]\[\e[37m\]\\$\[\e[m\] "

export LS_OPTS='--color=auto'
# ignore folders when searching with fzf
export FZF_DEFAULT_COMMAND='rg --files --follow --line-number --no-ignore-vcs --no-require-git --hidden -g "!{node_modules,.git,downloads,build,.repo}"'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

#-------------------------#
# ALIASES - SYSTEM        #
#-------------------------#

winhome=/mnt/c/Users/radut
winroot=/mnt/c

alias tm='tmux new-session \; \
	send-keys 'clear' C-m \; \
	split-window -v -p 30 \; \
	send-keys 'clear' C-m \; \
	split-window -h \; \
	send-keys 'clear' C-m \; \
	select-pane -t 0 \; \
	split-window -h \; \
	send-keys 'clear' C-m \; \
	new-window \; \
	split-window -h \; \
	send-keys 'clear' C-m \; \
	select-window -t 0 \; \
	select-pane -t 0 \;'

#alias tm='tmux new-session \; \
#	send-keys 'vim' C-m \; \
#	split-window -v -p 20 \; \
#	select-pane -t 0 \; \
#	split-window -h \; \
#	send-keys 'vim' C-m \; \
#	new-window \; \
#	select-window -t 0 \; \
#	select-pane -t 0 \;'

alias tx='tmux new-session \; \
	split-window -v \; \
	select-window -t :0 \;'

alias ta='tmux attach -t 0'
alias tk='tmux kill-server'

alias la='ls -A --color=always'
alias l='ls -CF --color=always'
alias ls='command ls --human-readable --group-directories-first --color=always -I NTUSER\* -I ntuser\* -I AppData\*'
alias ll='command ls -alF --human-readable --group-directories-first --color=always -I NTUSER.DAT\* -I ntuser.dat\* -I AppData\*'
alias less='less --RAW-CONTROL-CHARS'
alias x='clear'

alias pi='ssh ticketer@192.168.0.13 -i ~/.ssh/id_ticketer'
alias ih='ssh root@192.168.0.29 -p 22 -i ~/.ssh/id_ticketer'
alias pir='ssh pi@90.251.251.119 -p 2630'
alias ihr='ssh root@90.251.251.119 -p 22'
alias d='cd $winroot/src/device-main'
alias c='cd $winroot'
alias s='cd $winroot/src'
alias u='cd $winhome'
alias w='cd $winhome/Downloads'
alias v='cd $winroot/src/device-main/VG1'
alias m="cd '$winroot/Program Files/mosquitto'"

alias shb='(cd /mnt/c/src/SmartHub && docker buildx build --platform linux/arm/v7 -t ticketergroup/smarthub:dev --push .)'
alias qq='dotnet publish /mnt/c/src/device-main/VG1.G710/VG1.G710.csproj -c Release -r linux-musl-arm --self-contained false -p:PublishSingleFile=false,DebugType=None,DebugSymbols=false -o /mnt/c/src/vg1-app'
alias ww='dotnet run --project /mnt/c/src/device-main/Packager/App-net6/MobilePackager.csproj -c Release 1.18.1.4 /mnt/c/src/vg1-app zip Ihvg710'
