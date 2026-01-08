{
  config,
  lib,
  pkgs,
  pkgs-unstable,
  ...
}:
{
  # currently not working. seems to be a home-manager bug. added export to .zshenv
  xdg.systemDirs.data = [
    "/home/jack/.local/share/flatpak/exports/share"
    "/var/lib/flatpak/exports/share"
  ];

  home.sessionVariables = {
    ANKI_WAYLAND = 1;
  };

  services.udiskie = {
    enable = true;
    automount = true;
    notify = true;
    settings = {
      # workaround for
      # https://github.com/nix-community/home-manager/issues/632
      program_options = {
        # replace with your favorite file manager
        file_manager = "${pkgs.nautilus}/bin/nautilus";
      };
    };
  };

  programs.neovim = {
    enable = true;

    extraPackages = with pkgs; [
      git
      gcc
      gnumake
      pkg-config
      ripgrep
      fd
      nodejs
      tree-sitter
      lua-language-server
      rust-analyzer
      nixd
      nixfmt-rfc-style
    ];
  };

  home.packages =
    (with pkgs; [
      brightnessctl
      nautilus
      solarc-gtk-theme
      autotiling
      bazelisk
      bitwarden-menu
      bitwarden-cli
      cifs-utils
      samba4Full
      cliphist
      playerctl
      dconf-editor
      dpkg
      dunst
      evince
      file-roller
      flameshot
      fuzzel
      gamescope
      gammastep
      grim
      inetutils
      lutris
      lxappearance
      mangohud
      mimeo
      neomutt
      networkmanager
      networkmanagerapplet
      nitrogen
      nushell
      nwg-bar
      nwg-displays
      nwg-wrapper
      orca
      pamixer
      pavucontrol
      pipewire
      wireplumber
      protonvpn-gui
      qmk
      qemu
      rofi
      ruby
      slurp
      waybar
      wlsunset
      wofi
      xdg-desktop-portal
      xdg-desktop-portal-wlr
      hyprpolkitagent
      xdg-terminal-exec
      hyprsunset
      hyprpaper
      waypaper
      swaynotificationcenter
      udiskie
      grimblast
      wl-clipboard
      wtype
      go
    ])
    ++ (with pkgs-unstable; [
      papirus-icon-theme
    ]);
}
