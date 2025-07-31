{
  inputs,
  pkgs,
  lib,
  config,
  ...
}:

with lib;
let
  cfg = config.modules.arduino;
in
{
  options.modules.arduino = {
    enable = mkEnableOption "arduino";
  };
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      arduino-ide
    ];
  };
}
