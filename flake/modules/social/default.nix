{ pkgs, lib, config, ... }:

with lib;
let cfg = 
    config.modules.social;
    
in {
    options.modules.social = { enable = mkEnableOption "social"; };
    config = mkIf cfg.enable {
        home.packages = with pkgs; [
            whatsapp-for-linux
            telegram-desktop
            signal-desktop-beta
            betterdiscordctl
        ];
    };
}
