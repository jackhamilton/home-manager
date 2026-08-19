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

    programs.ssh.matchBlocks."github-superfile" = {
        hostname = "github.com";
        user = "git";
        identityFile = [ "${config.home.homeDirectory}/.ssh/id_ed25519_superfile" ];
        identitiesOnly = true;
    };

    home.packages = (with pkgs; [
        wezterm
        swiftlint
        swiftformat
        swiftassist-rs
    ]);
}
