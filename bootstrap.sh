#!/bin/bash

# Bootstrap script with improved status detection

REPO_URL="https://github.com/cvrt-jh/dotfiles.git"
TARGET_DIR="$HOME/dotfiles"

# Colors for better readability
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Print header
print_header() {
  clear
  echo -e "${BLUE}🚀 dotfiles Setup Menu${NC}"
  echo -e "${BLUE}======================${NC}"
  echo
}

# Check component status with improved detection
check_status() {
  # Debug marker file
  echo -e "Debug: Checking for marker file at $HOME/.cvrt_shell_configured"
  if [ -f "$HOME/.cvrt_shell_configured" ]; then
    echo -e "Debug: Marker file exists"
  else
    echo -e "Debug: Marker file does not exist"
  fi

  # Shell Configuration Status
  SHELL_CONFIGURED=false
  if [ -f "$HOME/.cvrt_shell_configured" ]; then
    SHELL_CONFIGURED=true
  fi

  # Homebrew Status
  HOMEBREW_INSTALLED=false
  if command -v brew &> /dev/null; then
    HOMEBREW_INSTALLED=true
  fi

  # Check for installed apps from install-apps.sh
  CHROME_INSTALLED=false
  SLACK_INSTALLED=false
  DISCORD_INSTALLED=false
  WEZTERM_INSTALLED=false
  ONEPWD_INSTALLED=false
  LOGI_INSTALLED=false
  ONEPWD_CLI_INSTALLED=false

  if $HOMEBREW_INSTALLED; then
    # Check for each application
    if [ -d "/Applications/Google Chrome.app" ]; then
      CHROME_INSTALLED=true
    fi
    if [ -d "/Applications/Slack.app" ]; then
      SLACK_INSTALLED=true
    fi
    if [ -d "/Applications/Discord.app" ]; then
      DISCORD_INSTALLED=true
    fi
    if [ -d "/Applications/WezTerm.app" ]; then
      WEZTERM_INSTALLED=true
    fi
    if [ -d "/Applications/1Password.app" ]; then
      ONEPWD_INSTALLED=true
    fi
    if [ -d "/Applications/Logi Options+.app" ]; then
      LOGI_INSTALLED=true
    fi
    if command -v op &> /dev/null; then
      ONEPWD_CLI_INSTALLED=true
    fi
  fi

  # Neovim Configuration Status
  NVIM_CONFIGURED=false
  if [ -f "$HOME/.config/nvim/lazy-lock.json" ]; then
    NVIM_CONFIGURED=true
  fi

  # Aerospace (Window Manager) Status
  AEROSPACE_CONFIGURED=false
  if [ -f "$HOME/.config/aerospace/aerospace.toml" ]; then
    AEROSPACE_CONFIGURED=true
  fi
}

# Display component status
display_status() {
  echo -e "${BLUE}Current Status:${NC}"
  echo

  # Shell/Homebrew status
  echo -e "Shell Environment:"
  if $SHELL_CONFIGURED; then
    echo -e "  ${GREEN}✅ Zsh configured${NC}"
  else
    echo -e "  ${RED}❌ Zsh not configured${NC}"
  fi

  if $HOMEBREW_INSTALLED; then
    echo -e "  ${GREEN}✅ Homebrew installed${NC}"
  else
    echo -e "  ${RED}❌ Homebrew not installed${NC}"
  fi
  
  # Applications status
  echo -e "\nApplications:"
  if $CHROME_INSTALLED; then
    echo -e "  ${GREEN}✅ Google Chrome${NC}"
  else
    echo -e "  ${RED}❌ Google Chrome${NC}"
  fi
  
  if $SLACK_INSTALLED; then
    echo -e "  ${GREEN}✅ Slack${NC}"
  else
    echo -e "  ${RED}❌ Slack${NC}"
  fi
  
  if $DISCORD_INSTALLED; then
    echo -e "  ${GREEN}✅ Discord${NC}"
  else
    echo -e "  ${RED}❌ Discord${NC}"
  fi
  
  if $WEZTERM_INSTALLED; then
    echo -e "  ${GREEN}✅ WezTerm${NC}"
  else
    echo -e "  ${RED}❌ WezTerm${NC}"
  fi
  
  if $ONEPWD_INSTALLED; then
    echo -e "  ${GREEN}✅ 1Password${NC}"
  else
    echo -e "  ${RED}❌ 1Password${NC}"
  fi
  
  if $LOGI_INSTALLED; then
    echo -e "  ${GREEN}✅ Logi Options+${NC}"
  else
    echo -e "  ${RED}❌ Logi Options+${NC}"
  fi
  
  if $ONEPWD_CLI_INSTALLED; then
    echo -e "  ${GREEN}✅ 1Password CLI${NC}"
  else
    echo -e "  ${RED}❌ 1Password CLI${NC}"
  fi

  # Configuration status
  echo -e "\nConfigurations:"
  if $NVIM_CONFIGURED; then
    echo -e "  ${GREEN}✅ Neovim${NC}"
  else
    echo -e "  ${RED}❌ Neovim${NC}"
  fi
  
  if $AEROSPACE_CONFIGURED; then
    echo -e "  ${GREEN}✅ Aerospace (Window Manager)${NC}"
  else
    echo -e "  ${RED}❌ Aerospace (Window Manager)${NC}"
  fi
  
  echo
}

# Display menu options
display_menu() {
  echo -e "${BLUE}Setup Options:${NC}"
  echo "1) Configure Shell Environment (installs Homebrew and sets up Zsh)"
  echo "2) Install Applications (via Homebrew)"
  echo "3) Link Configuration Files (Neovim, Aerospace, etc.)"
  echo "4) Run Complete Setup (all of the above)"
  echo "5) Refresh Status"
  echo "6) Create Shell Config Marker File Manually"
  echo "7) Exit"
  echo
}

# Ensure Git is installed
ensure_git() {
  if ! command -v git &> /dev/null; then
    echo -e "${YELLOW}🔧 Git is not installed. Installing Xcode Command Line Tools...${NC}"
    xcode-select --install
    echo -e "${YELLOW}⏳ Please install Git and rerun this script.${NC}"
    exit 1
  fi
}

# Clone the repository
clone_repo() {
  if [ -d "$TARGET_DIR" ]; then
    echo -e "${YELLOW}📁 Directory $TARGET_DIR already exists. Skipping clone.${NC}"
  else
    echo -e "${YELLOW}📥 Cloning dotfiles repo...${NC}"
    git clone "$REPO_URL" "$TARGET_DIR"
  fi

  cd "$TARGET_DIR" || exit
}

# Make scripts executable
make_scripts_executable() {
  chmod +x config-shell.sh
  chmod +x install-apps.sh
  chmod +x setup.sh
}

# Configure shell
configure_shell() {
  if $SHELL_CONFIGURED; then
    echo -e "${YELLOW}✅ Shell already configured. Skipping.${NC}"
  else
    echo -e "${YELLOW}🔧 Setting up shell environment...${NC}"
    ./config-shell.sh
    
    # Verify marker file was created
    if [ -f "$HOME/.cvrt_shell_configured" ]; then
      echo -e "${GREEN}✅ Shell setup complete. Marker file created.${NC}"
    else
      echo -e "${RED}⚠️ Shell setup may have completed but marker file was not created.${NC}"
      echo -e "${YELLOW}Would you like to create the marker file manually? (y/n)${NC}"
      read -r response
      if [[ "$response" =~ ^[Yy]$ ]]; then
        touch "$HOME/.cvrt_shell_configured"
        echo -e "${GREEN}✅ Marker file created manually.${NC}"
      fi
    fi
  fi
}

# Install applications
install_apps() {
  echo -e "${YELLOW}📦 Installing applications...${NC}"
  ./install-apps.sh
  echo -e "${GREEN}✅ Application installation complete.${NC}"
}

# Link configuration files
link_configs() {
  echo -e "${YELLOW}🔗 Linking configuration files...${NC}"
  
  # Create config directories if they don't exist
  mkdir -p "$HOME/.config/nvim"
  mkdir -p "$HOME/.config/aerospace"
  mkdir -p "$HOME/.config/wezterm"
  
  # Link Neovim config
  if [ -d "$TARGET_DIR/.config/nvim" ]; then
    echo "Linking Neovim configuration..."
    ln -sf "$TARGET_DIR/.config/nvim" "$HOME/.config/"
  fi
  
  # Link Aerospace config
  if [ -f "$TARGET_DIR/.config/aerospace/aerospace.toml" ]; then
    echo "Linking Aerospace configuration..."
    ln -sf "$TARGET_DIR/.config/aerospace" "$HOME/.config/"
  fi
  
  # Link WezTerm config
  if [ -f "$TARGET_DIR/.config/wezterm/wezterm.lua" ]; then
    echo "Linking WezTerm configuration..."
    ln -sf "$TARGET_DIR/.config/wezterm" "$HOME/.config/"
  fi
  
  echo -e "${GREEN}✅ Configuration linking complete.${NC}"
}

# Create shell config marker manually
create_marker_manually() {
  echo -e "${YELLOW}Creating shell configuration marker file manually...${NC}"
  touch "$HOME/.cvrt_shell_configured"
  
  if [ -f "$HOME/.cvrt_shell_configured" ]; then
    echo -e "${GREEN}✅ Marker file created successfully.${NC}"
  else
    echo -e "${RED}❌ Failed to create marker file.${NC}"
  fi
}

# Main function
main() {
  ensure_git
  clone_repo
  make_scripts_executable

  while true; do
    check_status
    print_header
    display_status
    display_menu
    
    read -p "Enter your choice (1-7): " choice
    
    case $choice in
      1)
        configure_shell
        read -p "Press Enter to continue..."
        ;;
      2)
        install_apps
        read -p "Press Enter to continue..."
        ;;
      3)
        link_configs
        read -p "Press Enter to continue..."
        ;;
      4)
        configure_shell
        install_apps
        link_configs
        echo -e "${GREEN}🎉 Complete setup finished!${NC}"
        echo -e "${YELLOW}🔄 Please restart your terminal for changes to take effect.${NC}"
        read -p "Press Enter to continue..."
        ;;
      5)
        # Just refresh status - it will happen on next loop iteration
        ;;
      6)
        create_marker_manually
        read -p "Press Enter to continue..."
        ;;
      7)
        echo -e "${BLUE}👋 Exiting.${NC}"
        exit 0
        ;;
      *)
        echo -e "${RED}❌ Invalid choice.${NC}"
        read -p "Press Enter to continue..."
        ;;
    esac
  done
}

# Run main function
main
