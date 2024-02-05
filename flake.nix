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
            # optparse-applicative = "0.18.1.0"
          };

          devShell = {
            hlsCheck.enable = false;
          };
        };

        treefmt.config = {
          projectRootFile = "flake.nix";

          programs.fourmolu = {
            enable = true;
            package = config.fourmolu.wrapper;
          };

          programs.nixpkgs-fmt.enable = true;
          programs.cabal-fmt.enable = true;
          programs.hlint.enable = true;
        };

        fourmolu.settings = {
          indentation = 2;
          comma-style = "leading";
          record-brace-space = true;
          indent-wheres = true;
          import-export-style = "diff-friendly";
          respectful = true;
          haddock-style = "multi-line";
          newlines-between-decls = 1;
          extensions = [ "ImportQualifiedPost" ];
        };

        packages.default = self'.packages.hs;
        apps.default = self'.apps.hs;

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
