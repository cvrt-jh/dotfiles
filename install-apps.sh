#!/bin/bash

echo "📦 Installing apps with Homebrew..."

# Make sure Homebrew is available
if ! command -v brew &>/dev/null; then
  echo "❌ Homebrew is not installed. Run config-shell.sh first."
  exit 1
fi

# Update & upgrade
brew update
brew upgrade

# Install GUI apps
brew install --cask google-chrome
brew install --cask slack
brew install --cask discord
brew install --cask wezterm
brew install --cask 1password
brew install --cask logi-options-plus

# Install CLI tools
brew install 1password-cli

echo "✅ App installation complete."
