{ pkgs, lib, config, ... }:

with lib;
let cfg = config.modules.rofi;

in {
    options.modules.rofi = { enable = mkEnableOption "rofi"; };
    config = mkIf cfg.enable {

        home.packages = with pkgs; [
            rofi-wayland
        ];
        programs.rofi = {
            enable = true;
            package = pkgs.rofi-wayland;
            theme = ./.config/rofi/rose-pine.rasi;
            extraConfig = {
                show-icons = true;
                sidebar-mode = true;
                icon-theme = "Flat-Remix-Blue-Dark";
                font = "SFNS Display 13";
            };
        };
    };
}
