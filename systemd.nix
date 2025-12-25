{
  config,
  pkgs,
  pkgs-unstable,
  lib,
  ...
}:
{
  systemd.user.targets.hyprland-session = {
    Unit = {
      Description = "Hyprland session target";
      Wants = [ "xdg-desktop-autostart.target" ];
    };
  };
}
