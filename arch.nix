{ config, pkgs, pkgs-unstable, lib, ... }:
{
    home.packages = (with pkgs; [
        adw-gtk3
        gradience
        solarc-gtk-theme
        autotiling
        bazelisk
        bitwarden-menu
        cifs-utils
        samba4Full
        clipman
        dconf-editor
        dhcpcd
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
        grub2
        gparted
        grim
        gutenprint
        inetutils
        lutris
        lxappearance
        mako
        mangohud
        mimeo
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
        wireplumber
        protonvpn-gui
        protonvpn-cli
        qmk
        qemu
        rofi
        ruby
        slurp
        sway
        swayidle
        swaybg
        swayimg
        waybar
        wezterm
        wlsunset
        wofi
        xdg-desktop-portal
        xdg-desktop-portal-wlr
        hyprland
        hyprsunset
        xdg-desktop-portal-hyprland
        hyprpolkitagent
        qt5-wayland
        qt6-wayland
        xwaylandvideobridge
        xdg-terminal-exec
    ])

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
