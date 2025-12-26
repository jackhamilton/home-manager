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
  home.username = username;
  home.homeDirectory = homeDirectory;
  home.stateVersion = "24.05";

  nixpkgs.config.allowUnfree = true;

  home.packages =
    with pkgs;
    [
      lsd
      bat
      curlie
      zoxide
      cloc
      fzf
      cowsay
      fd
      github-cli
      ripgrep
      wget
      sd
      xcp
      lazygit
      htop
      tmux
      nixfmt-rfc-style
      neofetch
      starship
      watchexec
    ];

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  programs.starship = {
    enable = true;
  };

  programs.home-manager.enable = true;

  home.sessionVariables = {
    EDITOR = "nvim";
    ISNIXSHELL = "yes";
  };
}
