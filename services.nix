
{ config, pkgs, pkgs-unstable, lib, ... }:
{
    systemd.user.services.hyprland-xdg-autostart = {
        Unit = {
            Description = "Autostart XDG autostart apps";
            BindsTo = "graphical-session.target";
            Wants = "xdg-desktop-autostart.target";
        };
    };
}
