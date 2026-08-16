{
  config,
  pkgs,
  pkgs-unstable,
  lib,
  inputs,
  ...
}:
let
  basePackage = inputs.zen-browser.packages.${pkgs.system}.twilight;

  zenTwilight = let
    wrapped = pkgs.runCommand "zen-twilight-wrapped" {
      buildInputs = [ pkgs.makeWrapper ];
      passthru = basePackage.passthru or { };
    } ''
      mkdir -p $out
      cp -r ${basePackage}/* $out/
      chmod -R +w $out
      wrapProgram "$out/bin/zen-twilight" \
        --prefix LD_LIBRARY_PATH : "${pkgs.lib.makeLibraryPath [
          pkgs.ffmpeg-full
          pkgs.linphonePackages.mediastreamer2
          pkgs.openh264
        ]}"
    '';
  in wrapped.overrideAttrs (old: {
    passthru = (old.passthru or { }) // {
      override = args: zenTwilight;
    };
  });
in {
  # discord
  nixpkgs.config.allowUnfree = true;

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
      discord
      handbrake
      krita
      inkscape
      mpv
    ])
    ++ (with pkgs-unstable; [
      godot
    ]);

  programs.anki = {
    enable = true;
    sync.username = "jmhamilton@protonmail.com";
    addons = [
      pkgs.ankiAddons.anki-connect
    ];
  };

  # Configure zen-browser on Linux with additional codec libraries
  programs.zen-browser = {
    enable = true;
    setAsDefaultBrowser = true;
    package = zenTwilight;
  };

  home.sessionVariables = {
    DEFAULT_BROWSER = "${zenTwilight}/bin/zen-twilight";
  };

  xdg.enable = true;
}
