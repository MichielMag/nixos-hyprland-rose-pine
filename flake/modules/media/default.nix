{
  pkgs,
  lib,
  config,
  spicetify-nix,
  ...
}:

with lib;
let
  cfg = config.modules.media;
  spicePkgs = spicetify-nix.legacyPackages.${pkgs.system};
in
{
  options.modules.media = {
    enable = mkEnableOption "media";
  };
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      #spotify
    ];

    programs.spicetify = {
      enable = true;
      theme = spicePkgs.themes.ziro;
      colorScheme = "rose-pine-moon";
    };
  };
}
