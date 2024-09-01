{ inputs, pkgs, lib, config, ... }:

with lib;
let cfg = config.modules.hyprland;

in {
    options.modules.hyprland= { enable = mkEnableOption "hyprland"; };
    config = mkIf cfg.enable {

        home.file.".config/dunst/dunstrc".source = ./.config/dunst/dunstrc;
       
        wayland.windowManager.hyprland = {
            enable = true;
            xwayland.enable = true;
            extraConfig = "source = /home/michiel/.config/hypr/conf/hyprland.conf";
        };

        home.file.".config/hypr/conf" = {
            source = ./.config/hypr/conf;
            recursive = true;
        };

        home.packages = with pkgs; [
            dunst
            #hypridle
            #hyprland
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
