{ config, lib, ... }:
{
  imports = [
    ../../modules/git.nix
    ../../modules/rust.nix
    ../../modules/work.nix
    ../../modules/zsh.nix
  ];

  programs.ssh.matchBlocks = {
    naspi = {
      hostname = "192.168.0.25";
      user = "root";
      identityFile = "~/.ssh/id_ed25519";
    };
    nas = {
      hostname = "192.168.0.2";
      user = "root";
      identityFile = "~/.ssh/id_rsa";
    };
  };

  home.activation.copyWezterm = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
    MAC_USER=$(ls /mnt/mac/Users | grep -v Shared | head -n 1)
    install -D "${config.xdg.configHome}/wezterm/wezterm.lua" "/mnt/mac/Users/$MAC_USER/.config/wezterm/wezterm.lua"
  '';
}
