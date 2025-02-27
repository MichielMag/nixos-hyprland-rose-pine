{
  pkgs,
  lib,
  config,
  ...
}:

with lib;
let
  cfg = config.modules.blockbench;

in
{
  options.modules.blockbench = {
    enable = mkEnableOption "blockbench";
  };
  config = mkIf cfg.enable {

    home.packages = with pkgs; [
      blockbench
    ];

  };
}
