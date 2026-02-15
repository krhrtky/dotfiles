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
      let user = builtins.getEnv "USER";
      in if user != "" then user
        else abort "Could not determine username. Run without sudo and with --impure flag.";
    homeDirectory = "/Users/${username}";
    dotfilesDir = "${homeDirectory}/dotfiles";
    hostname =
      let h = builtins.getEnv "HOST";
      in if h != "" then h
        else abort "Could not determine hostname. Run without sudo and with --impure flag.";
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
