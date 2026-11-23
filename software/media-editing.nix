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
      kicad
      davinci-resolve
      krita
      inkscape
      obs-studio
      audacity
      handbrake
    ]);

}
