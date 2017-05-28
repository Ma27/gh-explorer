{ nixpkgs ? import <nixpkgs> {}, compiler ? "default" }:

let

  inherit (nixpkgs) pkgs;

  f = { mkDerivation, base, blaze-html, bytestring, http-types
      , monad-logger, persistent, persistent-postgresql
      , persistent-sqlite, persistent-template, resourcet, scotty, stdenv
      , text, time, transformers, wai, wai-extra, wai-middleware-static
      , warp
      }:
      mkDerivation {
        pname = "gh-explorer";
        version = "0.1.0.0";
        src = ./.;
        isLibrary = false;
        isExecutable = true;
        executableHaskellDepends = [
          base blaze-html bytestring http-types monad-logger persistent
          persistent-postgresql persistent-sqlite persistent-template
          resourcet scotty text time transformers wai wai-extra
          wai-middleware-static warp
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
