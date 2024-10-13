{
  inputs,
  pkgs,
  config,
  ...
}:

{
  home.stateVersion = "21.03";
  imports = [

    inputs.spicetify-nix.homeManagerModules.default

    ./quickemu

    # gui
    ./gui/hyprland
    ./gui/waybar
    ./gui/rofi
    ./gui/fuzzel
    ./gui/terminal
    ./gui/dunst
    ./gui/wlogout

    # dev
    ./dev/vscode
    ./dev/git

    # system
    ./system/xdg
    ./system/packages
    ./system/ssh
    ./system/keyring

    # Work
    ./work-packages
    ./vm-windows

    # Social
    ./social

    # Media
    ./media

    # Styling
    ./styling

  ];
}
