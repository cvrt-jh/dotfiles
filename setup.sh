#!/bin/bash

echo "🛠 Setting up environment..."

# Make scripts executable
chmod +x config-shell.sh
chmod +x install-apps.sh

# Optional: run setup steps right away
read -r -p "Run terminal config now? [Y/n]: " run_config
run_config=${run_config,,}
if [[ ! "$run_config" =~ ^(n|no)$ ]]; then
  ./config-shell.sh
fi

read -r -p "Run app installation now? [Y/n]: " run_apps
run_apps=${run_apps,,}
if [[ ! "$run_apps" =~ ^(n|no)$ ]]; then
  ./install-apps.sh
fi

echo "✅ Setup complete."
