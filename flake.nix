{
  description = "Home Manager configs";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix.url = "github:ryantm/agenix";
    direnv-instant.url = "github:Mic92/direnv-instant";
    catppuccin.url = "github:catppuccin/nix/release-26.05";
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs = {
        # IMPORTANT: we're using "libgbm" and is only available in unstable so ensure
        # to have it up-to-date or simply don't specify the nixpkgs input
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };
    jagex-launcher = {
      url = "github:kurtmorris/jagex-launcher-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      nixpkgs,
      nixpkgs-unstable,
      rust-overlay,
      home-manager,
      agenix,
      catppuccin,
      direnv-instant,
      ...
    }:
    let
      pc-modules = [
        ./host-specific/pc-core-terminal.nix
        ./software/browser.nix
        ./software/cargo-packages.nix
        ./theme/fonts.nix
        ./repos.nix
        inputs.zen-browser.homeModules.twilight
      ];
      linux-pc-modules = [
        ./host-specific/linux.nix
        ./host-specific/systemd.nix
        ./software/pc-core-software.nix
        ./theme/linux-theme.nix
        ./drivers.nix
        ./audio.nix
      ];

      # small helper to build a Home Manager config for a given system/identity
      mkHome =
        {
          system,
          username,
          homeDirectory,
          useColemak ? false,
          extra-modules ? [ ],
        }:
        let
          pkgs-unstable = import nixpkgs-unstable {
            inherit system;
          };
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
            ./software/version-control.nix
            ./software/nvim.nix
            catppuccin.homeModules.catppuccin
            agenix.homeManagerModules.default
            direnv-instant.homeModules.direnv-instant
          ]
          ++ extra-modules;

          extraSpecialArgs = {
            inherit
              pkgs-unstable
              username
              homeDirectory
              inputs
              useColemak
              ;
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
            ./software/development.nix
            ./host-specific/darwin.nix
          ]
          ++ pc-modules;
        };

        "darwin-intel" = mkHome {
          system = "x86_64-darwin";
          username = "jackhamilton";
          homeDirectory = "/Users/jackhamilton";
          extra-modules = [
            ./host-specific/darwin.nix
          ] ++ pc-modules;
        };

        "arch" = mkHome {
          system = "x86_64-linux";
          username = "jack";
          homeDirectory = "/home/jack";
          extra-modules = [
            ./host-specific/arch.nix
          ]
          ++ pc-modules ++ linux-pc-modules;
        };

        "nixos-laptop" = mkHome {
          system = "x86_64-linux";
          username = "jack";
          homeDirectory = "/home/jack";
          extra-modules = [
            ./software/games.nix
            ./software/development.nix
            ./software/hacking.nix
            { useColemak = true; }
          ]
          ++ pc-modules ++ linux-pc-modules;
        };

        "nixos-desktop" = mkHome {
          system = "x86_64-linux";
          username = "jack";
          homeDirectory = "/home/jack";
          extra-modules = [
            ./software/games.nix
            ./software/development.nix
            ./software/hacking.nix
            ./software/media-editing.nix
          ]
          ++ pc-modules ++ linux-pc-modules;
        };

        "server" = mkHome {
          system = "x86_64-linux";
          username = "root";
          homeDirectory = "/root/";
          extra-modules = [ ];
        };
      };
    };
}
