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
    copyWezterm() {
      src="${config.xdg.configHome}/wezterm/wezterm.lua"

      # OrbStack → macOS host
      MAC_USER=$(ls /mnt/mac/Users | grep -v Shared | head -n 1)
      [ -n "$MAC_USER" ] && install -D "$src" "/mnt/mac/Users/$MAC_USER/.config/wezterm/wezterm.lua"

      # WSL → Windows host
      WIN_USER=$(cmd.exe /c "echo %USERNAME%" | tr -d '\r')
      [ -n "$WIN_USER" ] && install -D "$src" "/mnt/c/Users/$WIN_USER/.config/wezterm/wezterm.lua"
    }
    copyWezterm || true
  '';
}
