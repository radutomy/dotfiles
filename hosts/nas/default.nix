{ ... }:
{
  imports = [
    ../../modules/git.nix
    ../../modules/neovim.nix
    ../../modules/zsh.nix
  ];

  programs.zsh.initContent = ''
    if [[ -z "$TMUX" && $- == *i* ]]; then
      tmux new-session -A -s main \; set status off
    fi
  '';
}
