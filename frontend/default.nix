{ pkgs, ... }:

with pkgs;
with elmPackages;

stdenv.mkDerivation {
  name = "gh-explorer-frontend";
  src = ./.;

  buildInputs = [ elm nodejs ];

  # ugly hack to put all
  # dependencies into the source directory
  HOME = "$src";

  buildPhase = ''
    ${elm}/bin/elm-make Main.elm --yes
  '';

  installPhase = ''
    mkdir -p $out
    cp *.html $out
  '';
}
