{ pkgs, lib, config, ... }:

with lib;
let cfg = config.modules.kitty;

in {
    options.modules.kitty = { enable = mkEnableOption "kitty"; };
    config = mkIf cfg.enable {
        home.packages = with pkgs; [
            fastfetch
        ];
        programs.kitty = {
            enable = true;
            theme = "Rosé Pine Moon";
            shellIntegration.enableFishIntegration = true;
            font = {
                name = "JetBrainsMono Nerd Font";
                size = 10;
            };
            settings = {
                background_opacity = "0.9";
            };
        };
    };
}
