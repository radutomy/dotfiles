{ ... }:
{
  imports = [
    ../../modules/git.nix
    ../../modules/neovim.nix
    ../../modules/zsh.nix
  ];

  programs.zsh.initContent = ''
    if [[ -z "$TMUX" && $- == *i* ]]; then
      tmux new-session -A -s main \; set status-position bottom \; set status-right "#[fg=green] 󰒍 NAS   " \; setw window-status-format "" \; setw window-status-current-format "" \; set pane-border-status off    fi
  '';
}
