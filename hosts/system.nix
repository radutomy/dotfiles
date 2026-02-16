{ pkgs, lib, ... }:
{
  virtualisation.docker.enable = true;
  programs.zsh.enable = true;
  users.users.root = {
    shell = pkgs.zsh;
    createHome = true;
    group = lib.mkForce "users";
    homeMode = "775";
  };
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    warn-dirty = false;
  };
}
