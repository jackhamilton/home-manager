
{ config, pkgs, pkgs-unstable, lib, ... }:

let
themester = pkgs.rustPlatform.buildRustPackage rec {
    pname = "themester";
    version = "0.3.0";

    src = pkgs.fetchFromGitHub {
      owner = "jackhamilton";
      repo = "themester.zsh";
      rev = version;
      hash = "sha256-1WWn0psbr2FSYGUGElUpf9d28QwdfsTCY4z5nl7inB0=";
    };

    cargoHash = "sha256-lUQwwGJLHLI9bfJiLUUE8j1svBAgbvr+8hKB/bRzwNA=";
  };
in {
    home.packages = [
        themester
    ];
