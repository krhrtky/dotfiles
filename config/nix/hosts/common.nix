{ pkgs, username, homeDirectory, ... }: {
  nix.enable = false;

  security.pam.services.sudo_local.touchIdAuth = true;

  security.sudo.extraConfig = ''
    ${username} ALL=(ALL:ALL) NOPASSWD: /run/current-system/sw/bin/darwin-rebuild
  '';

  users.users.${username} = {
    home = homeDirectory;
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;

  nixpkgs.hostPlatform = "aarch64-darwin";

  system.primaryUser = username;
  system.stateVersion = 5;
}
