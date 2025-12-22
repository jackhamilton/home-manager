{ config, pkgs, pkgs-unstable, lib, ... }:
{
    # services.mako = {
    #     enable = true;
    #     settings = {
    #         default-timeout = 5;
    #         border-radius = 16;
    #     };
    # };

    # catppuccin.mako.enable = true;
    services.udiskie = {
        enable = true;
        automount = true;
        notify = true;
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
            brightnessctl
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
            swaynotificationcenter
            firefox
            udiskie
            grimblast
            wl-clipboard
            ])
            ++ (with pkgs-unstable; [
                    mergiraf
                papirus-icon-theme
# hyprland
# hyprsunset
# xdg-desktop-portal-hyprland
            ]);
}
