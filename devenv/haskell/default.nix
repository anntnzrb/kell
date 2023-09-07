{
  config,
  pkgs,
  ...
}: {
  config = {
    languages.haskell = {
      enable = true;
      package = pkgs.haskell.compiler.ghc94;
    };

    packages = with pkgs; [
      haskellPackages.hlint
    ];

    devcontainer = {
      settings.customizations.vscode.extensions = [
        "mogeko.haskell-extension-pack"
      ];
    };
  };
}
