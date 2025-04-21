{
  pkgs,
  lib,
  config,
  ...
}:

with lib;
let
  cfg = config.modules.sweethome3d;

in
{
  options.modules.sweethome3d = {
    enable = mkEnableOption "sweethome3d";
  };
  config = mkIf cfg.enable {

    home.packages = with pkgs; [
      sweethome3d.application
      sweethome3d.textures-editor
      sweethome3d.furniture-editor
    ];

  };
}
