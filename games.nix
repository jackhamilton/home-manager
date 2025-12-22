{ config, pkgs, pkgs-unstable, lib, ... }:
{
    home.packages = (with pkgs; [
        runelite
        lutris
    ])
    ++ (with pkgs-unstable; []);
}
