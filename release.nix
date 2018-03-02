{ hydra-testSrc ? { outPath = ./.; revCount = 1234; shortRev = "abcdef"; },
  officialRelease ? false }:

let
  pkgs = import <nixpkgs> { };

  jobs = rec {
    tarball =
      pkgs.releaseTools.sourceTarball rec {
        name = "hydra-test-tarball";
        version = builtins.readFile ./version + (if officialRelease then "" else "pre${toString hydra-testSrc.revCount}_${hydra-testSrc.shortRev}");
        versionSuffix = ""; # obsolete
        src = hydra-testSrc;
      };

    release = pkgs.releaseTools.aggregate
      { name = "hydra-test-${tarball.version}";
        constituents =
          [ tarball
          ];
        meta.description = "Release-critical builds";
      };

  };

in jobs
