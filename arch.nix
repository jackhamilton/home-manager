{ config, pkgs, pkgs-unstable, lib, ... }:
{
    home.packages = (with pkgs; [
        adw-gtk3
        gradience
        solarc-gtk-theme
        audacity
        autotiling
        bazelisk
        thunderbird
        bitwarden-menu
        calibre
        obs-studio
        cifs-utils
        samba4Full
        clipman
        cockatrice
        davinci-resolve
        dconf-editor
        dhcpcd
        vesktop
        dmenu
        docker
        dpkg
        dunst
        efibootmgr
        evince
        file-roller
        flameshot
        fuzzel
        gamescope
        gammastep
        chromium
        grub2
        gparted
        grim
        gutenprint
        inetutils
        kicad
        lutris
        lxappearance
        mako
        mangohud
        mimeo
        nautilus
        neomutt
        networkmanager
        networkmanagerapplet
        nitrogen
        nushell
        nwg-bar
        nwg-displays
        nwg-wrapper
        orca
        os-prober
        pamixer
        papirus-icon-theme
        paru
        pavucontrol
        pipewire
        protonvpn-gui
        protonvpn-cli
        qmk
        qemu
        rbenv
        ripcord
        rofi
        rofi
        rpi-imager
        ruby
        slurp
        steam
        sway
        swayidle
        swaybg
        swayimg
        vlc
        waybar
        wezterm
        wlsunset
        wofi
        yt-dlp
        ytarchive
    ])
    ++ (with pkgs-unstable; [
        godot
    ]);

    xdg.enable = true;
    xdg.desktopEntries = {
        vesktop = {
            name = "Vesktop";
            exec = "${pkgs.vesktop}/bin/vesktop %U";
            terminal = false;
            settings = {
                StartupNotify = "true";
                StartupWMClass = "Vesktop";
                Type = "Application";
            };
        };
    };
}
