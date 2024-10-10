{
  pkgs,
  lib,
  config,
  ...
}:

with lib;
let
  cfg = config.modules.keyring;

in
{
  options.modules.keyring = {
    enable = mkEnableOption "keyring";
  };
  config = mkIf cfg.enable {
    sservices.gnome-keyring.enable = true;
  };
}
