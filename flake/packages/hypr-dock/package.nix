{
  lib,
  stdenv,
  fetchFromGitHub,
  pkgs,
  buildGoModule,
}:

buildGoModule (finalAttrs: {
  pname = "hypr-dock";
  version = "1.0.5"; # Adjust version as needed

  src = fetchFromGitHub {
    owner = "lotos-linux";
    repo = "hypr-dock";
    rev = "e5ff4dbe913d019bc300921a00d035f8f11a5011";
    sha256 = "sha256-fMBJaupB5fDlpv+w92/cqP5OLS0UVWCUvG9QOG9vioI=";
  };

  vendorHash = "sha256-KoDPQHfmYzZ/7wQAq4TKq3bIlnDLoMgH9oc4noNlSb0=";

  installPhase = ''

    # Install the main executable
    install -Dm755 bin/hypr-dock $out/bin/hypr-dock

    wrapProgram $out/bin/hypr-dock \
      --prefix PATH : "${
        lib.makeBinPath [
          pkgs.gtk3
          pkgs.gtk-layer-shell
        ]
      }"
  '';

  finalAttrs.nativeBuildInputs = [
    pkgs.gtk3
    pkgs.gtk-layer-shell
  ];

  meta = with lib; {
    description = "Interactive Dock Panel for Hyprland";
    homepage = ""; # Add homepage URL
    license = licenses.gpl3; # Adjust license as needed
    platforms = platforms.unix;
    maintainers = with maintainers; [ ]; # Add maintainers if desired
  };
})
