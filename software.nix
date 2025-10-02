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

    xdg.desktopEntries = {
        obs-studio = {
            name = "OBS";
            genericName = "Streaming client";
            exec = "${pkgs.obs}/bin/obs %U";
            terminal = false;
            categories = [ "Application" ];
            settings = {
                StartupNotify = "true";
                StartupWMClass = "OBS";
                Type = "Application";
            };
        };
    };


    xdg.desktopEntries = {
        steam = {
            name = "Steam";
            genericName = "Game library";
            exec = "${pkgs.steam}/bin/steam %U";
            terminal = false;
            categories = [ "Application" ];
            settings = {
                StartupNotify = "true";
                StartupWMClass = "Steam";
                Type = "Application";
            };
        };
    };

    xdg.desktopEntries = {
        kicad = {
            name = "Kicad";
            genericName = "Circuit designer";
            exec = "${pkgs.kicad}/bin/kicad %U";
            terminal = false;
            categories = [ "Application" ];
            settings = {
                StartupNotify = "true";
                StartupWMClass = "Kicad";
                Type = "Application";
            };
        };
    };

    xdg.desktopEntries = {
        davinci-resolve = {
            name = "DaVinci Resolve";
            genericName = "Video editor";
            exec = "${pkgs.davinci-resolve}/bin/davinci-resolve %U";
            terminal = false;
            categories = [ "Application" ];
            settings = {
                StartupNotify = "true";
                StartupWMClass = "DaVinciResolve";
                Type = "Application";
            };
        };
    };

    xdg.desktopEntries = {
        thunderbird = {
            name = "Thunderbird";
            genericName = "Mail client";
            exec = "${pkgs.thunderbird}/bin/thunderbird %U";
            terminal = false;
            categories = [ "Application" ];
            settings = {
                StartupNotify = "true";
                StartupWMClass = "Thunderbird";
                Type = "Application";
            };
        };
    };

    xdg.desktopEntries = {
        godot = {
            name = "Godot";
            genericName = "Game development IDE";
            exec = "${pkgs.godot}/bin/godot %U";
            terminal = false;
            categories = [ "Application" ];
            settings = {
                StartupNotify = "true";
                StartupWMClass = "Godot";
                Type = "Application";
            };
        };
    };
}
