if status is-login
    # Set PATH (one time for the entire session)
    fish_add_path $HOME/.cargo/bin
    fish_add_path $HOME/.local/bin
end

if status is-interactive
    # Auto-activate virtual environments only in interactive shells
    #functions -q auto_activate_venv; or source ~/.config/fish/functions/auto_activate_venv.fish

    # Set GPG_TTY so GPG can prompt for passphrases in the current TTY
    set -x GPG_TTY (tty)

    # Custom key bindings for finding files
    bind \cg _fzf_grep_directory

    # Disable Alt+L (unbind it)
    bind \el ''

    # Disable hydro error status display
    function _hydro_postexec --on-event fish_postexec; set -g _hydro_status "$_hydro_newline$_hydro_color_prompt$hydro_symbol_prompt"; end
end

zoxide init fish | source

# pnpm
set -gx PNPM_HOME "/root/.local/share/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end
