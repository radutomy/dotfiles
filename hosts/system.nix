{ pkgs, ... }:
{
  virtualisation.docker.enable = true;
  users.users.root.shell = pkgs.zsh;
  programs.zsh.enable = true;
}
