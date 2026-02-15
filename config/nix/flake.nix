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
    username = "takuya.kurihara";
    homeDirectory = "/Users/${username}";
    dotfilesDir = "${homeDirectory}/dotfiles";
    hostname = "takuyakuriharanoMac-mini";
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
