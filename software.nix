{ config, pkgs, pkgs-unstable, lib, ... }:
{
    home.packages = (with pkgs; [
        cockatrice
        chromium
        nautilus
        steam
        yt-dlp
        ytarchive
        vlc
        kicad
        davinci-resolve
        calibre
        obs-studio
        thunderbird
        audacity
        libreoffice
        vesktop
        ripcord
    ])
    ++ (with pkgs-unstable; [
        godot
    ]);

    xdg.enable = true;
    xdg.desktopEntries = {
        vesktop = {
            name = "Vesktop";
            genericName = "Discord client";
            exec = "${pkgs.vesktop}/bin/vesktop %U";
            terminal = false;
            categories = [ "Application" ];
            settings = {
                StartupNotify = "true";
                StartupWMClass = "Vesktop";
                Type = "Application";
            };
        };
    };
}
