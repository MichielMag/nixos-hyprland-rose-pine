{ pkgs, lib, config, spicetify-nix, ... }:

with lib;
let 
    cfg = config.modules.media;
    
in {
    options.modules.media = { enable = mkEnableOption "media"; };
    config = mkIf cfg.enable {
        home.packages = with pkgs; [
            
        ];
    };
}
