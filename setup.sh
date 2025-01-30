#!/bin/bash

echo "Starting setup..."

# Install Homebrew if not installed
if ! command -v brew &> /dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add Homebrew to PATH for Apple Silicon
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zshrc
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Install basic tools
echo "Installing basic tools..."
brew install git neovim
brew install --cask wezterm
brew install font-meslo-lg-nerd-font

# Create symbolic links for git
echo "Creating git symlinks..."
ln -sf ~/dotfiles/.gitconfig ~/.gitconfig
ln -sf ~/dotfiles/.gitignore_global ~/.gitignore_global

# Setting up config directories
echo "Setting up configurations..."
mkdir -p ~/.config

# Create symlinks for configs
ln -sf ~/dotfiles/.config/nvim ~/.config/nvim
ln -sf ~/dotfiles/.config/wezterm ~/.config/wezterm

echo "Basic setup complete!"
