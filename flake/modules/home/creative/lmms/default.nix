{
  pkgs,
  lib,
  config,
  ...
}:

with lib;
let
  cfg = config.modules.lmms;

in
{
  options.modules.lmms = {
    enable = mkEnableOption "lmms";
  };
  config = mkIf cfg.enable {

    home.packages = with pkgs; [
      lmms
    ];

  };
}
