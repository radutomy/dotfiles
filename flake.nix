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
        { system }:
        nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            /etc/nixos/configuration.nix
            ./hosts/system.nix
          ];
        };

      mkHome =
        {
          system,
          host,
          username ? "root",
        }:
        home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
          extraSpecialArgs = {
            inherit username;
            pkgs-unstable = import nixpkgs-unstable {
              inherit system;
              config.allowUnfree = true;
            };
          };
          modules = [
            ./home.nix
            ./hosts/${host}/default.nix
          ];
        };
      forSystems = nixpkgs.lib.genAttrs [ "aarch64-linux" "x86_64-linux" ];
    in
    {
      apps = forSystems (system: {
        default =
          let
            pkgs = import nixpkgs { inherit system; };
          in
          {
            type = "app";
            program = nixpkgs.lib.getExe (pkgs.writeShellApplication {
              name = "bootstrap";
              runtimeInputs = with pkgs; [ age git openssh ];
              text = builtins.readFile ./bootstrap.sh;
            });
          };
      });

      nixosConfigurations = {
        nix = mkSystem { system = "aarch64-linux"; };
        nas = mkSystem { system = "x86_64-linux"; };
        wsl = mkSystem { system = "x86_64-linux"; };
      };

      homeConfigurations = {
        "root@nas" = mkHome {
          system = "x86_64-linux";
          host = "nas";
        };
        # OrbStack VM (aarch64)
        "root@nix" = mkHome {
          system = "aarch64-linux";
          host = "vm";
        };
        # WSL (x86_64) — "wsl" is a placeholder hostname
        "root@wsl" = mkHome {
          system = "x86_64-linux";
          host = "vm";
        };
      };
    };
}
