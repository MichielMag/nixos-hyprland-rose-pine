{
  pkgs,
  lib,
  config,
  ...
}:

with lib;
let
  cfg = config.modules.vm-windows;
in
{
  options.modules.vm-windows = {
    enable = mkEnableOption "vm-windows";
  };

  config = mkIf cfg.enable {

  };
}
