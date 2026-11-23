{
  config,
  pkgs,
  pkgs-unstable,
  lib,
  ...
}:
{
  home.packages =
    with pkgs;
    [
      postman
      gdb
      gef
      binutils-unwrapped
    ]
    ++ (with pkgs-unstable; [
      godot
    ]);

  # nixpkgs.config.android_sdk.accept_license = true;
}
