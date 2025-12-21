{ config, pkgs, pkgs-unstable, lib, ... }:
{
	wayland.windowManager.hyprland = {
		enable = true;
		settings = {
			"$mod" = "SUPER";
			bind = [
				"$mod, w, exec, zen-browser"
				"$mod, enter, exec, wezterm"

			];
		};
	};
}
