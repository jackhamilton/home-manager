{ config, pkgs, pkgs-unstable, lib, ... }:
{
    services.udiskie = {
        enable = true;
        settings = {
            # workaround for
            # https://github.com/nix-community/home-manager/issues/632
            program_options = {
                # replace with your favorite file manager
                file_manager = "${pkgs.nautilus}/bin/nautilus";
            };
        };
    };

    home.packages = (with pkgs; [
        gradience
        nautilus
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
        dpkg
        dunst
        evince
        file-roller
        flameshot
        fuzzel
        gamescope
        gammastep
        grim
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
        waybar
        wlsunset
        wofi
        xdg-desktop-portal
        xdg-desktop-portal-wlr
        hyprpolkitagent
        kdePackages.xwaylandvideobridge
        xdg-terminal-exec
        hyprsunset
        firefox
    ])
    ++ (with pkgs-unstable; [
        mergiraf
        # hyprland
        # hyprsunset
        # xdg-desktop-portal-hyprland
    ]);
}
