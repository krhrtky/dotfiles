{ pkgs, ... }: {
  home.packages = with pkgs; [
    ripgrep
    eza
    fzf
    jq
    tree
    wget
    direnv
    starship
    peco
    httpie

    git
    gh
    ghq
    gibo
    gitflow
    hub
    tig

    neovim
    vim
    universal-ctags

    tmux
    zellij

    awscli2
    gcc
    gnused
    findutils
    gnugrep
    graphviz
    imagemagick

    mise
    pinentry_mac
    act
    qemu
  ];
}
