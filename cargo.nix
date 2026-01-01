
{ config, pkgs, pkgs-unstable, lib, ... }:

let
themester = pkgs.rustPlatform.buildRustPackage  {
    pname = "themester";
    version = "0.3.3";

    src = pkgs.fetchFromGitHub {
      owner = "jackhamilton";
      repo = "themester.zsh";
      rev = "f24fe8d34b6d2271b9c4741403479411840a8158";
      hash = "sha256-N/0yA+3nNCCGKoktfCoFFEatGZqTdYekkPVAVXSvHV0=";
    };

    cargoHash = "sha256-aPxvFwJ2RZVO/usDPlOPfH5RfZi0h5rNhzTpA/Y3m0w=";
  };
in {
    home.packages = [
        themester
    ];
}
