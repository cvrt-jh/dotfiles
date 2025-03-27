#!/bin/bash

echo "🔧 Configuring Zsh and Homebrew..."

# Check if already configured
if [ -f "$HOME/.cvrt_shell_configured" ]; then
  echo "⚠️  Shell already configured. Skipping."
  exit 0
fi

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

# Set Zsh as default shell if needed
if [ "$SHELL" != "/bin/zsh" ]; then
  echo "💻 Changing default shell to Zsh..."
  chsh -s /bin/zsh
else
  echo "✅ Zsh is already the default shell."
fi

# Create marker so setup.sh doesn't re-run this
touch "$HOME/.cvrt_shell_configured"

echo "✅ Shell configuration complete!"
echo "🔄 Please restart your terminal after setup is complete for changes to take effect."

# Don't automatically restart the shell - let the user decide when to restart
# This avoids the loop issue
exit 0
