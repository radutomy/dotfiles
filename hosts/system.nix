{ pkgs, ... }:
{
  virtualisation.docker.enable = true;
  users.users.root.shell = pkgs.zsh;
  users.users.root.group = "users";
  users.users.root.homeMode = "775";
  programs.zsh.enable = true;
}
