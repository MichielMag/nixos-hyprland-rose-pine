{ pkgs, lib, config, ... }:

with lib;
let cfg = 
    config.modules.work-packages;
    
in {
    options.modules.work-packages = { enable = mkEnableOption "work-packages"; };
    config = mkIf cfg.enable {

        home.packages = with pkgs; [
            slack
            teams-for-linux
        ];
    };
}
