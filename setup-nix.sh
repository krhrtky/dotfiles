#!/bin/sh
set -e

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
NIX_DIR="$SCRIPT_DIR/config/nix"

echo "[info] === Nix Darwin Bootstrap ==="

if ! command -v nix >/dev/null 2>&1; then
  echo "[info] Installing Nix via DeterminateSystems installer..."
  curl --proto '=https' --tlsv1.2 -sSf -L \
    https://install.determinate.systems/nix | sh -s -- install
  echo "[info] Nix installed successfully."
  echo "[info] Please restart your shell and re-run this script."
  exit 0
fi

echo "[info] Nix is available: $(nix --version)"

(
  cd "$NIX_DIR"
  if ! git ls-files --error-unmatch flake.nix >/dev/null 2>&1; then
    echo "[info] Adding Nix config files to git tracking..."
    git add flake.nix flake.lock hosts/ home/ homebrew.nix
  fi
)

for f in /etc/bashrc /etc/zshenv; do
  if [ -f "$f" ] && [ ! -L "$f" ] && ! grep -q "nix-darwin" "$f" 2>/dev/null; then
    echo "[info] Renaming $f to ${f}.before-nix-darwin"
    sudo mv "$f" "${f}.before-nix-darwin"
  fi
done

CURRENT_HOST=$(scutil --get LocalHostName)

if ! command -v darwin-rebuild >/dev/null 2>&1; then
  echo "[info] Initial nix-darwin build (requires sudo for system activation)..."
  sudo env NIX_HOST="$CURRENT_HOST" \
    nix run nix-darwin --extra-experimental-features "nix-command flakes" \
    -- switch --impure --flake "$NIX_DIR"
else
  echo "[info] Rebuilding nix-darwin configuration..."
  sudo env NIX_HOST="$CURRENT_HOST" \
    darwin-rebuild switch --impure --flake "$NIX_DIR"
fi

echo "[info] === Setup Complete ==="
echo "[info] Please restart your shell for all changes to take effect."
