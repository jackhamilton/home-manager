{
  config,
  pkgs,
  pkgs-unstable,
  lib,
  inputs,
  ...
}:
{
  home.packages =
    (with pkgs; [
      cockatrice
      lutris
      piper
    ])
    ++ [ inputs.jagex-launcher.packages.${pkgs.system}.default ]
    ++ (with pkgs-unstable; [ ]);

  xdg.desktopEntries.awakened-poe-trade = {
    name = "Awakened POE Trade";
    genericName = "POE Trade";
    exec = "appimage-run /home/jack/Games/awakened-poe-trade.AppImage --enable-features=UseOzonePlatform --ozone-platform=x11";
    terminal = false;
  };

  xdg.desktopEntries.path-of-building = {
    name = "Path of Building";
    genericName = "POB";
    exec = "flatpak run community.pathofbuilding.PathOfBuilding poe1";
    terminal = false;
  };

  # xdg.desktopEntries.jagex-launcher = {
  #   name = "Jagex Launcher";
  #   genericName = "Jagex";
  #   exec = "flatpak run com.jagexlauncher.JagexLauncher";
  #   terminal = false;
  # };
}
