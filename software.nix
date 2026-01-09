{
  config,
  pkgs,
  pkgs-unstable,
  lib,
  ...
}:
{
  home.packages =
    (with pkgs; [
      cockatrice
      chromium
      nautilus
      # steam
      yt-dlp
      ytarchive
      vlc
      kicad
      davinci-resolve
      calibre
      obs-studio
      thunderbird
      audacity
      libreoffice
      vesktop
      ripcord
      handbrake
      krita
      inkscape
      mpv
    ])
    ++ (with pkgs-unstable; [
      godot
    ])
    ++ [
      (pkgs.symlinkJoin {
        name = "zen-browser";
        paths = [ inputs.zen-browser.packages.${pkgs.system}.twilight ];
        buildInputs = [ pkgs.makeWrapper ];
        postBuild = ''
          wrapProgram $out/bin/zen \
            --prefix LD_LIBRARY_PATH : "${pkgs.lib.makeLibraryPath [
              pkgs.ffmpeg-full
              pkgs.mediastreamer
              pkgs.openh264
            ]}"
        '';
      })
    ];

  programs.anki = {
    enable = true;
    sync.username = "jmhamilton@protonmail.com";
    addons = [
      pkgs.ankiAddons.anki-connect
    ];
  };

  programs.zen-browser.enable = true;

  xdg.enable = true;
}
