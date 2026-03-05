{
  config,
  lib,
  pkgs,
  ...
}:
let
  homeDir = config.home.homeDirectory;
  gitlab = "git@gitlab.protontech.ch";
  workEmail = "radu.tomuleasa@external.proton.ch";

  workRepos = [
    {
      path = "proton/clients/monorepo";
      branch = "main";
    }
  ];

  cloneRepo =
    { path, branch }:
    let
      dir = baseNameOf path;
    in
    ''
      if [ ! -d "${homeDir}/${dir}" ]; then
        git clone --branch ${branch} ${gitlab}:${path}.git "${homeDir}/${dir}"
        git -C "${homeDir}/${dir}" config --local user.email "${workEmail}"
      fi
    '';
in
{
  home = {
    packages = with pkgs; [
      # work tooling
      devenv
      direnv
      just

      # mail
      go
      llvmPackages.libclang

      docker
    ];

    sessionVariables = {
      GOPATH = "${config.home.homeDirectory}/.local/share/go";
      LIBCLANG_PATH = "${pkgs.llvmPackages.libclang.lib}/lib";
    };

    activation.cloneWorkRepos = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
      export PATH="${
        lib.makeBinPath [
          pkgs.git
          pkgs.openssh
        ]
      }:$PATH"
      ${lib.concatStringsSep "\n" (map cloneRepo workRepos)}
    '';
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };
}
