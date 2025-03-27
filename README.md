# macOS Dotfiles Setup

This repo contains scripts to set up a new macOS machine with your preferred shell, apps, and config files.

## 🚀 Quickstart

Make sure Git is available (macOS will prompt you if needed):

   ```bash
   xcode-select --install
   ```

Run this one-liner to clone the repo and start setup:

  ```bash
  bash -c \"$(curl -fsSL https://raw.githubusercontent.com/cvrt-jh/dotfiles/main/bootstrap.sh)\"
  ```

Or manually:

  ```bash
  git clone https://github.com/cvrt-jh/dotfiles.git ~/dotfiles
  cd ~/dotfiles
  ./setup.sh
  ```

Follow the prompts to configure the shell and install your apps.

## Scripts

config-shell.sh: sets up Homebrew, Zsh, and shell environment.

install-apps.sh: installs all your GUI and CLI apps.

setup.sh: makes scripts executable and optionally runs the steps.

bootstrap.sh: (used in the one-liner above) clones the repo and launches setup.
