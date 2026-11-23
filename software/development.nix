{
  config,
  pkgs,
  pkgs-unstable,
  lib,
  ...
}:
let
  isDarwin = pkgs.stdenv.hostPlatform.isDarwin or pkgs.stdenv.isDarwin;
in
{
  home.packages =
    with pkgs;
    [
      gdb
      gef
      binutils-unwrapped
    ]
    ++ (with pkgs-unstable; [
      godot
    ])
    ++ (if !isDarwin then [ pkgs.requestly ] else [] );

  # nixpkgs.config.android_sdk.accept_license = true;
}
