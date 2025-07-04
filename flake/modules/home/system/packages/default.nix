{
  pkgs,
  lib,
  config,
  ...
}:

with lib;
let
  cfg = config.modules.packages;
  drun = pkgs.writeShellScriptBin "drun" ''${builtins.readFile ./.scripts/drun.sh}'';
  lrun = pkgs.writeShellScriptBin "lrun" ''${builtins.readFile ./.scripts/lrun.sh}'';

in
{
  options.modules.packages = {
    enable = mkEnableOption "packages";
  };
  config = mkIf cfg.enable {

    home.packages = with pkgs; [
      # File Explorers
      nautilus
      sushi
      code-nautilus
      file-roller

      # Utilities
      ncdu
      dconf-editor

      # Audio Control
      pavucontrol
      pamixer

      # Screen Recorder
      kooha

      # Docker utilities
      lazydocker
      docker-compose

      # Image Viewer
      loupe

      # Desktop application launcher
      dex
      drun
      lrun

      # Simple text editor
      gnome-text-editor

      # Simple calculator
      gnome-calculator

      # Mailing
      geary
      gnome-online-accounts
      gnome-online-accounts-gtk

      # Gaming mouse GUI
      piper
    ];

    programs.firefox.enable = true;
    programs.btop = {
      enable = true;
      settings = {
        color_theme = "theme";
      };
    };
    xdg.enable = true;
    #xdg.mimeApps = {
    #  enable = true;
    #  defaultApplications = {
    #    "inode/directory" = [ "org.kde.dolphin.desktop" ];
    #  };
    #};

    /*
      services.cliphist = {
        enable = true;
        allowImages = true;
        extraOptions = [ "list | rofi -dmenu | cliphist decode | wl-copy" ];
      };
    */

    home.activation = {
      btopActivation = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
                	run rm -f $HOME/.config/btop/themes/theme.theme;
        		mkdir -p $HOME/.config/btop/themes;
                        run ln -s $HOME/.dotfiles/.config/btop/themes/theme.theme $HOME/.config/btop/themes/theme.theme;
      '';
    };
  };
}
