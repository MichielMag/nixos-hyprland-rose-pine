# save this as shell.nix
{
  pkgs ? import <nixpkgs> { },
  lib ? pkgs.lib,
}:
pkgs.mkShell {
  allowUnfree = true;
  packages = with pkgs; [
    bun
  ];
  shellHook = ''
    mkdir -p ${toString ./.}/.nix-bun/cache
    mkdir -p ${toString ./.}/.nix-bun/cache/transpile
    mkdir -p ${toString ./.}/.nix-bun/bin
    export PATH="${toString ./.}/.nix-bun/bin:$PATH"
    ln -s ${pkgs.bun}/bin/bun ${toString ./.}/.nix-bun/bin/node
    ln -s ${pkgs.bun}/bin/bun ${toString ./.}/.nix-bun/bin/npm
  '';
  BUN_RUNTIME_TRANSPILER_CACHE_PATH = "${toString ./.}/.nix-bun/cache/transpile";
  BUN_INSTALL_GLOBAL_DIR = "${toString ./.}/.nix-bun/install/global";
  BUN_INSTALL_BIN = "${toString ./.}/.nix-bun/bin";
  BUN_INSTALL_CACHE_DIR = "${toString ./.}/.nix-bun/install/cache";
}
