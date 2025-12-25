{ config, lib, pkgs, pkgs-unstable, ... }:
{
    services.tailscale = {
        enable = true;
        useRoutingFeatures = "client";
    };
}
