{
  config,
  lib,
  pkgs,
  pkgs-unstable,
  ...
}:
let
  mergiraf-swift = pkgs.rustPlatform.buildRustPackage {
    pname = "mergiraf";
    version = "0.15.0-swift";
    src = pkgs.fetchFromGitHub {
      owner = "jackhamilton-grindr";
      repo = "mergiraf-swift";
      rev = "abecc9c3c7aa73343e4dab8371bc03b182482cc0";
      hash = "sha256-a3CN4tdKsJCOosAjXvDN7/8m6kbAUX6E4Bq0d2IMfFk=";
    };
    cargoHash = "sha256-xYOnZKSfdVsVlV+lPk0+gXMoZke6sQX3S6DLArQGuxI=";
    nativeBuildInputs = [ pkgs.git ];
  };
  mergiraf = if pkgs.stdenv.isDarwin then mergiraf-swift else pkgs-unstable.mergiraf;

  # TODO: Remove once jj-vcs/jj#9068 merges and lands in nixpkgs.
  # Adds `git.ignore-filters` config to fix phantom LFS diffs in `jj status`.
  # Cleanup: delete this block, change `package = jujutsu-lfs` to `package = pkgs.jujutsu`,
  # and remove the `git.ignore-filters` setting below (it will be default).
  jujutsu-lfs = pkgs.rustPlatform.buildRustPackage {
    pname = "jujutsu-lfs";
    version = "0.40.0-lfs";
    src = pkgs.fetchFromGitHub {
      owner = "kejadlen";
      repo = "jj";
      rev = "c08c0fd6de077c65d338a65f9e2848c7d17c68fd";
      hash = "sha256-47rtJEUqP46iLpPoiDfCKTXfDUBuOhWGBYGGrlwRyxk=";
    };
    cargoHash = "sha256-Vf5+yh/uhO3hXcOmogGATC04jJznGNxVQ0yyt75Kjg8=";
    cargoBuildFlags = [ "--bin" "jj" ];
    nativeBuildInputs = with pkgs; [ git openssh gnupg installShellFiles pkg-config ];
    buildInputs = lib.optionals pkgs.stdenv.isDarwin [
      pkgs.apple-sdk_15
    ];
    useNextest = true;
    LIBSSH2_SYS_USE_PKG_CONFIG = 1;
    postInstall = ''
      $out/bin/jj util install-man-pages $out/share/man
      installShellCompletion --cmd jj \
        --bash <($out/bin/jj util completion bash) \
        --zsh <($out/bin/jj util completion zsh) \
        --fish <($out/bin/jj util completion fish)
    '';
    doCheck = false;
  };

  isDarwin = pkgs.stdenv.isDarwin;
  jjEmail = if isDarwin then "jack.hamilton@grindr.com" else "jackham800@gmail.com";
in
{
  home.packages =
    with pkgs;
    [
      lazyjj
      difftastic
      mergiraf
      gh-dash
    ];

  programs.jujutsu = {
    enable = true;
    package = jujutsu-lfs;
    settings = {
      user = {
        name = "Jack Hamilton";
        email = jjEmail;
      };
      ui = {
        diff-formatter = [ "difft" "--color=always" "$left" "$right" ];
        merge-editor = "ec";
      };
      aliases = {
        tidy = [
          "util" "exec" "--" "sh" "-c"
          ''
            remote=$(jj git remote list 2>/dev/null | head -1 | awk '{print $2}' | sed -n 's|.*github\.com[:/]\(.*\)\.git|\1|p')
            # Bookmarks whose exact commit is in main
            merged=$(jj bookmark list -r '::main' -T 'if(!self.remote() && name != "main", name ++ "\n")' 2>/dev/null)
            # Bookmarks that are locally deleted
            deleted=$(jj bookmark list -T 'if(!self.remote() && !self.present() && name != "main", name ++ "\n")' 2>/dev/null)
            # Bookmarks whose PR was squash-merged on GitHub (remote still exists but branch was merged)
            squashed=""
            if [ -n "$remote" ]; then
              for b in $(jj bookmark list -T 'if(!self.remote() && name != "main", name ++ "\n")' 2>/dev/null); do
                pr_state=$(gh pr list --repo "$remote" --state merged --head "$b" --json number --jq 'length' 2>/dev/null)
                if [ "$pr_state" != "" ] && [ "$pr_state" -gt 0 ] 2>/dev/null; then
                  squashed=$(printf '%s\n%s' "$squashed" "$b")
                fi
              done
            fi
            all=$(printf '%s\n%s\n%s' "$merged" "$deleted" "$squashed" | sort -u | sed '/^$/d')
            if [ -z "$all" ]; then
              echo "No stale bookmarks to clean up."
            else
              echo "$all" | while read -r b; do
                jj bookmark forget "$b" 2>&1
              done
            fi
          ''
        ];
      };
      git = {
        ignore-filters = [ "lfs" ];
      };
      merge-tools.mergiraf = {
        program = "mergiraf";
        merge-args = [ "merge" "$base" "$left" "$right" "-o" "$output" ];
        merge-tool-edits-conflict-markers = true;
      };
      merge-tools.ec = {
        merge-args = [ "$base" "$left" "$right" "$output" ];
      };
    };
  };

  programs.git = {
    enable = true;
    lfs.enable = true;
    ignores = [
      ".direnv/"
      "node_modules/"
    ];
    attributes = [
      "*.java merge=mergiraf"
      "*.properties merge=mergiraf"
      "*.kt merge=mergiraf"
      "*.rs merge=mergiraf"
      "*.go merge=mergiraf"
      "go.mod merge=mergiraf"
      "go.sum merge=mergiraf"
      "*.ini merge=mergiraf"
      "*.js merge=mergiraf"
      "*.jsx merge=mergiraf"
      "*.mjs merge=mergiraf"
      "*.json merge=mergiraf"
      "*.yml merge=mergiraf"
      "*.yaml merge=mergiraf"
      "pyproject.toml merge=mergiraf"
      "*.toml merge=mergiraf"
      "*.html merge=mergiraf"
      "*.htm merge=mergiraf"
      "*.xhtml merge=mergiraf"
      "*.xml merge=mergiraf"
      "*.c merge=mergiraf"
      "*.h merge=mergiraf"
      "*.cc merge=mergiraf"
      "*.hh merge=mergiraf"
      "*.cpp merge=mergiraf"
      "*.hpp merge=mergiraf"
      "*.cxx merge=mergiraf"
      "*.hxx merge=mergiraf"
      "*.c++ merge=mergiraf"
      "*.h++ merge=mergiraf"
      "*.mpp merge=mergiraf"
      "*.cppm merge=mergiraf"
      "*.ixx merge=mergiraf"
      "*.tcc merge=mergiraf"
      "*.cs merge=mergiraf"
      "*.dart merge=mergiraf"
      "*.dts merge=mergiraf"
      "*.scala merge=mergiraf"
      "*.sbt merge=mergiraf"
      "*.ts merge=mergiraf"
      "*.tsx merge=mergiraf"
      "*.py merge=mergiraf"
      "*.php merge=mergiraf"
      "*.phtml merge=mergiraf"
      "*.sol merge=mergiraf"
      "*.lua merge=mergiraf"
      "*.rb merge=mergiraf"
      "*.ex merge=mergiraf"
      "*.exs merge=mergiraf"
      "*.nix merge=mergiraf"
      "*.sv merge=mergiraf"
      "*.svh merge=mergiraf"
      "*.md merge=mergiraf"
      "*.hcl merge=mergiraf"
      "*.tf merge=mergiraf"
      "*.tfvars merge=mergiraf"
      "*.ml merge=mergiraf"
      "*.mli merge=mergiraf"
      "*.hs merge=mergiraf"
      "*.mk merge=mergiraf"
      "Makefile merge=mergiraf"
      "GNUmakefile merge=mergiraf"
      "*.bzl merge=mergiraf"
      "*.bazel merge=mergiraf"
      "BUILD merge=mergiraf"
      "WORKSPACE merge=mergiraf"
      "*.cmake merge=mergiraf"
      "*.swift merge=mergiraf"
      "CMakeLists.txt merge=mergiraf"
    ];
    settings = {
      user = {
        name = "jackhamilton";
        email = "jackham800@gmail.com";
      };
      config = {
        push = {
          autoSetupRemote = true;
        };
      };
      merge = {
          conflictStyle = "diff3";
          mergiraf = {
              name = "mergiraf";
              driver = "mergiraf merge --git %O %A %B -s %S -x %X -y %Y -p %P -l %L";
          };
      };
      diff.external = "difft";
      credential."https://github.com".helper = "!${pkgs.github-cli}/bin/gh auth git-credential";
      credential."https://gist.github.com".helper = "!${pkgs.github-cli}/bin/gh auth git-credential";
    };
  };
}
