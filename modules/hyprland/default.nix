{ inputs, pkgs, lib, config, ... }:

with lib;
let 
    cfg = config.modules.hyprland;
    swww-random = pkgs.writeShellScriptBin "swww-random" ''${builtins.readFile ./.scripts/swww/randomize.sh}'';
    swww-random-loop = pkgs.writeShellScriptBin "swww-random-loop" ''${builtins.readFile ./.scripts/swww/randomize-loop.sh}'';
    hypr-random-wallpaper = pkgs.writeShellScriptBin "hypr-random-wallpaper" ''${builtins.readFile ./.scripts/hyprland/random-wallpaper.sh}'';
    hypr-random-wallpaper-loop = pkgs.writeShellScriptBin "hypr-random-wallpaper-loop" ''${builtins.readFile ./.scripts/hyprland/random-wallpaper-loop.sh}'';
in {
    options.modules.hyprland= { enable = mkEnableOption "hyprland"; };
    config = mkIf cfg.enable {

        home.file.".config/dunst/dunstrc".source = ./.config/dunst/dunstrc;

        wayland.windowManager.hyprland = {
            enable = true;
            xwayland.enable = true;
            extraConfig = "
                source = /home/michiel/.config/hypr/conf/hyprland.conf
            ";
            systemd.variables = ["--all"];
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
            swww swww-random swww-random-loop
            waybar
            wlsunset
            wl-clipboard
        ];
    };
}
