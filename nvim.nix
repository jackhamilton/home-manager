{
  config,
  pkgs,
  pkgs-unstable,
  lib,
  ...
}:
let
  neovim-no-strip = pkgs.neovim-unwrapped.overrideAttrs (old: {
    dontFixup = true;
  });
  nvim-package = if pkgs.stdenv.isDarwin then neovim-no-strip else pkgs.neovim;
  nvim-package-with-parsers = nvim-package.overrideAttrs (old: {
    # the // is a set merge operator
    treesitter-parsers = old.treesitter-parsers // {
      rust = pkgs.tree-sitter-grammars.tree-sitter-rust;
      swift = pkgs.tree-sitter-grammars.tree-sitter-swift;
      toml = pkgs.tree-sitter-grammars.tree-sitter-toml;
      yaml = pkgs.tree-sitter-grammars.tree-sitter-yaml;
    };
  });
in
{
  home.packages = with pkgs; [
    nvim-package-with-parsers
    git
    pkg-config
    fd
    tree-sitter
    rust-analyzer
    nixd
    nixfmt-rfc-style
    lua-language-server
  ];
}
