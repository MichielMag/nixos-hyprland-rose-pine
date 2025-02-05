# save this as shell.nix
{
  pkgs ? import <nixpkgs> { },
  lib ? pkgs.lib,
}:
let
  gl-edge = pkgs.microsoft-edge.override {
    commandLineArgs = "--use-gl=egl";
  };
  cypress = pkgs.cypress.overrideAttrs {
    version = "13.15.0";
    src = pkgs.fetchzip {
      url = "https://cdn.cypress.io/desktop/13.15.0/linux-x64/cypress.zip";
      sha256 = "sha256-dPaorOSbBOMX/iioIU19f8S0qAYHhoMMbUyXerukq/U=";
      stripRoot = true;
    };
    postFixup = ''
      # exit with 1 after 25.05
      makeWrapper $out/opt/cypress/Cypress $out/bin/Cypress \
        --run 'echo "Warning: Use the lowercase cypress executable instead of the capitalized one."' \
        --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --use-gl=egl}}"
    '';
  };
in
pkgs.mkShell {
  allowUnfree = true;
  packages = with pkgs; [
    nodejs_22
    pnpm
    cypress
    gl-edge
  ];
  shellHook = ''
    mkdir -p ${toString ./.}/.nix-node/bin
    mkdir -p ${toString ./.}/.nix-node/lib
    export PATH="${toString ./.}/.nix-node/bin:$PATH"
  '';
  CYPRESS_RUN_BINARY = "${cypress}/bin/Cypress";
  ELECTRON_OZONE_PLATFORM_HINT = "auto";
  NPM_CONFIG_PREFIX = ''
    ${toString ./.}/.nix-node
  '';
}
