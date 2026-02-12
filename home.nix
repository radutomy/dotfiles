{
  pkgs,
  pkgs-unstable,
  username,
  ...
}:
{
  imports = [ ./modules/neovim.nix ];
  news.display = "silent";
  xdg.configFile."nix/nix.conf".text = "experimental-features = nix-command flakes\n";

  home = {
    inherit username;
    homeDirectory = if username == "root" then "/root" else "/home/${username}";
    stateVersion = "25.11";

    packages = with pkgs; [
      python3
      unzip
      ripgrep
      jq
      fd
      bat
      nodejs
      gcc
      htop
      age
      tmux
      pkgs-unstable.claude-code
      pkgs-unstable.codex
      pkgs-unstable.gemini-cli
    ];

    sessionPath = [ "$HOME/.local/bin" ];
  };

  programs = {
    home-manager.enable = true;

    lazygit = {
      enable = true;
      settings = {
        git.pagers = [
          {
            colorArg = "always";
            pager = "delta --dark --paging=never";
          }
        ];
      };
    };

    ssh = {
      enable = true;
      enableDefaultConfig = false;
      matchBlocks."*" = {
        extraOptions = {
          StrictHostKeyChecking = "no";
          UserKnownHostsFile = "/dev/null";
        };
      };
    };
  };

}
