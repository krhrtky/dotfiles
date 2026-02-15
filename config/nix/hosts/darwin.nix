{ pkgs, ... }: {
  nix.enable = false;

  security.pam.services.sudo_local.touchIdAuth = true;

  users.users."takuya.kurihara" = {
    home = "/Users/takuya.kurihara";
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;

  nixpkgs.hostPlatform = "aarch64-darwin";

  system.primaryUser = "takuya.kurihara";
  system.stateVersion = 5;
}
