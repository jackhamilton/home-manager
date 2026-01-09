{
  config,
  pkgs,
  pkgs-unstable,
  useColemak,
  lib,
  ...
}:

let
  isDarwin = pkgs.stdenv.hostPlatform.isDarwin or pkgs.stdenv.isDarwin;
in
{
  home.packages = with pkgs; [
    nerd-fonts.roboto-mono
    nerd-fonts.arimo
    nerd-fonts.meslo-lg
    nerd-fonts.jetbrains-mono
    dejavu_fonts
    kochi-substitute
    ipafont
  ];

  fonts.fontconfig.enable = true;

  fonts.fontconfig.defaultFonts = {
    monospace = [
      "Roboto Sans Mono"
      "IPAGothic"
    ];
    sansSerif = [
      "DejaVu Sans"
      "IPAPGothic"
    ];
    serif = [
      "DejaVu Serif"
      "IPAPMincho"
    ];
  };

  i18n.inputMethod = lib.mkIf (!isDarwin) {
    type = "fcitx5";
    enable = true;

    fcitx5.waylandFrontend = true;
    fcitx5.addons = with pkgs; [
      fcitx5-gtk
      fcitx5-mozc
      catppuccin-fcitx5
      kdePackages.fcitx5-configtool
    ];

    fcitx5.settings.inputMethod =
      if useColemak then
        {
          GroupOrder."0" = "Default";
          "Groups/0" = {
            Name = "Default";
            "Default Layout" = "keyboard-us-colemak_dh";
            DefaultIM = "mozc";
          };

          # keyboard entry (this will use whatever your compositor/system XKB layout is)
          "Groups/0/Items/0".Name = "keyboard-us-colemak_dh";
          "Groups/0/Items/1".Name = "mozc";
        }
      else
        {
          GroupOrder."0" = "Default";
          "Groups/0" = {
            Name = "Default";
            "Default Layout" = "keyboard-us";
            DefaultIM = "mozc";
          };

          # keyboard entry (this will use whatever your compositor/system XKB layout is)
          "Groups/0/Items/0".Name = "keyboard-us";
          "Groups/0/Items/1".Name = "mozc";
        };

    fcitx5.settings.addons = {
      classicui.globalSection = {
        Theme = "catppuccin-mocha-flamingo";
      };
    };
  };
}
