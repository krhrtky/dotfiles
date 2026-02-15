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
    mkDarwinHost = {
      username,
      system ? "aarch64-darwin",
      hostModules ? [],
      homeModules ? [],
    }:
    let
      homeDirectory = "/Users/${username}";
      dotfilesDir = "${homeDirectory}/dotfiles";
    in
    nix-darwin.lib.darwinSystem {
      inherit system;
      specialArgs = { inherit username homeDirectory dotfilesDir; };
      modules = [
        ./hosts/common.nix
        ./homebrew/common.nix
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = { inherit username homeDirectory dotfilesDir; };
          home-manager.users.${username} = {
            imports = [ ./home ] ++ homeModules;
          };
        }
      ] ++ hostModules;
    };
  in {
    darwinConfigurations."takuyakuriharanoMac-mini" = mkDarwinHost {
      username = "takuya.kurihara";
      hostModules = [
        ./hosts/personal.nix
        ./homebrew/personal.nix
      ];
      homeModules = [ ./home/packages/personal.nix ];
    };
  };
}
