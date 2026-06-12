{ config, pkgs, pkgs-unstable, lib, ... }:

let
  swiftassist-rs = pkgs.rustPlatform.buildRustPackage {
    pname = "sass";
    version = "0.4.1";
    src = pkgs.fetchFromGitHub {
      owner = "jackhamilton";
      repo = "sass-rs";
      rev = "d6429acd7bb145abf4e964a7eb208d1c8ba1eb11";
      hash = "sha256-D8zCjufA/ernGvnj0Bq8EACgns4RELZIwwECGwvLMuI=";
    };
    cargoHash = "sha256-ECotj/kn+mvNKfxcn/aPreRl2EAWaXiRHG2X+Pig7SQ=";
    nativeBuildInputs = [ pkgs.git ];
  };
in {
    home.packages = (with pkgs; [
        wezterm
        swiftlint
        swiftassist-rs
    ])
    ++ (with pkgs-unstable; [
        neovim
    ]);
}
