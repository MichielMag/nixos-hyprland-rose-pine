{
  pkgs,
  lib,
  config,
  ...
}:

with lib;
let
  cfg = config.modules.steam;

in
{
  options.modules.steam = {
    enable = mkEnableOption "steam";
  };
  config = mkIf cfg.enable {

    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
      localNetworkGameTransfers.openFirewall = true;
      gamescopeSession.enable = true;
    };
  };
}
