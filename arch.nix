{ config, pkgs, pkgs-unstable, lib, ... }:

let
in {
    home.packages = with pkgs; [
        adw-gtk3
        gradience
        solarc-gtk-theme
        audacity
        autotiling
    ];
}
