{ ... }:
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
}
