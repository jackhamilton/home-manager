{ config, pkgs, pkgs-unstable, lib, ... }:

let isDarwin = pkgs.stdenv.hostPlatform.isDarwin or pkgs.stdenv.isDarwin;
in {
	home.packages = with pkgs; [
		nerd-fonts.roboto-mono
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
		fcitx5.addons = with pkgs; [
			fcitx5-gtk
			fcitx5-mozc
			catppuccin-fcitx5
			kdePackages.fcitx5-configtool
		];
	};
}
