{ pkgs, lib, ... }:
{
  virtualisation.docker.enable = true;
  users.users.root.shell = pkgs.zsh;
  users.users.root.createHome = true;
  users.users.root.group = lib.mkForce "users";
  users.users.root.homeMode = "775";
  programs.zsh.enable = true;
}
