
{ config, pkgs, pkgs-unstable, lib, ... }:

let
rustPlatform = pkgs.makeRustPlatform {
cargo = pkgs.rust-bin.beta.latest.default;
rustc = pkgs.rust-bin.beta.latest.default;
};
themester = rustPlatform.buildRustPackage rec {
    pname = "themester";
    version = "0.3.0";

    src = pkgs.fetchFromGitHub {
      owner = "jackhamilton";
      repo = "themester.zsh";
      rev = "29019c5b5727d33d808198cae56b054888cac6ab";
      hash = "sha256-1WWn0psbr2FSYGUGElUpf9d28QwdfsTCY4z5nl7inB0=";
    };

    cargoHash = "sha256-r3+0h9k+Nlq2XFEZLveo3cia+WylTw1ecTszvxeTxQI=";
  };
in {
    home.packages = [
        themester
    ];
}
