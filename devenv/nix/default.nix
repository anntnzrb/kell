{
  config,
  pkgs,
  ...
}: {
  config = {
    packages = with pkgs; [
      nixd
      alejandra
    ];

    devcontainer = {
      settings.customizations.vscode.extensions = [
        "pinage404.nix-extension-pack"
      ];
    };
  };
}
