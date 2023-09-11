{ pkgs, ... }:

{
  # https://devenv.sh/packages/
  packages = [ pkgs.git pkgs.kubectl ];

  # https://devenv.sh/languages/
  languages.terraform.enable = true;
  languages.go.enable = true;
}
