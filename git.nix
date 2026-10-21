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
    version = "0.15.2";
    src = pkgs.fetchFromGitHub {
      owner = "jackhamilton-grindr";
      repo = "mergiraf-swift";
      rev = "8b4fbf252b18fb249f1e378b049385130a9f1fce";
      hash = "sha256-wpfynuZn5Cd5rgGGNZZhOHzCbD3tdVo5HTE+hDemFi0=";
    };
    cargoHash = "sha256-O/B0rA8DkGoM8eMnnZIMOHj79v3SmqPKNAgPSIhZLpA=";
    nativeBuildInputs = [ pkgs.git ];
  };
  mergiraf-local = if pkgs.stdenv.isDarwin then mergiraf-swift else pkgs-unstable.mergiraf;

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
  jjEmail = "jackham800@gmail.com";
  jujutsuWithGitHubIdentity = pkgs.writeShellScriptBin "jj" ''
    args=("$@")
    is_git_push=false
    for ((index = 0; index + 1 < ''${#args[@]}; index++)); do
      if [[ "''${args[index]}" == git && "''${args[index + 1]}" == push ]]; then
        is_git_push=true
        break
      fi
    done

    if [[ "$is_git_push" == true && ! " ''${args[*]} " =~ [[:space:]]--help[[:space:]] ]]; then
      repo_path="$PWD"
      remote=""
      for ((index = 0; index < ''${#args[@]}; index++)); do
        case "''${args[index]}" in
          -R|--repository)
            ((index += 1))
            repo_path="''${args[index]}"
            ;;
          --repository=*)
            repo_path="''${args[index]#*=}"
            ;;
          --remote)
            ((index += 1))
            remote="''${args[index]}"
            ;;
          --remote=*)
            remote="''${args[index]#*=}"
            ;;
        esac
      done

      repo_root="$(${pkgs.git}/bin/git -C "$repo_path" rev-parse --show-toplevel 2>/dev/null)" || repo_root=""
      if [[ -n "$repo_root" ]]; then
        if [[ -z "$remote" ]]; then
          remote="$("${pkgs-unstable.jujutsu}/bin/jj" config get git.push 2>/dev/null || true)"
          if ! "${pkgs.git}/bin/git" -C "$repo_root" remote get-url "$remote" >/dev/null 2>&1; then
            remote=""
          fi
        fi
        if [[ -z "$remote" ]]; then
          if "${pkgs.git}/bin/git" -C "$repo_root" remote get-url origin >/dev/null 2>&1; then
            remote=origin
          else
            remote="$("${pkgs.git}/bin/git" -C "$repo_root" remote | head -n 1)"
          fi
        fi
        remote_url="$("${pkgs.git}/bin/git" -C "$repo_root" remote get-url "$remote" 2>/dev/null || true)"

        for hook_name in pre-commit pre-push; do
          hook_path="$("${pkgs.git}/bin/git" -C "$repo_root" rev-parse --path-format=absolute --git-path "hooks/$hook_name")"
          if [[ -x "$hook_path" ]]; then
            if [[ "$hook_name" == pre-push ]]; then
              (cd "$repo_root" && "$hook_path" "$remote" "$remote_url" </dev/null) || exit $?
            else
              (cd "$repo_root" && "$hook_path") || exit $?
            fi
          fi
        done
      fi
    fi

    config_args=()
    gh_hosts_file="''${GH_CONFIG_DIR:-''${XDG_CONFIG_HOME:-${config.home.homeDirectory}/.config}/gh}/hosts.yml"
    github_login="$(${pkgs.gawk}/bin/awk '
      /^github.com:/ { in_github = 1; next }
      in_github && /^[^[:space:]]/ { exit }
      in_github && /^[[:space:]]{4}user:/ { print $2; exit }
    ' "$gh_hosts_file" 2>/dev/null)"

    case "$github_login" in
      jhamilton|jhamilton-superfile)
        config_args+=(--config "user.name=jhamilton")
        config_args+=(--config "user.email=jhamilton@superfile.com")
        ;;
      jackhamilton)
        config_args+=(--config "user.name=jackhamilton")
        config_args+=(--config "user.email=jackham800@gmail.com")
        ;;
    esac

    exec ${pkgs-unstable.jujutsu}/bin/jj "''${config_args[@]}" "$@"
  '';
in
{
  home.packages =
    with pkgs;
    [
      lazyjj
      jj-fzf
      difftastic
      mergiraf-local
    ];

  programs.jujutsu = {
    enable = true;
    package = jujutsuWithGitHubIdentity;
    #package = jujutsu-lfs;
    settings = {
      user = {
        name = "jackhamilton";
        email = jjEmail;
      };
      ui = {
        diff-formatter = [ "difft" "--color=always" "$left" "$right" ];
        diff-editor = [ "nvim" "-c" "DiffEditor $left $right $output" ];
        merge-editor = "diffconflicts";
      };
      revset-aliases = {
        pr = "ancestors(@, main)";
        "active(rev)" = "(ancestors(rev) | descendants(rev)) ~ immutable()";
      };
      revsets = {
        # Full connected segment between the current workspace and trunk.
        # This keeps jj from inserting elided nodes inside the active stack.
        log =
          "connected(@ | trunk() | fork_point(@ | trunk()))"
          + " | (bookmarks() & mine())"
          # workspaces with uncommitted changes (parked workspaces stay hidden)
          + " | (working_copies() & ~empty())"
          # my unpushed stacks: my commits not on trunk, not under any local or remote bookmark,
          # and not workspace-tip empties
          + " | (mine() ~ working_copies() ~ ::trunk() ~ ::bookmarks() ~ ::remote_bookmarks())"
          # fork points of @ and my bookmarks with trunk so divergence is visible in the graph
          + " | roots(trunk()..(@ | (bookmarks() & mine())))-";
      };
      aliases = {
        move-unpushed = [
          "util" "exec" "--" "sh" "-c"
          ''
            current_bookmarks=$(jj bookmark list -r @ -T 'if(!self.remote(), name ++ "\n")')
            parent_bookmarks=$(jj bookmark list -r @- -T 'if(!self.remote(), name ++ "\n")')
            count_bookmarks() {
              printf '%s\n' "$1" | sed '/^$/d' | wc -l | tr -d ' '
            }

            current_count=$(count_bookmarks "$current_bookmarks")
            parent_count=$(count_bookmarks "$parent_bookmarks")
            if [ "$current_count" -eq 1 ]; then
              bookmark=$current_bookmarks
              create_child=true
            elif [ "$current_count" -gt 1 ]; then
              echo "Expected at most one local bookmark on @; found $current_count." >&2
              exit 1
            elif [ "$parent_count" -eq 1 ]; then
              bookmark=$parent_bookmarks
              create_child=false
            else
              echo "Expected one local bookmark on @ or @-; found $parent_count on @-." >&2
              echo "Move the changes manually with: jj restore --from <bookmark>@<remote> --into @- --restore-descendants" >&2
              exit 1
            fi

            remote_bookmark=""
            for remote in $(jj git remote list | awk '{print $1}'); do
              if jj log -r "$bookmark@$remote" -T 'change_id' >/dev/null 2>&1; then
                if [ -n "$remote_bookmark" ]; then
                  echo "More than one remote bookmark matches $bookmark; specify one manually." >&2
                  exit 1
                fi
                remote_bookmark="$bookmark@$remote"
              fi
            done

            if [ -z "$remote_bookmark" ]; then
              echo "No tracked remote bookmark found for $bookmark." >&2
              exit 1
            fi

            printf 'Moving the difference from %s into the working-copy change.\n' "$remote_bookmark"
            if [ "$create_child" = true ]; then
              jj new || exit $?
            fi
            jj restore --from "$remote_bookmark" --into @- --restore-descendants
          ''
        ];
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
            jj abandon 'mine() ~ ::(main | bookmarks() | remote_bookmarks() | working_copies())' 2>&1
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
      merge-tools.diffconflicts = {
        program = "nvim";
        merge-args = [
            "-c" "let g:jj_diffconflicts_marker_length=$marker_length"
            "-c" "JJDiffConflicts!" "$output" "$base" "$left" "$right"
        ];
        merge-tool-edits-conflict-markers = true;
      };
    };
  };

  home.sessionVariables = lib.mkIf pkgs.stdenv.isDarwin {
    JJ_CONFIG = "${config.home.homeDirectory}/Library/Application Support/jj/config.toml";
  };

  programs.git = {
    enable = true;
    lfs.enable = true;
    ignores = [
      ".direnv/"
      "node_modules/"
      ".DS_Store"
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
      "*.pbxproj merge=mergiraf"
    ];
    settings = {
      user = {
        name = "Jack Hamilton";
        email = if isDarwin then "jhamilton@superfile.com" else "jackham800@gmail.com";
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
      # Clear the system keychain helper so GitHub HTTPS requests use the
      # account selected by `gh auth switch`.
      credential.helper = "";
      credential."https://github.com".helper = "!${pkgs.github-cli}/bin/gh auth git-credential";
      credential."https://gist.github.com".helper = "!${pkgs.github-cli}/bin/gh auth git-credential";
    };
  };

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings = {
      "*" = {
        ForwardAgent = false;
        AddKeysToAgent = "no";
        Compression = false;
        ServerAliveInterval = 0;
        ServerAliveCountMax = 3;
        HashKnownHosts = false;
        UserKnownHostsFile = "~/.ssh/known_hosts";
        ControlMaster = "no";
        ControlPath = "~/.ssh/master-%r@%n:%p";
        ControlPersist = "no";
      };
      "github.com" = {
        HostName = "github.com";
        User = "git";
        IdentityFile = [ "${config.home.homeDirectory}/.ssh/id_ed25519" ];
        IdentitiesOnly = true;
      };
    };
  };
}
