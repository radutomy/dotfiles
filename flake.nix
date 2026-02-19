{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    claude-code-nix.url = "github:sadjow/claude-code-nix";
    codex-cli-nix.url = "github:sadjow/codex-cli-nix";
  };

  outputs =
    {
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      claude-code-nix,
      codex-cli-nix,
      ...
    }:
    let
      hosts = {
        orb = "aarch64-linux";
        wsl = "x86_64-linux";
        nas = "x86_64-linux";
      };

      mkSystem =
        host: system:
        nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            /etc/nixos/configuration.nix
            ./hosts/system.nix
            home-manager.nixosModules.home-manager
            {
              networking.hostName = nixpkgs.lib.mkForce host;
              nixpkgs.config.allowUnfree = true;
              nixpkgs.overlays = [
                claude-code-nix.overlays.default
                codex-cli-nix.overlays.default
              ];
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = false;
                extraSpecialArgs = {
                  username = "root";
                  pkgs-unstable = import nixpkgs-unstable {
                    inherit system;
                    config.allowUnfree = true;
                  };
                };
                users.root = {
                  imports = [
                    ./home.nix
                    ./hosts/${host}/default.nix
                  ];
                };
              };
            }
          ];
        };

      forSystems = nixpkgs.lib.genAttrs [
        "aarch64-linux"
        "x86_64-linux"
      ];
    in
    {
      nixosConfigurations = nixpkgs.lib.mapAttrs mkSystem hosts;

      apps = forSystems (
        system:
        let
          pkgs = import nixpkgs { inherit system; };
          mkApp = host: {
            type = "app";
            program = nixpkgs.lib.getExe (
              pkgs.writeShellApplication {
                name = "bootstrap-${host}";
                runtimeInputs = with pkgs; [
                  age
                  git
                  openssh
                ];
                text = ''
                  export NIXOS_HOST="${host}"
                  ${builtins.readFile ./bootstrap.sh}
                '';
              }
            );
          };
        in
        nixpkgs.lib.mapAttrs (host: _: mkApp host) hosts
      );
    };
}
