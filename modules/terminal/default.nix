{ pkgs, lib, config, ... }:

with lib;
let cfg = config.modules.terminal;

in {
    options.modules.terminal = { 
        enable = mkEnableOption "terminal"; 
    };
    config = mkIf cfg.enable {

        home.file.".config/oh-my-posh/config.json".source = ./.config/oh-my-posh/config.json;
        home.file.".config/fish/functions" = {
            source = ./.config/fish/functions;
            recursive = true;
        };
        home.file.".config/fish/completions" = {
            source = ./.config/fish/completions;
            recursive = true;
        };
        
        home.packages = with pkgs; [
            fastfetch
        ];

        programs.kitty = {
            enable = true;
            theme = "Rosé Pine Moon";
            shellIntegration.enableFishIntegration = true;
            font = {
                name = "JetBrainsMono Nerd Font";
                size = 10;
            };
            settings = {
                background_opacity = "0.9";
            };
        };

        programs.fish = {
            enable = true;
            interactiveShellInit = "oh-my-posh init fish --config $HOME/.config/oh-my-posh/config.json | source";
        };

        programs.oh-my-posh = {
            enable = true;
        };
    };
}
