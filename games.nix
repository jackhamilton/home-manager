{ config, pkgs, pkgs-unstable, lib, ... }:
{
    home.packages = (with pkgs; [
        runelite
    ])
    ++ (with pkgs-unstable; []);
}
