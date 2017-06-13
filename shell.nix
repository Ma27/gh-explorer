{ nixpkgs ? import <nixpkgs> {}, compiler ? "default" }:

let

  inherit (nixpkgs) pkgs;

  f = { mkDerivation, aeson, base, github, HDBC, HDBC-sqlite3, mtl
      , scotty, stdenv, text, vector
      }:
      mkDerivation {
        pname = "gh-explorer";
        version = "0.1.0.0";
        src = ./.;
        isLibrary = false;
        isExecutable = true;
        executableHaskellDepends = [
          aeson base github HDBC HDBC-sqlite3 mtl scotty text vector
        ];
        description = "Simple project exploring tool for GitHub based on Haskell, Nix and Elm";
        license = stdenv.lib.licenses.mit;
      };

  haskellPackages = if compiler == "default"
                       then pkgs.haskellPackages
                       else pkgs.haskell.packages.${compiler};

  drv = haskellPackages.callPackage f {};

in

  if pkgs.lib.inNixShell then drv.env else drv
