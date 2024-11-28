# save this as shell.nix
{
  pkgs ? import <nixpkgs> { },
  lib ? pkgs.lib,
}:
pkgs.mkShell {
  allowUnfree = true;
  packages = with pkgs; [
    deno
  ];
  shellHook = ''
    mkdir -p ${toString ./.}/.nix-deno/bin
    mkdir -p ${toString ./.}/.nix-deno/cache
  '';
  DENO_INSTALL_ROOT = "${toString ./.}/.nix-deno/bin";
  DENO_DIR = "${toString ./.}/.nix-deno/cache";
}
