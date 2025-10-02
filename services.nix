
{ config, pkgs, pkgs-unstable, lib, ... }:
{
    systemd.user.services.nix_channel_update = {
        Unit = {
            Description = "Update nix-channel";
        };
        Timer = {
            OnCalendar = "Daily";
            Persistent = "true";
        };
        Install = {
            WantedBy = [ "timers.target" ];
        };
        Service = {
            ExecStart = "${pkgs.writeShellScript "channel-update" ''
#!/run/current-system/sw/bin/bash
                nix-channel --update
                ''}";
        };
    };
}
