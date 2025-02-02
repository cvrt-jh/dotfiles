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

# Install Yazi and its dependencies
echo "Installing Yazi and dependencies..."
brew install yazi ffmpegthumbnailer ffmpeg sevenzip jq poppler fd ripgrep fzf zoxide imagemagick font-symbols-only-nerd-font

# Install Aerospace
echo "Installing Aerospace..."
brew install --cask nikitabobko/tap/aerospace

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
ln -sf ~/dotfiles/.config/yazi ~/.config/yazi
ln -sf ~/dotfiles/.config/aerospace ~/.config/aerospace

# Add Yazi function to zshrc if it doesn't exist
if ! grep -q "function y()" ~/.zshrc; then
    echo "Adding Yazi shell wrapper to zshrc..."
    cat >> ~/.zshrc << 'EOL'

# Yazi shell wrapper
function y() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
    yazi "$@" --cwd-file="$tmp"
    if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
        builtin cd -- "$cwd"
    fi
    rm -f -- "$tmp"
}
EOL
fi

# Set nvim as default editor in zshrc if not already set
if ! grep -q "export EDITOR=" ~/.zshrc; then
    echo "Setting Neovim as default editor..."
    echo 'export EDITOR=nvim' >> ~/.zshrc
fi

# Install Yazi theme
echo "Installing Yazi theme..."
mkdir -p ~/.config/yazi/flavors
ya pack -a yazi-rs/flavors:catppuccin-mocha

# Source zshrc to apply changes
echo "Applying zsh changes..."
source ~/.zshrc

echo "Setup complete! Please:"
echo "1. Start Aerospace from Spotlight (Cmd+Space)"
echo "2. Go to System Settings -> Desktop & Dock -> Mission Control"
echo "3. Enable 'Group Windows By Application' for better Mission Control experience"
