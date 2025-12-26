{
  config,
  pkgs,
  lib,
  username,
  homeDirectory,
  pkgs-unstable,
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
}
