#!/bin/bash

echo "🔧 Configuring Zsh and Homebrew..."

# Install Homebrew if it's not installed
if ! command -v brew &>/dev/null; then
  echo "🍺 Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Get correct Homebrew prefix
BREW_PREFIX=$(/opt/homebrew/bin/brew --prefix 2>/dev/null || /usr/local/bin/brew --prefix)

# Add Homebrew to ~/.zshrc if missing
if ! grep -q 'eval "\$('"$BREW_PREFIX"'/bin/brew shellenv)"' ~/.zshrc; then
  echo "➕ Adding Homebrew to PATH in ~/.zshrc"
  echo 'eval "$('"$BREW_PREFIX"'/bin/brew shellenv)"' >> ~/.zshrc
fi

# Apply to current session
eval "$("$BREW_PREFIX"/bin/brew shellenv)"

# Set Zsh as default shell
if [ "$SHELL" != "/bin/zsh" ]; then
  echo "💻 Changing default shell to Zsh..."
  chsh -s /bin/zsh
else
  echo "✅ Zsh is already the default shell."
fi

echo ""
read -r -p "Do you want to restart the shell into Zsh now? [Y/n] (just press Enter for Yes): " response
response=${response,,} # lowercase
if [[ "$response" =~ ^(n|no)$ ]]; then
  echo "👋 Okay! Restart your terminal later to apply changes."
else
  echo "🔄 Restarting shell into Zsh..."
  exec zsh
fi
