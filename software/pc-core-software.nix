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
      vlc
      nautilus
      calibre
      thunderbird
      libreoffice
      discord
      mpv
    ])
    ++ (with pkgs-unstable; [ ]);

  programs.anki = {
    enable = true;
    sync.username = "jmhamilton@protonmail.com";
    addons = [
      pkgs.ankiAddons.anki-connect
    ];
  };

}
