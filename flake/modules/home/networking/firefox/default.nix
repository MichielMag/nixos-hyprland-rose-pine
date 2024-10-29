{
  pkgs,
  lib,
  config,
  addons,
  ...
}:

with lib;
let
  cfg = config.modules.firefox;
  extensions = with addons; [
    bitwarden
    ublock-origin
    ghostery
    sponsorblock
    firefox-color
  ];
in
{
  options.modules.firefox = {
    enable = mkEnableOption "firefox";
  };
  config = mkIf cfg.enable {
    programs.firefox = {
      enable = true;
      profiles = {
        default = {
          id = 0;
          inherit extensions;
        };
        dev = {
          id = 1;
          extensions = extensions // [
            angular-devtools
            reduxdevtools
          ];
        }
      };
    };
  };
}
