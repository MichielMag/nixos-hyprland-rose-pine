{
  inputs,
  pkgs,
  stable,
  config,
  ...
}:

{
  imports = [ ../../modules/nixos/default.nix ];

  modules = {
    #evolution.enable = true;
  };

  networking.nameservers = [
    "9.9.9.9"
    "149.112.112.112"
  ];
}
