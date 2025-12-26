{ config, pkgs, pkgs-unstable, lib, ... }:
{
    home.packages = (with pkgs; [
        neovim
    ]);
}
