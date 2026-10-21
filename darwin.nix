{ config, pkgs, pkgs-unstable, lib, ... }:

let
  swiftassist-rs = pkgs.rustPlatform.buildRustPackage {
    pname = "sass";
    version = "0.4.4";
    src = pkgs.fetchFromGitHub {
      owner = "jackhamilton";
      repo = "sass-rs";
      rev = "62e5e2e7";
      hash = "sha256-F21T0fd/DzIL9zyTfjE645Nook1DN1f7lxDITFUDKKc=";
    };
    cargoHash = "sha256-C82jDtgeR8kc+E3Ipk+NTr67m+JwLJYR/4ic8vLsGP8=";
    nativeBuildInputs = [ pkgs.git ];
  };
in {
    programs.ssh.extraConfig = ''
        Include ${config.home.homeDirectory}/.config/colima/ssh_config
    '';

    programs.ssh.settings."github-superfile" = {
        HostName = "github.com";
        User = "git";
        IdentityFile = [ "${config.home.homeDirectory}/.ssh/id_ed25519_superfile" ];
        IdentitiesOnly = true;
    };

    home.packages = (with pkgs; [
        wezterm
        swiftassist-rs
    ]) ++ (with pkgs-unstable; [
        swift
        swiftlint
        swiftformat
        xcbeautify
    ]);
}
