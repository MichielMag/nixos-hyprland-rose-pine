# save this as shell.nix
{
  pkgs ? import <nixpkgs> { },
}:
pkgs.mkShell {
  allowUnfree = true;
  packages = with pkgs; [
    dotnet-sdk_9
    dotnet-runtime_9
    azure-artifacts-credprovider
    azure-cli
  ];
  DOTNET_ROOT = "${pkgs.dotnet-sdk_9}/share/dotnet";
  NUGET_NETCORE_PLUGIN_PATHS = "${pkgs.azure-artifacts-credprovider}/lib/azure-artifacts-credprovider/CredentialProvider.Microsoft.dll";
  NUGET_CREDENTIALPROVIDER_SESSIONTOKENCACHE_ENABLED = "false";
}
