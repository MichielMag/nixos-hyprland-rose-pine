{ inputs, pkgs, lib, config, ... }:

with lib;
let cfg = config.modules.hyprland;

in {
    options.modules.hyprland= { enable = mkEnableOption "hyprland"; };
    config = mkIf cfg.enable {

        home.file.".config/hypr" = {
            source = ./.config/hypr;
            recursive = true;
        };

        home.file.".config/dunst/dunstrc".source = ./.config/dunst/dunstrc;
       
        home.packages = with pkgs; [
            dunst
            hypridle
            hyprland
            hyprland-monitor-attached
            hyprpicker
            hyprshot
            kdePackages.qtwayland
            polkit-kde-agent
            qt5.qtwayland
            swww
            waybar
            wlsunset
            wl-clipboard
        ];
    };
}
