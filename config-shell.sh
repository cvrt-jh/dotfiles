#!/bin/bash

echo "🔧 Configuring Zsh and Homebrew..."
echo "📝 Debug: Current directory is $(pwd)"
echo "📝 Debug: Running as user $(whoami)"

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

# Get correct Homebrew prefix with error handling
if command -v /opt/homebrew/bin/brew &>/dev/null; then
  BREW_PREFIX=$(/opt/homebrew/bin/brew --prefix)
  echo "📝 Debug: Using Homebrew from /opt/homebrew"
elif command -v /usr/local/bin/brew &>/dev/null; then
  BREW_PREFIX=$(/usr/local/bin/brew --prefix)
  echo "📝 Debug: Using Homebrew from /usr/local"
else
  echo "📝 Debug: Trying to locate brew command..."
  BREW_PATH=$(command -v brew)
  echo "📝 Debug: Brew path is: $BREW_PATH"
  if [ -n "$BREW_PATH" ]; then
    BREW_PREFIX=$($BREW_PATH --prefix)
  else
    echo "❌ Error: Homebrew is not in PATH. Cannot continue."
    exit 1
  fi
fi

echo "📝 Debug: Homebrew prefix is $BREW_PREFIX"

# Add Homebrew to ~/.zshrc if missing
ZSHRC_PATH="$HOME/.zshrc"
if [ ! -f "$ZSHRC_PATH" ]; then
  echo "📝 Debug: Creating .zshrc file"
  touch "$ZSHRC_PATH"
fi

if ! grep -q 'eval "\$('"$BREW_PREFIX"'/bin/brew shellenv)"' "$ZSHRC_PATH"; then
  echo "➕ Adding Homebrew to PATH in ~/.zshrc"
  echo 'eval "$('"$BREW_PREFIX"'/bin/brew shellenv)"' >> "$ZSHRC_PATH"
else
  echo "📝 Debug: Homebrew already in .zshrc"
fi

# Apply to current session
echo "📝 Debug: Attempting to eval brew shellenv"
eval "$("$BREW_PREFIX"/bin/brew shellenv)"

# Set Zsh as default shell if needed
if [ "$SHELL" != "/bin/zsh" ]; then
  echo "💻 Changing default shell to Zsh..."
  chsh -s /bin/zsh
else
  echo "✅ Zsh is already the default shell."
fi

# Create marker so setup.sh doesn't re-run this
echo "📝 Debug: Creating marker file at $HOME/.cvrt_shell_configured"
touch "$HOME/.cvrt_shell_configured"

if [ -f "$HOME/.cvrt_shell_configured" ]; then
  echo "✅ Marker file created successfully."
else
  echo "❌ Failed to create marker file."
fi

echo "✅ Shell configuration complete!"
echo "🔄 Please restart your terminal after setup is complete for changes to take effect."

# Don't automatically restart the shell - let the user decide when to restart
# This avoids the loop issue
exit 0
