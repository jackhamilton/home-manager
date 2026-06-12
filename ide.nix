{ config, pkgs, pkgs-unstable, lib, ... }:
{
    home.packages = with pkgs; [
          # burpsuite
          postman
          wireshark
          netcat
          pwntools
          ghidra
          john
          cyberchef
          gdb
          gef
          binutils-unwrapped
    ];

    # nixpkgs.config.android_sdk.accept_license = true;
}
