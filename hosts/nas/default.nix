{ config, ... }:
{
  imports = [
    ../../modules/git.nix
    ../../modules/neovim.nix
    ../../modules/zsh.nix
  ];

  home.sessionVariables.HOST_ICON = "󰒍";

  programs.zsh.shellAliases.tmux = "command tmux -f ${config.xdg.configHome}/tmux/tmux.nas.conf";

  programs.zsh.initContent = ''
    if [[ -z "$TMUX" && $- == *i* ]]; then
      exec tmux new-session -A -s main \; set status off \; set pane-border-status off
    fi
  '';
}
