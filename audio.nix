{ config, pkgs, pkgs-unstable, lib, ... }:

{
    services.easyeffects.enable = true;

    # required by easyeffects
    dconf.enable = true;
}
