{ pkgs, lib, config, ... }:

with lib;
let cfg = config.modules.fish;

in {
    options.modules.fish = { enable = mkEnableOption "fish"; };
    config = mkIf cfg.enable {
        home.packages = with pkgs; [
            fastfetch
        ];
        programs.fish = {
            enable = true;
            interactiveShellInit = "oh-my-posh init fish --config $HOME/.config/oh-my-posh/config.json | source";
        };
    };
}
