{
  pkgs,
  lib,
  config,
  ...
}:

with lib;
let
  cfg = config.modules.terminal;
  terminal-class = pkgs.writeShellScriptBin "terminal-class" ''${builtins.readFile ./.scripts/terminal-class.sh}'';

in
{
  options.modules.terminal = {
    enable = mkEnableOption "terminal";
  };
  config = mkIf cfg.enable {

    home.packages = with pkgs; [
      fastfetch
      eza
      terminal-class
    ];

    programs.kitty = {
      enable = true;
      themeFile = "rose-pine-moon";
      shellIntegration.enableFishIntegration = true;
      font = {
        name = "JetBrainsMono Nerd Font";
        size = 10;
      };
      settings = {
        background_opacity = "0.9";
        title = "kitty";
      };
    };

    programs.fish = {
      enable = true;
      interactiveShellInit = "oh-my-posh init fish --config $HOME/.config/oh-my-posh/config.json | source";
      shellAliases = {
        ls = "eza -al --color=always --group-directories-first --icons --git --header";
      };
    };

    programs.oh-my-posh = {
      enable = true;
    };

    home.activation = {
      terminalAction = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
                	run rm -f $HOME/.config/oh-my-posh;
                	run ln -s $HOME/.dotfiles/.config/oh-my-posh $HOME/.config/oh-my-posh;

        			run rm -f $HOME/.config/fish/functions;
        			run rm -f $HOME/.config/fish/completions;
                	run ln -s $HOME/.dotfiles/.config/fish/functions $HOME/.config/fish/functions;
                	run ln -s $HOME/.dotfiles/.config/fish/completions $HOME/.config/fish/completions;
      '';
    };

    #programs.eza = {
    #    enable = true;
    #    git = true;
    #    icons = true;
    #    extraOptions = [
    #        "--color=always"
    #        "--group-directories-first"
    #        "--time-style=long-iso"
    #        "--header"
    #    ];
    #};
  };
}
