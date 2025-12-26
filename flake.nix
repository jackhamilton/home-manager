{
  description = "Home Manager configs";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # catppuccin.url = "github:catppuccin/nix";
  };

  outputs =
    inputs@{
      nixpkgs,
      nixpkgs-unstable,
      rust-overlay,
      home-manager,
      ...
    }:
    let
      # small helper to build a Home Manager config for a given system/identity
      mkHome =
        {
          system,
          username,
          homeDirectory,
          extra-modules ? [ ],
        }:
        let
          pkgs-unstable = nixpkgs-unstable.legacyPackages.${system};
        in
        home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            inherit system;
            overlays = [
              rust-overlay.overlays.default
            ];
          };
          # your base module(s) + host-specific tweaks
          modules = [
            ./home.nix
          ]
          ++ extra-modules;

          extraSpecialArgs = {
            inherit username homeDirectory pkgs-unstable;
          };
        };
    in
    {
      # Name each target explicitly. Pick names you’ll remember at the CLI.
      homeConfigurations = {
        "darwin" = mkHome {
          system = "aarch64-darwin";
          username = "jackhamilton";
          homeDirectory = "/Users/jackhamilton";
          extra-modules = [
            ./git.nix
            ./expanded-core.nix
            ./fonts.nix
            ./cargo.nix
          ];
        };

        "darwin-intel" = mkHome {
          system = "x86_64-darwin";
          username = "jackhamilton";
          homeDirectory = "/Users/jackhamilton";
          extra-modules = [
            ./git.nix
            ./expanded-core.nix
            ./fonts.nix
            ./cargo.nix
          ];
        };

        "arch" = mkHome {
          system = "x86_64-linux";
          username = "jack";
          homeDirectory = "/home/jack";
          extra-modules = [
            ./arch.nix
            ./software.nix
            ./repos.nix
            ./systemd.nix
            ./git.nix
            ./theme.nix
            ./expanded-core.nix
            ./fonts.nix
            ./cargo.nix
          ];
        };

        "nixos" = mkHome {
          system = "x86_64-linux";
          username = "jack";
          homeDirectory = "/home/jack";
          extra-modules = [
            ./nixos.nix
            ./software.nix
            ./services.nix
            ./systemd.nix
            ./games.nix
            ./linux.nix
            ./git.nix
            ./theme.nix
            ./expanded-core.nix
            ./fonts.nix
            ./cargo.nix
          ];
        };

        "server" = mkHome {
          system = "x86_64-linux";
          username = "root";
          homeDirectory = "/root/";
          extra-modules = [
            ./git.nix
          ];
        };
      };
    };
}
