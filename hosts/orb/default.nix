{ config, lib, ... }:
{
  imports = [
    ../../modules/git.nix
    ../../modules/neovim.nix
    ../../modules/rust.nix
    ../../modules/work.nix
    ../../modules/zsh.nix
  ];

  programs.ssh.matchBlocks = {
    naspi = {
      hostname = "192.168.0.25";
      user = "root";
      # identityFile = "~/.ssh/id_ed25519";
    };
    nas = {
      hostname = "192.168.0.30";
      user = "root";
      # identityFile = "~/.ssh/id_ed25519";
    };
  };

  programs.zsh.initContent = ''
    if [[ -z "$TMUX" && $- == *i* ]]; then
      cd ~
      tmux attach 2>/dev/null && exit
      tmux new-session -d -s main -n boot
      tmux new-window -n core
      tmux new-window -n heap
      tmux split-window -v
      tmux select-pane -U
      tmux new-window -n stack
      tmux split-window -v
      tmux select-pane -U
      tmux new-window -n cache
      tmux new-window -n macos
      tmux send-keys -t macos mac Enter
      sleep 0.5
      tmux send-keys -t macos "cd && clear" Enter
      tmux select-window -t 0
      exec tmux attach
    fi
  '';

  home.sessionVariables.HOST_ICON = "󰏖";

  home.activation.copyWezterm = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
    MAC_USER=$(ls /mnt/mac/Users | grep -v Shared | head -n 1)
    install -D "${config.xdg.configHome}/wezterm/wezterm.lua" "/mnt/mac/Users/$MAC_USER/.config/wezterm/wezterm.lua"
  '';
}
