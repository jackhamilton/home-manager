{ config, pkgs, pkgs-unstable, lib, ... }:
{
    home.packages = (with pkgs; [
        runelite
        lutris
        piper
    ])
    ++ (with pkgs-unstable; []);

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
}
