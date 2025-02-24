{
  inputs,
  pkgs,
  lib,
  config,
  ...
}:

with lib;
let
  cfg = config.modules.godot;
in
{
  options.modules.godot = {
    enable = mkEnableOption "godot";
  };
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      godot_4
    ];
  };
}
