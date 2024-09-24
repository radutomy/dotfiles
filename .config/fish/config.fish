### Set PATH ###

fish_add_path $HOME/.cargo/bin

if status is-interactive
    # Commands to run in interactive sessions can go here
end

### Login-Shell-Specific Configs ###
if status is-login
    # Commands to run in login sessions can go here
end
if status is-interactive
end
