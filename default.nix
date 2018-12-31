{ stdenv, fetchurl, bdftopcf, mkfontdir, mkfontscale }:

stdenv.mkDerivation {
  name = "greentea-font";

  src = ./.;
  nativeBuildInputs = [ bdftopcf mkfontdir mkfontscale ];

  dontBuild = true;
  installPhase = ''
    for font in $src/src/*.bdf; do
      fn=$(basename $font)
      bdftopcf $font | gzip > ''${fn%.bdf}.pcf.gz
    done

    # install the pcf fonts (for xorg applications)
    fontDir="$out/share/fonts/greentea"
    mkdir -p "$fontDir"
    mv *.pcf.gz "$fontDir"

    cd "$fontDir"
    mkfontdir
    mkfontscale
  '';
}
