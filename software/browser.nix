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

  zenTwilight =
    let
      wrapped =
        pkgs.runCommand "zen-twilight-wrapped"
          {
            buildInputs = [ pkgs.makeWrapper ];
            passthru = basePackage.passthru or { };
          }
          ''
            mkdir -p $out
            cp -r ${basePackage}/* $out/
            chmod -R +w $out
            wrapProgram "$out/bin/zen-twilight" \
              --prefix LD_LIBRARY_PATH : "${
                pkgs.lib.makeLibraryPath [
                  pkgs.ffmpeg-full
                  # pkgs.linphonePackages.mediastreamer2
                  pkgs.openh264
                ]
              }"
          '';
    in
    wrapped.overrideAttrs (old: {
      passthru = (old.passthru or { }) // {
        override = args: zenTwilight;
      };
    });
  isDarwin = pkgs.stdenv.hostPlatform.isDarwin or pkgs.stdenv.isDarwin;
in
{
  home.packages =
    (with pkgs; [])
    ++ (with pkgs-unstable; [ ])
    ++ (if !isDarwin then [ pkgs.chromium ] else [] );

  programs.librewolf = {
    enable = true;
    settings = {
      "privacy.resistFingerprinting" = true;
      "privacy.clearOnShutdown.cookies" = true;
    };
    policies = {
      ExtensionSettings = {
        "uBlock0@raymondhill.net" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          installation_mode = "force_installed";
        };
      };
    };
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
}
