#!/bin/bash

echo "🛠 Setting up environment..."

# Make scripts executable
chmod +x config-shell.sh
chmod +x install-apps.sh

# Only run shell config if not already done
if [ ! -f "$HOME/.cvrt_shell_configured" ]; then
  ./config-shell.sh
else
  echo "✅ Shell already configured. Skipping shell setup."
fi

# Always run app install (idempotent)
./install-apps.sh

echo "🎉 Setup complete."
