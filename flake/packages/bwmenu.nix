{
  lib,
  stdenv,
  fetchFromGitHub,
  pkgs,
}:

stdenv.mkDerivation {
  pname = "bwmenu";
  version = "0.5.0"; # Adjust version as needed

  src = fetchFromGitHub {
    owner = "MichielMag";
    repo = "bitwarden-rofi";
    rev = "8be76fdd647c2bdee064e52603331d8e6ed5e8e2";
    sha256 = "1ia2v9cj5v3scyf4xp9iihgqnmydik2h7sf03fc39i6y3ql3wr0j";
  };

  # List runtime dependencies
  buildInputs = [
    pkgs.keyutils
  ];

  # No build phase needed since we're just installing scripts
  dontBuild = true;

  installPhase = ''
    # Create necessary directories
    mkdir -p $out/bin
    mkdir -p $out/lib/bwmenu

    # Install the main executable
    install -Dm755 bwmenu $out/bin/bwmenu

    # Install the library file
    install -Dm644 lib-bwmenu $out/lib/bwmenu/lib-bwmenu

    # Modify the main script to look for lib-bwmenu in the correct relative path
    substituteInPlace $out/bin/bwmenu \
      --replace './lib-bwmenu' "$out/lib/bwmenu/lib-bwmenu"
  '';

  meta = with lib; {
    description = "Bitwarden menu utility";
    homepage = ""; # Add homepage URL
    license = licenses.mit; # Adjust license as needed
    platforms = platforms.unix;
    maintainers = with maintainers; [ ]; # Add maintainers if desired
  };
}
