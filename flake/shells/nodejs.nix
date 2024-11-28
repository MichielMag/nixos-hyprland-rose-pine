# save this as shell.nix
{
  pkgs ? import <nixpkgs> { },
}:

pkgs.mkShell {
  packages = with pkgs; [
    nodejs_22
  ];

  shellHook = ''
    mkdir -p ${toString ./.}/.nix-node/bin
    mkdir -p ${toString ./.}/.nix-node/lib
    export PATH="${toString ./.}/.nix-node/bin:$PATH"
  '';

  NPM_CONFIG_PREFIX = ''
    ${toString ./.}/.nix-node
  '';
}
