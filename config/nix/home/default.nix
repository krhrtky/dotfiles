{ pkgs, lib, username, homeDirectory, ... }: {
  imports = [
    ./packages/common.nix
    ./symlinks.nix
  ];

  home.username = username;
  home.homeDirectory = homeDirectory;
  home.stateVersion = "24.11";

  programs.home-manager.enable = true;
}
