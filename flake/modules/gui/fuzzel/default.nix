{
  pkgs,
  stable,
  lib,
  config,
  ...
}:

with lib;
let
  cfg = config.modules.fuzzel;
  emoji-picker = pkgs.writeShellScriptBin "emoji-picker" ''${builtins.readFile ./.scripts/emoji-picker.sh}'';

in
{
  options.modules.fuzzel = {
    enable = mkEnableOption "fuzzel";
  };

  config = mkIf cfg.enable {

    home.sessionVariables = {
      "BEMOJI_PICKER_CMD" = "fuzzel -d";
    };
    home.packages = with pkgs; [
      bemoji
      emoji-picker
    ];

    programs.fuzzel = {
      enable = true;
      package = pkgs.fuzzel;
    };

    home.activation = {
      fuzzelAction = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        run rm -f $HOME/.config/fuzzel;
        run ln -s $HOME/.dotfiles/.config/fuzzel $HOME/.config/fuzzel;
      '';
    };
  };
}
