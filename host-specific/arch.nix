{ config, pkgs, pkgs-unstable, lib, ... }:
{
    targets.genericLinux.enable = true;

    home.packages = (with pkgs; [
        adw-gtk3
        clipman
        dconf-editor
        docker
        efibootmgr
        grub2
        gparted
        gutenprint
        os-prober
        papirus-icon-theme
        paru
    ]);
}
