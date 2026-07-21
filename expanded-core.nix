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
      sccache
      sesh
      grex
      hyperfine
      pastel
      watchexec
      lua51Packages.luarocks
      jq
      nodejs
    ]
    ++ lib.optionals isDarwin [
      # MARK: Macos only
      xcbeautify
    ];
}
