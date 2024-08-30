{ pkgs, lib, config, ... }:

with lib;
let cfg = config.modules.xdg;

in {
    options.modules.xdg = { enable = mkEnableOption "xdg"; };
    config = mkIf cfg.enable {
        xdg.userDirs = {
            enable = true;
            documents = "$HOME/documents/";
            download = "$HOME/downloads/";
            videos = "$HOME/videos/";
            music = "$HOME/music/";
            pictures = "$HOME/pictures/";
            desktop = "$HOME/desktop/";
            publicShare = "$HOME/public/";
            templates = "$HOME/templates/";
        };
    };
}
