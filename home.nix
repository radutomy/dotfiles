{
  pkgs,
  pkgs-unstable,
  username,
  ...
}:
{
  news.display = "silent";
  home = {
    inherit username;
    homeDirectory = if username == "root" then "/root" else "/home/${username}";
    stateVersion = "25.11";

    packages = with pkgs; [
      # tools
      python3
      pipx
      unzip
      ripgrep
      jq
      fd
      bat
      htop
      age
      tmux

      # treesitter
      gcc
      nodejs

      # ai
      claude-code
      codex
      pkgs-unstable.gemini-cli
    ];

    sessionPath = [
      "$HOME/.local/bin"
      "$HOME/.cargo/bin"
    ];
  };

  programs = {
    home-manager.enable = true;
    lazygit.enable = true;

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
