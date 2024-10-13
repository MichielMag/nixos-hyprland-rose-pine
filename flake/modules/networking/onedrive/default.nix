{
  pkgs,
  lib,
  config,
  ...
}:

with lib;
let
  cfg = config.modules.onedrive;
  onedriveLauncher = pkgs.writeShellScriptBin "onedrive-launcher" ''
    # XDG_CONFIG_HOME is not recognized in the environment here.
    if [ -f $HOME/.config/onedrive-launcher ]
    then
      # Hopefully using underscore boundary helps locate variables
      for _onedrive_config_dirname_ in $(cat $HOME/.config/onedrive-launcher | grep -v '[ \t]*#' )
      do
        systemctl --user start onedrive@$_onedrive_config_dirname_
      done
    else
      systemctl --user start onedrive@onedrive
    fi
  '';

in
{
  options.modules.onedrive = {
    enable = mkEnableOption "onedrive";
  };
  config = mkIf cfg.enable {

    home.packages = with pkgs; [
      onedrive
      onedrivegui
    ];

    systemd.user.services."onedrive@" = {
      Unit = {
        Description = "Onedrive sync service";
      };
      Service = {
        Type = "simple";
        ExecStart = ''
          ${pkgs.onedrive}/bin/onedrive --monitor --confdir=%h/.config/%i
        '';
        Restart = "on-failure";
        RestartSec = 3;
        RestartPreventExitStatus = 3;
      };
    };

    systemd.user.services.onedrive-launcher = {

      Install.WantedBy = [ "default.target" ];
      Unit = {
        Description = "Onedrive launcher service";
      };

      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${onedriveLauncher}/bin/onedrive-launcher";
      };
    };

    systemd.user.services.onedrivegui = {
      Unit = {
        Description = "OneDrive GUI";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session-pre.target" ];
        ConditionEnvironment = "WAYLAND_DISPLAY";
      };

      Service = {
        Type = "simple";
        ExecStart = "onedrivegui";
        Restart = "on-failure";
      };

      Install.WantedBy = [ "default.target" ];
    };

  };
}
