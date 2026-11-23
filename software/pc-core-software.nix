{
  config,
  pkgs,
  pkgs-unstable,
  lib,
  inputs,
  ...
}:
let
  isDarwin = pkgs.stdenv.hostPlatform.isDarwin or pkgs.stdenv.isDarwin;
in
{
  home.packages =
    (with pkgs; [
      libreoffice
      discord
    ])
    ++ (with pkgs-unstable; [ ])
    ++ (if !isDarwin then (with pkgs; [
      vlc
      mpv
      nautilus
      thunderbird
      calibre
    ]) else [] );

  programs.anki = {
    enable = true;
    sync.username = "jmhamilton@protonmail.com";
    addons = [
      pkgs.ankiAddons.anki-connect
    ];
  };

}
