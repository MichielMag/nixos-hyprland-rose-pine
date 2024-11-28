{
  pkgs,
  lib,
  config,
  firefox-addons,
  ...
}:

with lib;
let
  cfg = config.modules.firefox;
  customAddons = pkgs.callPackage ./addons.nix {
    inherit lib;
    inherit (firefox-addons.lib."x86_64-linux") buildFirefoxXpiAddon;
  };
  extensions = with firefox-addons; [
    bitwarden
    ublock-origin
    ghostery
    sponsorblock
    customAddons.rose-pine-moon-modified
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
        };
      };
    };
  };
}
