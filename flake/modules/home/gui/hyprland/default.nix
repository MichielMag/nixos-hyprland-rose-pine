{
  inputs,
  pkgs,
  lib,
  config,
  meta,
  ...
}:

with lib;
let
  cfg = config.modules.hyprland;

  swww-random = pkgs.writeShellScriptBin "swww-random" ''${builtins.readFile ./.scripts/swww/randomize.sh}'';
  swww-random-loop = pkgs.writeShellScriptBin "swww-random-loop" ''${builtins.readFile ./.scripts/swww/randomize-loop.sh}'';
  hypr-random-wallpaper = pkgs.writeShellScriptBin "hypr-random-wallpaper" ''${builtins.readFile ./.scripts/hyprland/random-wallpaper.sh}'';
  hypr-random-wallpaper-loop = pkgs.writeShellScriptBin "hypr-random-wallpaper-loop" ''${builtins.readFile ./.scripts/hyprland/random-wallpaper-loop.sh}'';
  hypr-handle-open-lid = pkgs.writeShellScriptBin "hypr-handle-open-lid" ''${builtins.readFile ./.scripts/hyprland/handle-open-lid.sh}'';
  hypr-handle-close-lid = pkgs.writeShellScriptBin "hypr-handle-close-lid" ''${builtins.readFile ./.scripts/hyprland/handle-close-lid.sh}'';
  clipsync = pkgs.writeShellScriptBin "clipsync" ''${builtins.readFile ./.scripts/util/clip-sync.sh}'';
  hypr-restore-lockscreen = pkgs.writeShellScriptBin "hypr-restore-lockscreen" ''${builtins.readFile ./.scripts/hyprland/restore-lockscreen.sh}'';
in
{
  options.modules.hyprland = {
    enable = mkEnableOption "hyprland";
  };
  config = mkIf cfg.enable {

    #home.file.".config/dunst/dunstrc".source = ./.config/dunst/dunstrc;

    home.packages = with pkgs; [
      clipnotify
      xclip

      hypridle
      hyprland-monitor-attached
      hyprpicker
      hyprshot

      hyprlock

      clipsync
      hypr-random-wallpaper
      hypr-random-wallpaper-loop
      hypr-handle-open-lid
      hypr-handle-close-lid
      hypr-restore-lockscreen

      kdePackages.qtwayland
      polkit-kde-agent

      pyprland

      qt5.qtwayland
      swww
      swww-random
      swww-random-loop
      #waybar

      wl-clipboard
      wlsunset
      wlr-layout-ui
    ];

    wayland.windowManager.hyprland = {
      enable = true;
      xwayland.enable = true;
      extraConfig = ''
        source = /home/michiel/.config/hypr/conf/hyprland.conf
      '';

      systemd.variables = [ "--all" ];
      systemd.extraCommands = [
        "${pkgs.gnome-keyring}/bin/gnome-keyring-daemon --start --components=secrets,pkcs11,ssh"
      ];

      package = null;
      portalPackage = null;
      plugins = with pkgs; [
        # hyprlandPlugins.hyprexpo
        # hyprlandPlugins.hyprgrass
        split-monitor-workspaces
        # hyprlandPlugins.hyprtrails
      ];
    };

    home.activation = {
      hyprlandAction = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        run rm -f $HOME/.config/hypr/conf;
        run ln -s $HOME/.dotfiles/.config/hypr/conf $HOME/.config/hypr/conf;
      '';
    };

    home.file.".config/hypr/hyprlock.conf".source = ./.config/hypr/hyprlock.conf;
    home.file.".config/hypr/hypridle.conf".source = ./.config/hypr/hypridle.conf;
    home.file.".config/hypr/pyprland.toml".source = ./.config/hypr/pyprland.toml;
  };
}
