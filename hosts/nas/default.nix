{ ... }:
{
  imports = [
    ../../modules/git.nix
    ../../modules/neovim.nix
    ../../modules/zsh.nix
  ];

  programs.zsh.initContent = "";
}
