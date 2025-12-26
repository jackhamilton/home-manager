{ config, lib, pkgs, pkgs-unstable, ... }:
{
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
}
