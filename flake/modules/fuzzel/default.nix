{ pkgs, lib, config, ... }:

with lib;
let 
    cfg = config.modules.rofi;
    emoji-picker = pkgs.writeShellScriptBin "emoji-picker" ''${builtins.readFile ./.scripts/emoji-picker.sh}'';
  
in {
    options.modules.rofi = { enable = mkEnableOption "fuzzel"; };

    config = mkIf cfg.enable {

        home.packages = with pkgs; [
            bemoji
        ];

        programs.fuzzel = {
            enable = true;
        };

        programs.ydotool = {
            enable = true;
            group = "ydotool";
        };

        home.activation = {
            myActivationAction = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
                run rm $HOME/.config/fuzzel;
                run ln -s $HOME/.dotfiles/.config/fuzzel $HOME/.config/fuzzel;
            '';
        };
    };
}
