{
  pkgs,
  lib,
  config,
  ...
}:

with lib;
let
  cfg = config.modules.swayosd;
in
{
  options.modules.swayosd = {
    enable = mkEnableOption "swayosd";
    package = mkOption {
      type = types.package;
      default = pkgs.swayosd;
    };
  };
  config = mkIf cfg.enable {
    services.swayosd.enable = true;
    services.swayosd.package = cfg.package;
    # Does not work for now
    systemd.user = {
      services.swayosd-libinput-backend = {
        Unit = {
          Description = "SwayOSD LibInput backend for listening to certain keys like CapsLock, ScrollLock, VolumeUp, etc...";
          PartOf = [ "graphical.target" ];
          After = [ "graphical.target" ];
          ConditionEnvironment = "WAYLAND_DISPLAY";
          Documentation = "https://github.com/ErikReider/SwayOSD";
          StartLimitBurst = 5;
          StartLimitIntervalSec = 10;
        };

        Service = {
          Type = "dbus";
          ExecStart = "${cfg.package}/bin/swayosd-libinput-backend";
          Restart = "on-failure";
          BusName = "org.erikreider.swayosd";
        };

        Install = {
          WantedBy = [ "graphical.target" ];
        };
      };
    };
  };

  home.activation = {
    swayOSDActivation = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      run rm -f $HOME/.config/swayosd;
      run ln -s $HOME/.dotfiles/.config/swayosd $HOME/.config/swayosd;
    '';
  };
}
