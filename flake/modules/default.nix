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
    ./gui/rofi
    ./gui/fuzzel
    ./gui/terminal

    # dev
    ./dev/vscode
    ./dev/git

    # system
    ./system/xdg
    ./system/packages
    ./system/ssh

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
