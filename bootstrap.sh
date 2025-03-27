#!/bin/bash

# Bootstrap script to clone dotfiles repo and run setup

REPO_URL="https://github.com/cvrt-jh/dotfiles.git"
TARGET_DIR="$HOME/dotfiles"

# Ensure Git is installed
if ! command -v git &> /dev/null; then
  echo "🔧 Git is not installed. Installing Xcode Command Line Tools..."
  xcode-select --install
  echo "⏳ Please install Git and rerun this script."
  exit 1
fi

# Clone the repo
if [ -d "$TARGET_DIR" ]; then
  echo "📁 Directory $TARGET_DIR already exists. Skipping clone."
else
  echo "📥 Cloning dotfiles repo..."
  git clone "$REPO_URL" "$TARGET_DIR"
fi

cd "$TARGET_DIR" || exit

# Run the setup
chmod +x setup.sh
./setup.sh
