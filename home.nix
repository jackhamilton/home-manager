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
  home.stateVersion = "26.05";

  nixpkgs.config.allowUnfree = true;

  home.packages =
    with pkgs;
    [
      eza
      sccache
      bat
      curlie
      zoxide
      cloc
      fzf
      yazi
      cowsay
      fd
      github-cli
      ripgrep
      broot
      skim
      wget
      sd
      xcp
      lazygit
      htop
      #(pkgs.python313.withPackages (ps: [
      #  ps.libtmux
      #  ps.hidapi
      #  ps.pip
      #]))
      #pkgs-unstable.tmux
      zellij
      nixfmt
      fastfetch
      watchexec
      chezmoi
      bash-language-server
      pkgs.dwt1-shell-color-scripts
    ];

  programs.direnv = {
    enable = true;
    enableZshIntegration = false;
    enableFishIntegration = false;
    nix-direnv.enable = true;
    config = {
        global.hide_env_diff = true;
        global.log_filter = "^$";
    };
  };
  programs.direnv-instant.enable = true;

  programs.starship = {
    enable = true;
  };

  programs.zellij = {
    enable = true;
    settings = {
      theme = "catppuccin-mocha";
      default_shell = "${pkgs.fish}/bin/fish";
      env.fish_trace = "";
    };
  };

  programs.home-manager.enable = true;

  home.sessionVariables = {
    EDITOR = "nvim";
    ISNIXSHELL = "yes";
    # attempted copypaste fix
    NIXOS_OZONE_WL = "1";
  };
}
