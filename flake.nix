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
            ./fonts.nix
            ./cargo.nix
            # catppuccin.homeModules.catppuccin
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
        };

        "darwin-intel" = mkHome {
          system = "x86_64-darwin";
          username = "jackhamilton";
          homeDirectory = "/Users/jackhamilton";
        };

        "arch" = mkHome {
          system = "x86_64-linux";
          username = "jack";
          homeDirectory = "/home/jack";
          extra-modules = [
            ./arch.nix
            ./software.nix
            ./repos.nix
            # ./ide.nix
            ./services.nix
            # ./drivers.nix
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
            ./games.nix
            ./linux.nix
          ];
        };
      };
    };
}
