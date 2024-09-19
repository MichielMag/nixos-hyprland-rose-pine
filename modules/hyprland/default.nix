{ inputs, pkgs, lib, config, ... }:

with lib;
let 
    cfg = config.modules.hyprland;
    swww-random = pkgs.writeShellScriptBin "swww-random" ''${builtins.readFile ./.scripts/swww/randomize.sh}'';
    swww-random-loop = pkgs.writeShellScriptBin "swww-random-loop" ''${builtins.readFile ./.scripts/swww/randomize-loop.sh}'';
    hypr-random-wallpaper = pkgs.writeShellScriptBin "hypr-random-wallpaper" ''${builtins.readFile ./.scripts/hyprland/random-wallpaper.sh}'';
    hypr-random-wallpaper-loop = pkgs.writeShellScriptBin "hypr-random-wallpaper-loop" ''${builtins.readFile ./.scripts/hyprland/random-wallpaper-loop.sh}'';
    hypr-handle-open-lid = pkgs.writeShellScriptBin "hypr-handle-open-lid" ''${builtins.readFile ./.scripts/hyprland/handle-open-lid.sh}'';
    hypr-handle-close-lid = pkgs.writeShellScriptBin "hypr-handle-close-lid" ''${builtins.readFile ./.scripts/hyprland/handle-close-lid.sh}'';
in {
    options.modules.hyprland= { enable = mkEnableOption "hyprland"; };
    config = mkIf cfg.enable {

        #home.file.".config/dunst/dunstrc".source = ./.config/dunst/dunstrc;

        home.packages = with pkgs; [
            #dunst
            hypridle
            #hyprland
            hyprpanel
            #ags bun
            hyprland-monitor-attached
            hyprpicker
            hyprshot

            hyprlock
            
            hypr-random-wallpaper
            hypr-random-wallpaper-loop
            hypr-handle-open-lid
            hypr-handle-close-lid 

            kdePackages.qtwayland
            polkit-kde-agent
            qt5.qtwayland
            swww swww-random swww-random-loop
            #waybar
            wlsunset
            wl-clipboard
        ];

        wayland.windowManager.hyprland = {
            enable = true;
            xwayland.enable = true;
            extraConfig = "
                source = /home/michiel/.config/hypr/conf/hyprland.conf
            ";
            systemd.variables = ["--all"];
            plugins = with pkgs; [
                hyprlandPlugins.hyprexpo
                hyprlandPlugins.hyprgrass
                hyprlandPlugins.hyprtrails
            ];
        };

        home.file.".config/hypr/conf" = {
            source = ./.config/hypr/conf;
            recursive = true;
        };

        home.file.".config/hypr/hyprlock.conf".source = ./.config/hypr/hyprlock.conf;
        home.file.".config/hypr/hypridle.conf".source = ./.config/hypr/hypridle.conf;

        home.file.".cache/ags/hyprpanel/options.json".source = ./.cache/ags/hyprpanel/options.json;
    };
}
