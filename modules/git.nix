{ config, ... }:
{
  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      navigate = true;
      line-numbers = true;
    };
  };

  programs.lazygit.settings = {
    git.pagers = [
      {
        colorArg = "always";
        pager = "delta --dark --paging=never --line-numbers";
      }
    ];
  };

  programs.git = {
    enable = true;
    signing = {
      key = "${config.home.homeDirectory}/.ssh/id_ed25519";
      signByDefault = true;
    };
    settings = {
      user = {
        name = "Radu T";
        email = "radu@rtom.dev";
      };
      init.defaultBranch = "main";
      merge.conflictstyle = "diff3";
      diff.colorMoved = "default";
      gpg.format = "ssh";
      tag.gpgsign = true;
    };
  };
}
