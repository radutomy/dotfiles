set fish_greeting # supress fish greeting

set hydro_color_pwd green
set hydro_color_git yellow
set fish_color_valid_path # no text underlying when pressing tab
set fish_pager_color_prefix # no text underying when pressing tab

set fish_prompt_pwd_dir_length 100 # maximum lenght of dir path
#set fish_key_bindings fish_vi_key_bindings
set fish_key_bindings fish_default_key_bindings

set -x EDITOR nvim
set -x GPG_TTY=$(tty)

# when CTRL+F press ENTER to open the file in EDITOR
set fzf_directory_opts --bind "enter:execute($EDITOR {} &> /dev/tty)"

# CTRL+F search for file; CTRL+L git status
fzf_configure_bindings --directory=\cf --git_log=\cl --git_status=\cs --variables=\ck

# fzf - find hidden files
set fzf_fd_opts --hidden --max-depth 5
#set -x ZELLIJ_AUTO_EXIT false
#set -x ZELLIJ_AUTO_ATTACH true

#bind \t accept-autosuggestion
#bind \t 'commandline -f complete-and-search'
#bind -M insert \t accept-autosuggestion
#bind -M insert \t 'commandline -f complete-and-search'
