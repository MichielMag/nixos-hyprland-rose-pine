{
  pkgs,
  lib,
  config,
  ...
}:

with lib;
let
  cfg = config.modules.bottles;

in
{
  options.modules.bottles = {
    enable = mkEnableOption "bottles";
  };
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      bottles-unwrapped
    ];
  };
}
