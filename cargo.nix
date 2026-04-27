
{ config, pkgs, pkgs-unstable, lib, ... }:

let
themester = pkgs.rustPlatform.buildRustPackage  {
    pname = "themester";
    version = "0.3.4";

    src = pkgs.fetchFromGitHub {
      owner = "jackhamilton";
      repo = "themester.zsh";
      rev = "4245259408bbaa6c16543444c095d4d493a2ea6a";
      hash = "sha256-P/tI+ZvdKY9EX2FLDjXgFpoCd32r/zeV3GBT6D528Uw=";
    };

    cargoHash = "sha256-bbcdBEHBPErcgq1qIlhofiB19LIYqVeDq+0JrDv71t0=";
  };
in {
    home.packages = [
        themester
    ];
}
