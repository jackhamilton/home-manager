{ config, pkgs, pkgs-unstable, lib, ... }:
{
    home.packages = (with pkgs; [
        cockatrice
        chromium
        nautilus
        # steam
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
        handbrake
        krita
        inkscape
        mpv
    ])
    ++ (with pkgs-unstable; [
        godot
    ]);

    programs.anki = {
        enable = true;
        sync.username = "jmhamilton@protonmail.com";
    };

    xdg.enable = true;
}
