{ config, pkgs, pkgs-unstable, lib, ... }:
{
    targets.genericLinux.enable = true;

    home.packages = (with pkgs; [
        adw-gtk3
        gradience
        solarc-gtk-theme
        autotiling
        bazelisk
        bitwarden-menu
        bitwarden-cli
        chezmoi
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
        wlsunset
        wofi
        xdg-desktop-portal
        xdg-desktop-portal-wlr
        hyprpolkitagent
        kdePackages.xwaylandvideobridge
        xdg-terminal-exec
    ])
    ++ (with pkgs-unstable; [
        mergiraf
        # hyprland
        # hyprsunset
        # xdg-desktop-portal-hyprland
    ]);
}
