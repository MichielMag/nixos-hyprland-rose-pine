{
  lib,
  stdenv,
  fetchFromGitHub,
  pkgs,
}:

stdenv.mkDerivation {
  pname = "bwmenu";
  version = "unstable-2024-10-29"; # Adjust version as needed

  src = fetchFromGitHub {
    owner = "MichielMag";
    repo = "bitwarden-rofi";
    rev = "77bbf735b72a0c17f68fdbcc953e5d1c512f1224";
    sha256 = "08h61nc9ihi9n77h33kzklpnlph33r8x35ahas5hnmk0ijnami1i";
  };

  # List runtime dependencies
  propagatedBuildInputs = [
    pkgs.keyutils
  ];

  # No build phase needed since we're just installing scripts
  dontBuild = true;

  installPhase = ''
    # Create necessary directories
    mkdir -p $out/bin

    # Install the main executable
    install -Dm755 bwmenu $out/bin/bwmenu

    # Install the library file
    install -Dm644 lib-bwmenu $out/bin/lib-bwmenu

    wrapProgram $out/bin/bwmenu \
      --prefix PATH : "${lib.makeBinPath [ pkgs.keyutils ]}"
  '';

  nativeBuildInputs = [
    pkgs.makeWrapper
  ];

  meta = with lib; {
    description = "Bitwarden menu utility";
    homepage = ""; # Add homepage URL
    license = licenses.mit; # Adjust license as needed
    platforms = platforms.unix;
    maintainers = with maintainers; [ ]; # Add maintainers if desired
  };
}
