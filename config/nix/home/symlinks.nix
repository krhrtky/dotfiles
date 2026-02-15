{ config, lib, dotfilesDir, ... }: {
  home.file.".zshrc".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/config/zsh/.zshrc";

  home.file.".tmux.conf".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/config/tmux/.tmux.conf";

  home.file.".config/nvim".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/config/nvim";

  home.file.".alacritty.toml".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/config/alacritty/alacritty.toml";

  home.file.".powerline-shell.json".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/config/powerline-shell/.powerline-shell.json";
}
