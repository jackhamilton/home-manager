{
  config,
  pkgs,
  pkgs-unstable,
  lib,
  ...
}:
let
  treesitter-languages = [
    "rust"
    "swift"
    "toml"
    "yaml"
  ];
  selected-treesitter-parsers = lib.getAttrs treesitter-languages pkgs.vimPlugins.nvim-treesitter.parsers;
  selected-treesitter-queries = lib.getAttrs treesitter-languages pkgs.vimPlugins.nvim-treesitter.queries;

  neovim-unwrapped-base =
    if pkgs.stdenv.isDarwin then
      pkgs.neovim-unwrapped.overrideAttrs (_: {
        dontFixup = true;
      })
    else
      pkgs.neovim-unwrapped;
  neovim-unwrapped = neovim-unwrapped-base.overrideAttrs (old: {
    treesitter-parsers =
      old.treesitter-parsers // lib.mapAttrs (_: parser: parser.origGrammar) selected-treesitter-parsers;

    postInstall = ''
      ${old.postInstall or ""}
      mkdir -p "$out/share/nvim/runtime/queries"
    ''
    + lib.concatStrings (
      lib.mapAttrsToList (language: queries: ''
        ln -s \
          ${queries}/queries/${language} \
          "$out/share/nvim/runtime/queries/${language}"
      '') selected-treesitter-queries
    );
  });
  nvim-package =
    if pkgs.stdenv.isDarwin then neovim-unwrapped else pkgs.wrapNeovim neovim-unwrapped { };
in
{
  home.packages = with pkgs; [
    nvim-package
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
