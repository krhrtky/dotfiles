{
  description = "macOS dotfiles managed by nix-darwin + home-manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nix-darwin, home-manager, ... }:
  let
    username =
      let
        sudoUser = builtins.getEnv "SUDO_USER";
        user = builtins.getEnv "USER";
      in
        if sudoUser != "" then sudoUser
        else if user != "" then user
        else abort "Could not determine username. Run with --impure flag.";
    homeDirectory = "/Users/${username}";
    dotfilesDir = "${homeDirectory}/dotfiles";
    hostname =
      let
        h = builtins.getEnv "HOST";
        hn = builtins.getEnv "HOSTNAME";
      in
        if h != "" then h
        else if hn != "" then hn
        else abort "Could not determine hostname. Pass HOST env var: sudo HOST=$(scutil --get LocalHostName) darwin-rebuild switch --impure --flake .";
  in {
    darwinConfigurations.${hostname} = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      specialArgs = { inherit username homeDirectory dotfilesDir; };
      modules = [
        ./hosts/darwin.nix
        ./homebrew.nix
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = { inherit username homeDirectory dotfilesDir; };
          home-manager.users.${username} = import ./home;
        }
      ];
    };
  };
}
