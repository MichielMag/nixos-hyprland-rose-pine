{
  pkgs,
  lib,
  config,
  ...
}:

with lib;
let
  cfg = config.modules.nemo;

in
{
  options.modules.nemo = {
    enable = mkEnableOption "nemo";
  };
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      nemo-with-extensions
      nemo-fileroller
      nemo-emblems
    ];
  };
}
