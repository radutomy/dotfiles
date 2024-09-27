### Set PATH ###

fish_add_path $HOME/.cargo/bin
bind \cg _fzf_grep_directory

### Login-Shell-Specific Configs ###

if status is-interactive
    # Commands to run in interactive sessions can go here
end

if status is-login
    # Commands to run in login sessions can go here
end
