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
    WIN_USER=$(/mnt/c/Windows/System32/cmd.exe /c "echo %USERNAME%" | tr -d '\r')
    install -D "${config.xdg.configHome}/wezterm/wezterm.lua" "/mnt/c/Users/$WIN_USER/.config/wezterm/wezterm.lua"
  '';
}
