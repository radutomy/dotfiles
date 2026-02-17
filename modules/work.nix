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
    {
      path = "chat/chat-client";
      branch = "develop";
    }
    {
      path = "rust/proton-rust";
      branch = "master";
    }
  ];

  # for chat-client - bind to a specific version
  wasm-bindgen-cli = pkgs.rustPlatform.buildRustPackage {
    pname = "wasm-bindgen-cli";
    version = "0.2.106";
    src = pkgs.fetchCrate {
      pname = "wasm-bindgen-cli";
      version = "0.2.106";
      hash = "sha256-M6WuGl7EruNopHZbqBpucu4RWz44/MSdv6f0zkYw+44=";
    };
    cargoHash = "sha256-ElDatyOwdKwHg3bNH/1pcxKI7LXkhsotlDPQjiLHBwA=";
    nativeBuildInputs = [ pkgs.pkg-config ];
    buildInputs = [ pkgs.openssl ];
  };

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
      # proton-rust
      go
      llvmPackages.libclang

      # chat-client
      pnpm
      wasm-pack
      wasm-bindgen-cli
      lld
      docker
    ];

    sessionVariables = {
      GOPATH = "${config.home.homeDirectory}/.local/share/go";
      LIBCLANG_PATH = "${pkgs.llvmPackages.libclang.lib}/lib";
      BINDGEN_EXTRA_CLANG_ARGS = "-isystem ${pkgs.glibc.dev}/include";
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
}
