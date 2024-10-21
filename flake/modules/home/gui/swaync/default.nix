{
  pkgs,
  lib,
  config,
  ...
}:

with lib;
let
  cfg = config.modules.swaync;

in
{
  options.modules.swaync = {
    enable = mkEnableOption "swaync";
  };
  config = mkIf cfg.enable {

    home.packages = with pkgs; [
      swaynotificationcenter
      at-spi2-core
    ];

    systemd.user.services.swaync = {
      Unit = {
        Description = "Swaync notification daemon";
        Documentation = "https://github.com/ErikReider/SwayNotificationCenter";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session-pre.target" ];
        ConditionEnvironment = "WAYLAND_DISPLAY";
      };

      Service = {
        Type = "dbus";
        BusName = "org.freedesktop.Notifications";
        ExecStart = "${pkgs.swaynotificationcenter}/bin/swaync";
        Restart = "on-failure";
      };

      Install.WantedBy = [ "graphical-session.target" ];
    };

    home.activation = {
      swayncActivation = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        run rm -f $HOME/.config/swaync;
        run ln -s $HOME/.dotfiles/.config/swaync $HOME/.config/swaync;
      '';
    };
  };
}
