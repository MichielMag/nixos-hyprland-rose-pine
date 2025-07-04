{
  pkgs,
  lib,
  config,
  ...
}:

with lib;
let
  cfg = config.modules.libreoffice;

in
{
  options.modules.libreoffice = {
    enable = mkEnableOption "libreoffice";
  };
  config = mkIf cfg.enable {

    home.packages = [
      pkgs.libreoffice
    ];
  };
}
