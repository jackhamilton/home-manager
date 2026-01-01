{
  config,
  lib,
  pkgs,
  pkgs-unstable,
  catppuccin,
  ...
}:
{
  home.packages = with pkgs; [
    numix-icon-theme-circle
    # catppuccin-qt5ct
    # catppuccin-gtk
  ];

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };

  catppuccin = {
    enable = true;
    accent = "flamingo";
    nvim.enable = false;
    starship.enable = false;
  };

  gtk = {
    enable = true;
    iconTheme = lib.mkForce {
      name = "Numix-Circle";
      package = pkgs.numix-icon-theme-circle;
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
  };

  qt = {
    enable = true;
    style.name = "kvantum";
    platformTheme.name = "kvantum";
  };

}
