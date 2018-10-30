{ nixpkgs ? import <nixpkgs> {}, compiler ? "default", doBenchmark ? false }:

let

  inherit (nixpkgs) pkgs;

  f = { mkDerivation, async, base, deepseq, directory, filepath
      , free, kan-extensions, mtl, process, split, stdenv, tasty
      , tasty-hunit, tasty-quickcheck, template-haskell, unix
      }:
      mkDerivation {
        pname = "hssh";
        version = "0.1.0.0";
        src = ./.;
        libraryHaskellDepends = [
          async base deepseq directory filepath free kan-extensions mtl
          process split template-haskell unix
        ];
        testHaskellDepends = [ base tasty tasty-hunit tasty-quickcheck ];
        description = "Simple shell scripting from Haskell";
        license = stdenv.lib.licenses.bsd3;
      };

  haskellPackages = if compiler == "default"
                       then pkgs.haskellPackages
                       else pkgs.haskell.packages.${compiler};

  variant = if doBenchmark then pkgs.haskell.lib.doBenchmark else pkgs.lib.id;

  drv = variant (haskellPackages.callPackage f {});

in

  if pkgs.lib.inNixShell then drv.env else drv