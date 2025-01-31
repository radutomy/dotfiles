if status is-login
    # Set PATH (one time for the entire session)
    fish_add_path $HOME/.cargo/bin
end

if status is-interactive
    # Auto-activate virtual environments only in interactive shells
    #functions -q auto_activate_venv; or source ~/.config/fish/functions/auto_activate_venv.fish

    # Set GPG_TTY so GPG can prompt for passphrases in the current TTY
    set -x GPG_TTY (tty)

    # Custom key bindings for finding files
    bind \cg _fzf_grep_directory
end
