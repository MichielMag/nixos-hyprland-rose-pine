{
  pkgs,
  lib,
  config,
  ...
}:

with lib;
let
  cfg = config.modules.outlook-pwa;

in
{
  options.modules.outlook-pwa = {
    enable = mkEnableOption "outlook-pwa";
  };
  config = mkIf cfg.enable {
    programs.firefox.webapps.outlook-pwa = {
      url = "https://outlook.office.com/mail/inbox";
      id = 1;
      backgroundColor = "#232136";
      comment = "Email Client";
      genericName = "Email Client";
      categories = [
        "Network"
        "Email"
      ];
    };
  };
}
