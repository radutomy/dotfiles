{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      ...
    }:
    let
      mkSystem =
        {
          system,
          host,
          username ? "root",
        }:
        nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            /etc/nixos/configuration.nix
            ./hosts/system.nix
            home-manager.nixosModules.home-manager
            {
              nixpkgs.config.allowUnfree = true;
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = {
                inherit username;
                pkgs-unstable = import nixpkgs-unstable {
                  inherit system;
                  config.allowUnfree = true;
                };
              };
              home-manager.users.${username} = {
                imports = [
                  ./home.nix
                  ./hosts/${host}/default.nix
                ];
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
      apps = forSystems (system: {
        default =
          let
            pkgs = import nixpkgs { inherit system; };
          in
          {
            type = "app";
            program = nixpkgs.lib.getExe (
              pkgs.writeShellApplication {
                name = "bootstrap";
                runtimeInputs = with pkgs; [
                  age
                  git
                  openssh
                ];
                text = builtins.readFile ./bootstrap.sh;
              }
            );
          };
      });

      nixosConfigurations = {
        nix = mkSystem {
          system = "aarch64-linux";
          host = "vm";
        };
        nas = mkSystem {
          system = "x86_64-linux";
          host = "nas";
        };
        wsl = mkSystem {
          system = "x86_64-linux";
          host = "vm";
        };
      };
    };
}
