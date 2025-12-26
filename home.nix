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
      difftastic
      cowsay
      fd
      github-cli
      imagemagick
      pipx
      ripgrep
      sccache
      wget
      sesh
      grex
      hyperfine
      pastel
      sd
      watchexec
      xcp
      go
      lazygit
      htop
      tmux
      nixfmt-rfc-style
      neofetch
      starship
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
