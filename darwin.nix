{ config, pkgs, pkgs-unstable, lib, ... }:

let
  swiftassist-rs = pkgs.rustPlatform.buildRustPackage {
    pname = "sass";
    version = "0.4.0";
    src = pkgs.fetchFromGitHub {
      owner = "jackhamilton";
      repo = "sass-rs";
      rev = "43f0d4aede5b76afefb20cf9ff6c2e696500b4de";
      hash = "sha256-QxnZ66FQgjt4XQaQpUQL9HlnLesCpY5P1QTrDzGGyD8=";
    };
    cargoHash = "sha256-FJiWGcFcNxROAvZS3UcEUb//WwjAtpq7ByNFuW2u6WE=";
    nativeBuildInputs = [ pkgs.git ];
  };
in {
    home.packages = with pkgs; [
        neovim
        wezterm
        swiftlint
        swiftassist-rs
    ];
}
