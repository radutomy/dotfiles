{ ... }:
{
  imports = [
    ../../modules/git.nix
    ../../modules/neovim.nix
    ../../modules/zsh.nix
  ];

  programs.zsh.initContent = ''
    if [[ -z "$TMUX" && $- == *i* ]]; then
      tmux new-session -A -s main \; set status on \; set status-position bottom \; set status-left "" \; set status-right "#[fg=green] 󰒍 NAS   " \; set pane-border-status off
    fi
  '';
}
