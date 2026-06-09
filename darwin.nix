{ config, pkgs, pkgs-unstable, lib, ... }:

let
in {
    home.packages = with pkgs; [
        aerospace
    ];
}
