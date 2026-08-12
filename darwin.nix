{ config, pkgs, pkgs-unstable, lib, ... }:

let
  swiftassist-rs = pkgs.rustPlatform.buildRustPackage {
    pname = "sass";
    version = "0.4.1";
    src = pkgs.fetchFromGitHub {
      owner = "jackhamilton";
      repo = "sass-rs";
      rev = "be2dadd";
      hash = "sha256-mbkFa3HAzQXAP2j51A9NtWQKvJ22JocHPqzK+05gfWI=";
    };
    cargoHash = "sha256-ECotj/kn+mvNKfxcn/aPreRl2EAWaXiRHG2X+Pig7SQ=";
    nativeBuildInputs = [ pkgs.git ];
  };
in {
    home.packages = (with pkgs; [
        wezterm
        swiftlint
        swiftformat
        swiftassist-rs
    ]);
}
