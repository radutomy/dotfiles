{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
  };

  # LSP servers, formatters, and linters installed via nix instead of Mason
  home.packages = with pkgs; [
    # base
    tree-sitter
    lua-language-server
    stylua
    shfmt

    # json
    vscode-langservers-extracted
    prettierd

    # kotlin
    kotlin-language-server
    ktlint

    # markdown
    marksman
    markdownlint-cli2

    # toml
    taplo

    # nix
    nil
    nixfmt-rfc-style
    statix
    deadnix
  ];
}
