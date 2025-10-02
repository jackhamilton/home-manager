
{ config, pkgs, pkgs-unstable, lib, ... }:

let
rustPlatform = pkgs.makeRustPlatform {
cargo = pkgs.rust-bin.beta.latest.default;
rustc = pkgs.rust-bin.beta.latest.default;
};
themester = rustPlatform.buildRustPackage rec {
    pname = "themester";
    version = "0.3.1";

    src = pkgs.fetchFromGitHub {
      owner = "jackhamilton";
      repo = "themester.zsh";
      rev = "7d0a31b434c9b6bdea9df330a1f117cfb2968ff3";
      hash = "sha256-dzC7Q9j6eZpaj1+ZPoQ+NzO3eCsM6JxMAup3gKqIQ+I=";
    };

    cargoHash = "sha256-aY5Zsq2cF48+DoLJog1L5Yu0SXlA+XvvRwtVVUhWeH8=";
  };
in {
    home.packages = [
        themester
    ];
}
