{ ... }: {
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = true;
      cleanup = "none";
    };

    taps = [
      "heroku/brew"
      "mongodb/brew"
    ];

    brews = [
      "heroku/brew/heroku"
      "mongodb/brew/mongodb-community-shell"
      "colima"
      "docker"
      "docker-compose"
      "zplug"
      "ollama"
      "tailscale"
    ];

    casks = [
      "1password"
      "1password-cli"
      "alacritty"
      "alt-tab"
      "amazon-photos"
      "amethyst"
      "arc"
      "cakebrew"
      "chatgpt-atlas"
      "claude"
      "container-use"
      "drawio"
      "figma"
      "font-hackgen"
      "font-hackgen-nerd"
      "gcloud-cli"
      "ghostty@tip"
      "github"
      "google-chrome"
      "google-japanese-ime"
      "iterm2"
      "jetbrains-toolbox"
      "keycastr"
      "kiro"
      "ngrok"
      "notion"
      "obsidian"
      "qmk-toolbox"
      "raycast"
      "rectangle"
      "slack"
      "visual-studio-code"
      "visual-studio-code@insiders"
      "wezterm"
      "zed"
      "zoom"
    ];
  };
}
