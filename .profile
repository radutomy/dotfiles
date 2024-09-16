#-----------------------------# 
# SHELL - HISTORY             a 
#-----------------------------#

HISTCONTROL=ignoreboth
HISTSIZE=5000
HISTFILESIZE=
HISTFILE=~/.bash_hist.log

#-------------------------# 
# SHELL - FUNCTIONALITY   # 
#-------------------------# 

# fzf CTRL+T and ALT+C in bash
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

#-------------------------# 
# SHELL - LOOK AND FEEL   # 
#-------------------------# 

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

export LS_OPTS='--color=auto'

#-------------------------#
# ALIASES - SYSTEM        #
#-------------------------#

alias tm='tmux new-session \; \
	send-keys 'clear' C-m \; \
	split-window -v -p 30 \; \
	send-keys 'clear' C-m \; \
	select-pane -t 0 \; \
	split-window -h \; \
	send-keys 'clear' C-m \; \
	new-window \; \
	send-keys 'clear' C-m \; \
	select-window -t 0 \; \
	select-pane -t 0 \;'

alias tx='tmux new-session \; \
	split-window -v \; \
	select-window -t :0 \;'

alias ta='tmux attach -t 0'

alias la='ls -A --color=always'
alias l='ls -CF --color=always'
alias ls='command ls --group-directories-first --color=always'
alias ll='command ls -alF --group-directories-first --color=always'
alias less='less --RAW-CONTROL-CHARS'
alias x='clear'

alias shb='docker run -it -v /dev:/dev --name smarthub --privileged --network host --rm --pull always ticketergroup/smarthub:dev'
alias dbg='docker run -it -v /dev:/dev --name dotnet --privileged --network host --entrypoint bash mcr.microsoft.com/dotnet/sdk:6.0-jammy'

#-------------------------# 
# EXPORTS				  # 
#-------------------------# 

