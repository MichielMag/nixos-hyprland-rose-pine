{
  pkgs,
  lib,
  config,
  ...
}:

with lib;
let
  cfg = config.modules.krita;

in
{
  options.modules.krita = {
    enable = mkEnableOption "krita";
  };
  config = mkIf cfg.enable {

    home.packages = with pkgs; [
      krita
    ];

  };
}
