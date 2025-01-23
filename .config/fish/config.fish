### Set PATH ###

fish_add_path $HOME/.cargo/bin
bind \cg _fzf_grep_directory

# This is needed for GPG operations that require terminal interaction, like password prompts or PIN entry.
set -x GPG_TTY (tty)

### Login-Shell-Specific Configs ###

if status is-interactive
    # Commands to run in interactive sessions can go here
end

if status is-login
    # Commands to run in login sessions can go here
end
