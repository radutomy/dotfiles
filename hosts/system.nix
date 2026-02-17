{ pkgs, lib, ... }:
{
  virtualisation.docker.enable = true;
  # lets non-Nix binaries (pip, npm, etc.) find shared libraries
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      stdenv.cc.cc.lib
      zlib
    ];
  };
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
