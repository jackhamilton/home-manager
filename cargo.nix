
{ config, pkgs, pkgs-unstable, lib, ... }:

let
themester = pkgs.rustPlatform.buildRustPackage  {
    pname = "themester";
    version = "0.4.0";

    src = pkgs.fetchFromGitHub {
      owner = "jackhamilton";
      repo = "themester.zsh";
      rev = "aeb411c8a088eea946601cc589e566fe8ccf4f79";
      hash = "sha256-2LqYdoipUwQQTltgv2l3oFYJHhKhzSlhV+beuUpszDM=";
    };

    cargoHash = "sha256-QxWa0Qo3uQoPc86gCj2X2+n/rmUNIPxc6SbfcHjLsIw=";
  };
in {
    home.packages = [
        themester
    ];
}
