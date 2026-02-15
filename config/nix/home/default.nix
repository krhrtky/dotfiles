{ pkgs, lib, ... }: {
  imports = [
    ./packages.nix
    ./symlinks.nix
  ];

  home.username = "takuya.kurihara";
  home.homeDirectory = "/Users/takuya.kurihara";
  home.stateVersion = "24.11";

  programs.home-manager.enable = true;
}
