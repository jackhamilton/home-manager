{
  config,
  pkgs,
  lib,
  username,
  homeDirectory,
  pkgs-unstable,
  inputs,
  ...
}:

let
  isDarwin = pkgs.stdenv.hostPlatform.isDarwin or pkgs.stdenv.isDarwin;
in
{
  home.packages =
    with pkgs;
    [
      imagemagick
      pipx
      sccache
      sesh
      grex
      hyperfine
      pastel
      watchexec
      lua51Packages.luarocks
      (pkgs.python313.withPackages (ps: [
        ps.libtmux
      ]))
      jq
    ]
    ++ lib.optionals isDarwin [
      # MARK: Macos only
      xcbeautify
    ];

  # Configure zen-browser on macOS with additional codec libraries
  programs.zen-browser = lib.mkIf isDarwin {
    enable = true;
    package = let
      basePackage = inputs.zen-browser.packages.${pkgs.system}.twilight;
      wrappedPackage = pkgs.runCommand "zen-twilight-wrapped" {
        buildInputs = [ pkgs.makeWrapper ];
        passthru = basePackage.passthru or {};
      } ''
        mkdir -p $out
        cp -r ${basePackage}/* $out/
        chmod -R +w $out

        # Wrap the zen-twilight script to add extra library paths
        wrapProgram "$out/Applications/Zen Browser (Twilight).app/Contents/MacOS/zen-twilight" \
          --prefix LD_LIBRARY_PATH : "${pkgs.lib.makeLibraryPath [
            pkgs.ffmpeg-full
            pkgs.openh264
          ]}" \
          --prefix DYLD_FALLBACK_LIBRARY_PATH : "${pkgs.lib.makeLibraryPath [
            pkgs.ffmpeg-full
            pkgs.openh264
          ]}"
      '';
    in wrappedPackage.overrideAttrs (old: {
      passthru = (old.passthru or {}) // {
        override = args: wrappedPackage;
      };
    });
  };
}
