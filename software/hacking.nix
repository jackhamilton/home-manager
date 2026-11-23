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
      burpsuite
      wireshark
      netcat
      pwntools
      ghidra
      john
      cyberchef
    ];

  # nixpkgs.config.android_sdk.accept_license = true;
}
