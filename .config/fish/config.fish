if status is-interactive
	# Commands to run in interactive sessions can go here
end

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

# ===== SET ===== #


set -g hydro_color_pwd green
set -g hydro_color_git yellow
set -g fish_prompt_pwd_dir_length 100 # maximum lenght of dir path

set fish_color_valid_path
set fish_pager_color_prefix
set fish_vi_key_bindings

set -gx EDITOR "nvim"  # Use "vim", "code", or another editor
set fzf_directory_opts --bind "enter:execute($EDITOR {} &> /dev/tty)"

fzf_configure_bindings --directory=\cf --git_log=\cl --git_status=\cs

#bind \t accept-autosuggestion
#bind \t 'commandline -f complete-and-search'
