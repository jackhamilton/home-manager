{ config, pkgs, pkgs-unstable, lib, ... }:
{
    home.packages = with pkgs; [
        android-studio-full
        burpsuite
    ];

    nixpkgs.config.android_sdk.accept_license = true;
}
