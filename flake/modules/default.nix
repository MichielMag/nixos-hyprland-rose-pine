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
    ./gui
    ./gui/hyprland
    ./gui/waybar
    ./gui/rofi
    ./gui/fuzzel
    ./gui/terminal
    ./gui/dunst
    ./gui/swaync
    ./gui/wlogout

    # networking
    ./networking/onedrive

    # dev
    ./dev/vscode
    ./dev/git

    # office
    ./office/obsidian

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
