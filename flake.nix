{
  description = "annt's Nix template for Haskell projects";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    systems.url = "github:nix-systems/default";
    flake-parts.url = "github:hercules-ci/flake-parts";
    haskell-flake.url = "github:srid/haskell-flake";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    treefmt-nix.inputs.nixpkgs.follows = "nixpkgs";
    fourmolu-nix.url = "github:jedimahdi/fourmolu-nix";
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = import inputs.systems;

      imports = with inputs; [
        haskell-flake.flakeModule
        treefmt-nix.flakeModule
        fourmolu-nix.flakeModule
      ];
      perSystem = { self', system, lib, config, pkgs, ... }: {
        haskellProjects.default = {
          autoWire = [ "packages" "apps" "checks" ];

          packages = {
            # optparse-applicative.source = "0.18.1.0" # hackage
          };

          devShell = {
            hlsCheck.enable = false;
          };
        };

        treefmt.config = {
          projectRootFile = "flake.nix";
          programs = {
            nixpkgs-fmt.enable = true;
            cabal-fmt.enable = true;
            hlint.enable = true;
            fourmolu = {
              enable = true;
              package = config.fourmolu.wrapper;
            };
          };
        };

        fourmolu.settings = {
          indentation = 2;
          column-limit = 80;
          function-arrows = "trailing";
          comma-style = "leading";
          record-brace-space = true;
          indent-wheres = true;
          import-export-style = "diff-friendly";
          respectful = false;
          haddock-style = "multi-line-compact";
          newlines-between-decls = 1;
          extensions = [ "ImportQualifiedPost" ];
        };

        packages.default = self'.packages.kell;
        apps.default = self'.apps.kell;

        # -- devshell
        devShells.default = pkgs.mkShell {
          inputsFrom = with config; [
            haskellProjects.default.outputs.devShell
            treefmt.build.devShell
          ];

          nativeBuildInputs = with pkgs; [
            just
          ];
        };
      };
    };
}
