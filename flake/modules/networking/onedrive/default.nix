{
  pkgs,
  lib,
  config,
  ...
}:

with lib;
let
  cfg = config.modules.onedrive;

in
{
  options.modules.onedrive = {
    enable = mkEnableOption "onedrive";
  };
  config = mkIf cfg.enable {

    services.onedrive.enable = true;

    home.packages = with pkgs; [
      onedrivegui
    ];

  };
}
