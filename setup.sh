#!/bin/bash

echo "🛠 Setting up environment..."

# Make scripts executable
chmod +x config-shell.sh
chmod +x install-apps.sh

# Check configuration status
SHELL_CONFIGURED=false
if [ -f "$HOME/.cvrt_shell_configured" ]; then
  SHELL_CONFIGURED=true
  echo "✅ Shell already configured. Skipping shell setup."
else
  echo "🔧 Configuring shell environment..."
  ./config-shell.sh
  echo "✅ Shell configuration completed."
fi

# Always run app install (idempotent)
echo "📦 Installing applications..."
./install-apps.sh

echo "🎉 Setup complete."
echo "🔄 Please restart your terminal for all changes to take effect."

exit 0
