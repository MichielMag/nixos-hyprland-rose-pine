{
  config,
  pkgs,
  inputs,
  ...
}:

{
  environment.systemPackages = with pkgs; [
    inputs.rose-pine-hyprcursor.packages.${pkgs.system}.default
  ];

  # Install fonts
  fonts = {
    packages = with pkgs; [
      jetbrains-mono
      roboto
      openmoji-color
      nerd-fonts.jetbrains-mono
    ];

    fontconfig = {
      hinting.autohint = true;
      defaultFonts = {
        emoji = [ "OpenMoji Color" ];
      };
    };
  };

  #stylix.enable = false;
  #stylix.autoEnable = false;
  #stylix.image = ./.config/stylix/wallpaper.png;

  console.colors = [
    "232136" # base00-hex

    "eb6f92" # red
    "3e8fb0" # green
    "f6c177" # yellow
    "9ccfd8" # blue
    "c4a7e7" # magenta
    "ea9a97" # cyan

    "e0def4" # base05-hex
    "6e6a86" # base03-hex

    "f6c177" # red
    "3e8fb0" # green
    "eb6f92" # yellow
    "9ccfd8" # blue
    "c4a7e7" # magenta
    "ea9a97" # cyan

    "e0def4" # base06-hex
  ];
}

# black = "$overlay"  393552
# red = "$love"       eb6f92
# green = "$pine"     3e8fb0
# yellow = "$gold"    f6c177
# blue = "$foam"      9ccfd8
# magenta = "$iris"   c4a7e7
# cyan = "$rose"      ea9a97
# white = "$text"     e0def4
