{ config, lib, pkgs, pkgs-unstable, ... }:
{
  home.packages =
    with pkgs;
    [
      difftastic
    ]
    ++ (with pkgs-unstable; [
      mergiraf
    ]);

  programs.git = {
    enable = true;
    userName = "jackhamilton";
    userEmail = "jackham800@gmail.com";
    extraConfig = {
      merge.mergiraf = {
        name = "mergiraf";
        driver = "mergiraf merge --git %O %A %B -s %S -x %X -y %Y -p %P -l %L";
      };
      core.attributesfile = "${config.home.homeDirectory}/.config/git/attributes";
      diff.external = "difft";
      credential."https://github.com".helper = "!${pkgs.github-cli}/bin/gh auth git-credential";
      credential."https://gist.github.com".helper = "!${pkgs.github-cli}/bin/gh auth git-credential";
    };
  };

  home.file.".config/git/attributes".text = ''
    *.java merge=mergiraf
    *.properties merge=mergiraf
    *.kt merge=mergiraf
    *.rs merge=mergiraf
    *.go merge=mergiraf
    go.mod merge=mergiraf
    go.sum merge=mergiraf
    *.ini merge=mergiraf
    *.js merge=mergiraf
    *.jsx merge=mergiraf
    *.mjs merge=mergiraf
    *.json merge=mergiraf
    *.yml merge=mergiraf
    *.yaml merge=mergiraf
    pyproject.toml merge=mergiraf
    *.toml merge=mergiraf
    *.html merge=mergiraf
    *.htm merge=mergiraf
    *.xhtml merge=mergiraf
    *.xml merge=mergiraf
    *.c merge=mergiraf
    *.h merge=mergiraf
    *.cc merge=mergiraf
    *.hh merge=mergiraf
    *.cpp merge=mergiraf
    *.hpp merge=mergiraf
    *.cxx merge=mergiraf
    *.hxx merge=mergiraf
    *.c++ merge=mergiraf
    *.h++ merge=mergiraf
    *.mpp merge=mergiraf
    *.cppm merge=mergiraf
    *.ixx merge=mergiraf
    *.tcc merge=mergiraf
    *.cs merge=mergiraf
    *.dart merge=mergiraf
    *.dts merge=mergiraf
    *.scala merge=mergiraf
    *.sbt merge=mergiraf
    *.ts merge=mergiraf
    *.tsx merge=mergiraf
    *.py merge=mergiraf
    *.php merge=mergiraf
    *.phtml merge=mergiraf
    *.sol merge=mergiraf
    *.lua merge=mergiraf
    *.rb merge=mergiraf
    *.ex merge=mergiraf
    *.exs merge=mergiraf
    *.nix merge=mergiraf
    *.sv merge=mergiraf
    *.svh merge=mergiraf
    *.md merge=mergiraf
    *.hcl merge=mergiraf
    *.tf merge=mergiraf
    *.tfvars merge=mergiraf
    *.ml merge=mergiraf
    *.mli merge=mergiraf
    *.hs merge=mergiraf
    *.mk merge=mergiraf
    Makefile merge=mergiraf
    GNUmakefile merge=mergiraf
    *.bzl merge=mergiraf
    *.bazel merge=mergiraf
    BUILD merge=mergiraf
    WORKSPACE merge=mergiraf
    *.cmake merge=mergiraf
    *.swift merge=mergiraf
    CMakeLists.txt merge=mergiraf
  '';
}
