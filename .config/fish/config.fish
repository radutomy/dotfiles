if status is-interactive
	set -x ZELLIJ_AUTO_EXIT true
	set -x ZELLIJ_AUTO_ATTACH true
	eval (zellij setup --generate-auto-start fish | string collect)
end

# ===== ENV ===== #

fish_add_path $HOME/.cargo/bin

# ===== ALIAS ===== #

alias pi1='ssh pi1'
alias pi2='ssh pi2'
alias sb='ssh sb'
alias nas='ssh nas'
alias sgw1='~/.config/work/login-sgw.exp sgw1'
alias sgw2='~/.config/work/login-sgw.exp sgw2'
alias w='cd $winhome/Downloads'
alias g='cd /mnt/c/gdrive'
alias c='clear'

alias ls='lsd --group-dirs=first'
alias ll='lsd -lh --group-dirs=first'
alias l='lsd -A --group-dirs=first'
alias lr='lsd --tree --group-dirs=first'
alias lx='lsd -X --group-dirs=first'
alias lt='lsd --tree --group-dirs=first'

alias vim='nvim'

# ===== SET ===== #

set hydro_color_pwd green
set hydro_color_git yellow
set fish_color_valid_path 				# no text underlying when pressing tab
set fish_pager_color_prefix 			# no text underying when pressing tab

set fish_prompt_pwd_dir_length 100 		# maximum lenght of dir path
set fish_key_bindings fish_vi_key_bindings

set EDITOR "nvim"

# when CTRL+F press ENTER to open the file in EDITOR
set fzf_directory_opts --bind "enter:execute($EDITOR {} &> /dev/tty)"

# CTRL+F search for file; CTRL+L git status
fzf_configure_bindings --directory=\cf --git_log=\cl --git_status=\cs

# fzf - find hidden files
set fzf_fd_opts --hidden --max-depth 5

#bind \t accept-autosuggestion
#bind \t 'commandline -f complete-and-search'
#bind -M insert \t accept-autosuggestion
#bind -M insert \t 'commandline -f complete-and-search'

