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

  home.file = lib.mkIf (!isDarwin) {
    "Downloads/Pictures".source = config.lib.file.mkOutOfStoreSymlink "/mnt/media/Pictures";
  };

  programs.librewolf = {
    enable = true;
    settings = {
      "privacy.resistFingerprinting" = true;
      "privacy.clearOnShutdown.cookies" = true;
      "identity.fxaccounts.enabled" = true;
      "browser.tabs.unloadOnLowMemory" = true;
    };
    policies = {
      ExtensionSettings = {
        "uBlock0@raymondhill.net" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          installation_mode = "force_installed";
        };
        "{72d92df5-2aa0-4b06-b807-aa21767545cd}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/save-in/latest.xpi";
          installation_mode = "force_installed";
        };
        "{d7742d87-e61d-4b78-b8a1-b469842139fa}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/vimium-ff/latest.xpi";
          installation_mode = "force_installed";
        };
        "sponsorBlocker@ajay.app" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/sponsorblock/latest.xpi";
          installation_mode = "force_installed";
        };
        "jid1-MnnxcxisBPnSXQ@jetpack" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/privacy-badger17/latest.xpi";
          installation_mode = "force_installed";
        };
        "jsr@javascriptrestrictor" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/javascript-restrictor/latest.xpi";
          installation_mode = "force_installed";
        };
        "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
          installation_mode = "force_installed";
        };
        "{154cddeb-4c8b-4627-a478-c7e5b427ffdf}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/popupoff/latest.xpi";
          installation_mode = "force_installed";
        };
        "jid1-BoFifL9Vbdl2zQ@jetpack" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/decentraleyes/latest.xpi";
          installation_mode = "force_installed";
        };
        "{74145f27-f039-47ce-a470-a662b129930a}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/clearurls/latest.xpi";
          installation_mode = "force_installed";
        };
        "addon@darkreader.org" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/darkreader/latest.xpi";
          installation_mode = "force_installed";
        };
        "extension@one-tab.com" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/onetab/latest.xpi";
          installation_mode = "force_installed";
        };
        "{119be3f3-597c-4f6a-9caf-627ee431d374}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/blue-blocker/latest.xpi";
          installation_mode = "force_installed";
        };
        "search@kagi.com" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/kagi-search-for-firefox/latest.xpi";
          installation_mode = "force_installed";
        };
        "{2e5ff8c8-32fe-46d0-9fc8-6b8986621f3c}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/search_by_image/latest.xpi";
          installation_mode = "force_installed";
        };
        "{3ba873e8-807c-4956-a75a-defea2e9378b}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/reddit-enhancement/latest.xpi";
          installation_mode = "force_installed";
        };
        "{00000f2a-7cde-4f20-83ed-434fcb420d71}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/imagus/latest.xpi";
          installation_mode = "force_installed";
        };
        "rectifying@gmail.com" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/twitter-media-assist-ff/latest.xpi";
          installation_mode = "force_installed";
        };
        "{6b733b82-9261-47ee-a595-2dda294a4d08}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/yomitan/latest.xpi";
          installation_mode = "force_installed";
        };
        "{c2c003ee-bd69-42a2-b0e9-6f34222cb046}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/auto-tab-discard/latest.xpi";
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
