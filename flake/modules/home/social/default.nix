{
  pkgs,
  lib,
  config,
  ...
}:

with lib;
let
  cfg = config.modules.social;

in
{
  options.modules.social = {
    enable = mkEnableOption "social";
  };
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      telegram-desktop
      signal-desktop
      betterdiscordctl
    ];
    firefox.pwa."whatsapp" = {
      url = "https://web.whatsapp.com";
      profileId = 2;
      icon = "whatsapp";
      name = "WhatsApp Web";
      genericName = "WhatsApp Instant Messaging";
    };
  };
}
