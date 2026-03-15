#!/bin/bash

# Terminal Setup for AI Development
# Interactive installer for macOS
# Author: Alex Ciortan

# Ensure script runs with bash (process substitution requires bash)
if [ -z "$BASH_VERSION" ]; then
    if command -v bash >/dev/null 2>&1; then
        exec bash "$0" "$@"
    else
        echo "Error: bash is required but not found in PATH"
        echo "Please run with: bash $0"
        exit 1
    fi
fi

set -e

# Show help
show_help() {
    cat << EOF
Terminal Setup for AI Development - Interactive Installer

Usage: ./install.sh [OPTIONS]

OPTIONS:
    -h, --help     Show this help message and exit
    -v, --version  Show version information

DESCRIPTION:
    Interactive installer for terminal development environment.
    Safe to run multiple times (idempotent).
    Automatically backs up existing configurations.

FEATURES:
    • Auto-detect existing installations
    • Back up configs before modifying
    • Skip GUI apps if already installed
    • Update brew packages if outdated
    • Interactive component selection

INSTALLATION OPTIONS:
    [1] Essential Tools - Git, Node.js, Python, Docker, AWS CLI
    [2] Terminal Enhancements - Tmux plugins, enhanced shell
    [3] GitHub Dashboard - gh-dash
    [4] Window Manager - AeroSpace
    [5] Everything - Recommended for new setup
    [0] Skip - Just update existing tools

EXAMPLES:
    # Interactive installation
    ./install.sh

    # Show help
    ./install.sh --help

    # Show version
    ./install.sh --version

DOCUMENTATION:
    README.md              - Main documentation
    docs/QUICKSTART.md     - Quick start guide
    docs/REFERENCE.md      - Command reference
    docs/ADVANCED.md       - Advanced features

REPOSITORY:
    https://github.com/AlexCiortan/terminal-setup

EOF
    exit 0
}

# Handle command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            show_help
            ;;
        -v|--version)
            cat VERSION 2>/dev/null || echo "1.0.0"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            echo "Try './install.sh --help' for more information."
            exit 1
            ;;
    esac
    shift
done

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

# Setup logging to file
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_DIR="$SCRIPT_DIR/logs"
mkdir -p "$LOG_DIR"

# Create log file with timestamp
LOG_FILE="$LOG_DIR/install_$(date +%Y%m%d_%H%M%S).log"

# Clean up old logs (keep last 10)
ls -t "$LOG_DIR"/install_*.log 2>/dev/null | tail -n +11 | xargs rm -f 2>/dev/null || true

# Helper function to log to both console and file (POSIX-compliant)
_log() {
    printf '%b\n' "$1"
    printf '%b\n' "$1" | sed 's/\x1b\[[0-9;]*m//g' >> "$LOG_FILE"
}

# Logging functions
log_header() { _log "\n${MAGENTA}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"; _log "${CYAN}$1${NC}"; _log "${MAGENTA}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"; }
log_info() { _log "${BLUE}ℹ️  $1${NC}"; }
log_success() { _log "${GREEN}✅ $1${NC}"; }
log_warning() { _log "${YELLOW}⚠️  $1${NC}"; }
log_error() { _log "${RED}❌ $1${NC}"; }
log_skip() { _log "${YELLOW}⏭️  $1${NC}"; }

# Backup function - automatically creates timestamped backups
backup_config() {
    local file=$1
    if [ -f "$file" ] || [ -d "$file" ]; then
        local backup_dir="$HOME/.config_backup_$(date +%Y%m%d_%H%M%S)"
        mkdir -p "$backup_dir"
        cp -r "$file" "$backup_dir/" 2>/dev/null || true
        log_info "Backed up $(basename $file) to $backup_dir/"
    fi
}

# Check if GUI app is installed
is_app_installed() {
    local app_name=$1
    [ -d "/Applications/${app_name}.app" ] || [ -d "$HOME/Applications/${app_name}.app" ]
}

# Check if brew package is installed
is_brew_installed() {
    brew list "$1" &> /dev/null
}

# Install or update brew package
brew_install_or_upgrade() {
    local package=$1
    if is_brew_installed "$package"; then
        log_skip "$package already installed, checking for updates..."
        brew upgrade "$package" 2>/dev/null || log_success "$package is up to date"
    else
        log_info "Installing $package..."
        brew install "$package"
        log_success "$package installed"
    fi
}

# Install cask or skip if exists
brew_cask_install_or_skip() {
    local package=$1
    local app_name=$2

    if is_app_installed "$app_name"; then
        log_skip "$app_name already installed, skipping"
        return 0
    fi

    if is_brew_installed "$package"; then
        log_skip "$package already installed, skipping"
        return 0
    fi

    log_info "Installing $package..."
    brew install --cask "$package"
    log_success "$package installed"
}

# Banner
clear
echo -e "${CYAN}"
cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║                                                              ║
║          Terminal Setup for AI Development                  ║
║          Automatic Installer - Idempotent & Safe            ║
║                                                              ║
╚══════════════════════════════════════════════════════════════╝
EOF
echo -e "${NC}"

echo -e "${BLUE}📝 Installation log:${NC} $LOG_FILE"
echo ""
echo "This installer will:"
echo "  • Auto-detect existing installations"
echo "  • Back up your configs before modifying"
echo "  • Skip GUI apps if already installed"
echo "  • Update brew packages if outdated"
echo ""
echo -e "${GREEN}Safe to run multiple times!${NC}"
echo ""
echo -e "${YELLOW}Press Enter to continue or Ctrl+C to cancel...${NC}"
read

# Prompt for sudo password upfront (needed for GUI app installations later)
echo ""
echo -e "${BLUE}ℹ️  Some installations require administrator access.${NC}"
echo -e "${BLUE}ℹ️  Please enter your password if prompted:${NC}"
sudo -v

# Keep sudo alive in background (save PID to kill later)
SUDO_KEEPALIVE_PID=""
if sudo -n true 2>/dev/null; then
    (
        while true; do
            sudo -n true
            sleep 50
        done
    ) &
    SUDO_KEEPALIVE_PID=$!
fi

# ============================================================================
# PRE-FLIGHT CHECKS
# ============================================================================

log_header "PRE-FLIGHT CHECKS"

# Check for Xcode Command Line Tools
if ! xcode-select -p &> /dev/null; then
    log_warning "Xcode Command Line Tools not found. Installing..."
    xcode-select --install
    echo "Please complete the Xcode installation and run this script again."
    exit 1
fi
log_success "Xcode Command Line Tools installed"

# Check macOS version
MACOS_VERSION=$(sw_vers -productVersion | cut -d. -f1)
if [ "$MACOS_VERSION" -lt 14 ]; then
    log_warning "macOS 14+ recommended. You have macOS $MACOS_VERSION"
fi

# Check available disk space (need at least 10GB)
AVAILABLE_SPACE=$(df -g / | tail -1 | awk '{print $4}')
if [ "$AVAILABLE_SPACE" -lt 10 ]; then
    log_error "Less than 10GB free space available. Please free up space."
    exit 1
fi
log_success "Sufficient disk space available"

# ============================================================================
# SECTION 1: Package Manager & Core Tools
# ============================================================================

log_header "SECTION 1: Package Manager & Core Tools"

# Install Homebrew if not present
if ! command -v brew &> /dev/null; then
    log_info "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add to PATH for Apple Silicon
    if [[ $(uname -m) == 'arm64' ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
        # Only add to zprofile if not already there
        grep -q 'brew shellenv' ~/.zprofile 2>/dev/null || echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
    fi
    log_success "Homebrew installed"
else
    log_success "Homebrew already installed"
fi

log_info "Updating Homebrew..."
if ! brew update 2>&1 | tee /tmp/brew_update.log; then
    # Check if it's a tap issue
    if grep -q "anthropics/homebrew-claude" /tmp/brew_update.log; then
        log_warning "Homebrew tap issue detected, cleaning up anthropics/claude tap..."
        brew untap anthropics/claude 2>/dev/null || true
        log_info "Retrying Homebrew update..."
        brew update || log_warning "Homebrew update had issues, continuing anyway..."
    else
        log_warning "Homebrew update had issues, continuing anyway..."
    fi
fi
rm -f /tmp/brew_update.log

# Install core CLI tools (these are safe to upgrade)
log_info "Installing/updating core development tools..."
brew_install_or_upgrade git
brew_install_or_upgrade gh
brew_install_or_upgrade lazygit
brew_install_or_upgrade git-delta
brew_install_or_upgrade ripgrep
brew_install_or_upgrade fd
brew_install_or_upgrade tree
brew_install_or_upgrade htop
brew_install_or_upgrade glow
brew_install_or_upgrade jq
brew_install_or_upgrade yq
brew_install_or_upgrade shellcheck
brew_install_or_upgrade shfmt
brew_install_or_upgrade watch
brew_install_or_upgrade wget
brew_install_or_upgrade curl

log_success "Core tools ready"

# Install terminal and shell essentials
log_info "Installing/updating terminal essentials..."
brew_install_or_upgrade tmux
brew_install_or_upgrade neovim
brew_install_or_upgrade starship
brew_install_or_upgrade atuin
brew_install_or_upgrade zoxide
brew_install_or_upgrade fzf
brew_install_or_upgrade bat
brew_install_or_upgrade eza

log_success "Terminal essentials ready"

# Configure Neovim immediately after installation (before user might launch it)
if [ ! -d ~/.config/nvim ]; then
    log_info "Setting up Neovim with LazyVim..."
    git clone https://github.com/LazyVim/starter ~/.config/nvim
    rm -rf ~/.config/nvim/.git
    log_success "LazyVim configured - run 'nvim' to complete plugin setup"
else
    log_skip "Neovim config already exists at ~/.config/nvim"
fi

# Install JetBrains Mono font (needed for Ghostty config)
log_info "Installing JetBrains Mono font..."
if brew list --cask font-jetbrains-mono &> /dev/null; then
    log_skip "JetBrains Mono font already installed"
else
    brew install --cask font-jetbrains-mono
    log_success "JetBrains Mono font installed"
fi

# Install Ghostty (GPU-accelerated terminal)
if is_app_installed "Ghostty"; then
    log_skip "Ghostty already installed"
else
    log_info "Installing Ghostty terminal..."
    brew_cask_install_or_skip ghostty "Ghostty"
fi

# Configure Ghostty immediately after installation (before user might launch it)
log_info "Configuring Ghostty terminal..."
mkdir -p ~/.config/ghostty
if [ -f ~/.config/ghostty/config ]; then
    backup_config ~/.config/ghostty/config
fi
cp configs/ghostty ~/.config/ghostty/config
log_success "Ghostty configured with JetBrains Mono font"

# Configure Starship immediately after installation
log_info "Configuring Starship prompt..."
mkdir -p ~/.config
if [ -f ~/.config/starship.toml ]; then
    backup_config ~/.config/starship.toml
fi
cp configs/starship.toml ~/.config/starship.toml
log_success "Starship configured"

# ============================================================================
# CRITICAL: Configure Zsh (ALWAYS - not optional!)
# ============================================================================

log_info "Configuring Zsh shell..."

# Install Zsh plugins (required for zshrc to work)
log_info "Installing Zsh plugins..."
mkdir -p ~/.zsh

if [ ! -d ~/.zsh/zsh-autosuggestions ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
    log_success "zsh-autosuggestions installed"
else
    log_skip "zsh-autosuggestions already installed"
fi

if [ ! -d ~/.zsh/zsh-syntax-highlighting ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.zsh/zsh-syntax-highlighting
    log_success "zsh-syntax-highlighting installed"
else
    log_skip "zsh-syntax-highlighting already installed"
fi

# Install fzf key bindings (required for Ctrl+R history search)
if [ -f "$(brew --prefix)/opt/fzf/install" ]; then
    log_info "Installing fzf key bindings..."
    "$(brew --prefix)/opt/fzf/install" --key-bindings --completion --no-update-rc --no-bash --no-fish
fi

# Configure zshrc (ALWAYS copy this - it has all aliases and configs)
log_info "Installing enhanced .zshrc configuration..."

# Verify we're in the right directory
if [ ! -f "configs/zshrc" ]; then
    log_error "configs/zshrc not found!"
    log_error "Current directory: $(pwd)"
    log_error "Make sure you're running from the repository root"
    exit 1
fi

# Verify source file is not empty
if [ ! -s "configs/zshrc" ]; then
    log_error "configs/zshrc is empty!"
    exit 1
fi

# Backup existing zshrc if it exists
if [ -f ~/.zshrc ]; then
    backup_config ~/.zshrc
fi

# Copy the config file
cp -f configs/zshrc ~/.zshrc

# CRITICAL: Verify the copy succeeded
if [ ! -f ~/.zshrc ]; then
    log_error "Failed to create ~/.zshrc"
    exit 1
fi

if [ ! -s ~/.zshrc ]; then
    log_error "~/.zshrc is empty after copying! Something went wrong."
    log_error "Source file: configs/zshrc ($(wc -l < configs/zshrc) lines)"
    log_error "Dest file: ~/.zshrc ($(wc -l < ~/.zshrc 2>/dev/null || echo 0) lines)"
    exit 1
fi

log_success ".zshrc configured with all aliases ($(wc -l < ~/.zshrc) lines copied)"

# ============================================================================
# SECTION 2: Interactive Component Selection
# ============================================================================

log_header "SECTION 2: Select Components to Install"

echo "Choose what to install:"
echo ""
echo "  [1] Essential Tools (Git, Node.js, Python, Docker, AWS CLI, DBs)"
echo "  [2] Terminal Enhancements (Tmux plugins, Starship config)"
echo "  [3] GitHub Dashboard (gh-dash)"
echo "  [4] Window Manager (AeroSpace)"
echo "  [5] Everything (Recommended)"
echo "  [0] Skip - just update existing tools"
echo ""
echo -n "Enter your choice [0-5]: "
read choice

INSTALL_ESSENTIAL=false
INSTALL_TERMINAL=false
INSTALL_GHDASH=false
INSTALL_AEROSPACE=false

case $choice in
    1) INSTALL_ESSENTIAL=true ;;
    2) INSTALL_TERMINAL=true ;;
    3) INSTALL_GHDASH=true ;;
    4) INSTALL_AEROSPACE=true ;;
    5) INSTALL_ESSENTIAL=true; INSTALL_TERMINAL=true; INSTALL_GHDASH=true; INSTALL_AEROSPACE=true ;;
    0) log_info "Skipping new installations, just updating existing tools" ;;
    *) log_error "Invalid choice. Exiting."; exit 1 ;;
esac

# ============================================================================
# SECTION 3: Essential Development Tools
# ============================================================================

if [ "$INSTALL_ESSENTIAL" = true ]; then
    log_header "SECTION 3: Essential Development Tools"

    # Refresh sudo for GUI app installations (Docker, VS Code, etc.)
    log_info "Refreshing sudo credentials for GUI applications..."
    sudo -v

    # Node.js via nvm
    if [ ! -d "$HOME/.nvm" ]; then
        log_info "Installing nvm (Node Version Manager)..."
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
        export NVM_DIR="$HOME/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

        log_info "Installing Node.js LTS..."
        nvm install --lts
        nvm use --lts
        nvm alias default node
        log_success "Node.js (LTS) installed via nvm"
    else
        log_skip "nvm already installed"
    fi

    # Python version manager
    brew_install_or_upgrade pyenv

    # Python tools
    log_info "Installing/updating Python tools..."
    brew_install_or_upgrade pipx
    brew_install_or_upgrade uv

    # Ensure pipx path
    pipx ensurepath &> /dev/null || true

    # Install Python CLI tools via pipx (these handle their own upgrades)
    for tool in poetry black ruff ipython; do
        if pipx list | grep -q "$tool"; then
            log_skip "$tool already installed via pipx"
        else
            log_info "Installing $tool via pipx..."
            pipx install "$tool" &> /dev/null
        fi
    done
    log_success "Python tools ready"

    # AWS CLI
    brew_install_or_upgrade awscli

    # Claude Code CLI - for AI development with Claude
    log_info "Installing Claude Code CLI..."
    if ! brew tap | grep -q "anthropics/claude"; then
        brew tap anthropics/claude 2>/dev/null || {
            log_warning "Failed to tap anthropics/claude, retrying..."
            brew untap anthropics/claude 2>/dev/null || true
            brew tap anthropics/claude
        }
    fi
    brew_install_or_upgrade claude-code

    # Docker Desktop - skip if already installed
    brew_cask_install_or_skip docker "Docker"

    # Visual Studio Code - for Claude Code and AI development
    VSCODE_ALREADY_INSTALLED=false
    if is_app_installed "Visual Studio Code"; then
        VSCODE_ALREADY_INSTALLED=true
    fi

    brew_cask_install_or_skip visual-studio-code "Visual Studio Code"

    # Install VS Code extensions - only if VS Code is actually installed
    if is_app_installed "Visual Studio Code"; then
        # If VS Code was just installed, wait for it to settle
        if [ "$VSCODE_ALREADY_INSTALLED" = false ]; then
            log_info "Waiting for VS Code to initialize..."
            sleep 3
        fi

        log_info "Installing VS Code extensions..."
        if bash "$SCRIPT_DIR/scripts/install-vscode-extensions.sh"; then
            log_success "VS Code extensions installation complete"
        else
            log_warning "VS Code extensions installation had some issues"
            log_info "You can re-run: ./scripts/install-vscode-extensions.sh"
        fi
    else
        log_warning "VS Code not found - skipping extension installation"
        log_info "Install VS Code manually and run: ./scripts/install-vscode-extensions.sh"
    fi

    # Google Chrome - modern browser
    brew_cask_install_or_skip google-chrome "Google Chrome"

    # Databases
    brew_install_or_upgrade postgresql@16
    brew_install_or_upgrade redis

    # Configure Git with delta (only if not already configured)
    if ! git config --global core.pager | grep -q delta; then
        log_info "Configuring Git with delta..."
        git config --global core.pager "delta"
        git config --global interactive.diffFilter "delta --color-only"
        git config --global delta.navigate true
        git config --global merge.conflictstyle diff3
        git config --global diff.colorMoved default
    fi

    # Set sensible Git defaults (safe to run multiple times)
    git config --global init.defaultBranch main
    git config --global pull.rebase false
    git config --global fetch.prune true
    git config --global core.editor nvim

    # ============================================================================
    # Git & GitHub Configuration (PAT-focused for SSO)
    # ============================================================================

    echo ""
    log_header "Git & GitHub Configuration"

    # Check if Git user is already configured
    if git config --global user.name &>/dev/null && git config --global user.email &>/dev/null; then
        GIT_USER_NAME=$(git config --global user.name)
        GIT_USER_EMAIL=$(git config --global user.email)
        log_success "Git identity already configured: $GIT_USER_NAME <$GIT_USER_EMAIL>"
    else
        log_info "Setting up Git identity for commits..."
        echo ""
        echo "${CYAN}═══════════════════════════════════════════════════════════════${NC}"
        echo "${YELLOW}Git Identity Configuration${NC}"
        echo "${CYAN}═══════════════════════════════════════════════════════════════${NC}"
        echo ""
        echo "Git needs your name and email to identify your commits."
        echo "This is ${YELLOW}separate${NC} from GitHub authentication (handled with PAT)."
        echo ""
        echo -n "Configure Git identity now? (y/n): "
        read git_config_choice

        if [[ $git_config_choice =~ ^[Yy]$ ]]; then
            echo ""
            echo -n "Your full name (e.g., 'John Doe'): "
            read git_user_name
            echo -n "Your email (e.g., 'john@example.com'): "
            read git_user_email

            if [ -n "$git_user_name" ] && [ -n "$git_user_email" ]; then
                git config --global user.name "$git_user_name"
                git config --global user.email "$git_user_email"
                log_success "Git identity configured: $git_user_name <$git_user_email>"
            else
                log_warning "Invalid input. Skipping Git identity configuration."
            fi
        else
            log_info "Skipped Git identity configuration"
        fi
    fi

    # GitHub Authentication Setup (PAT-focused)
    echo ""
    echo "${CYAN}═══════════════════════════════════════════════════════════════${NC}"
    echo "${YELLOW}GitHub Authentication Setup${NC}"
    echo "${CYAN}═══════════════════════════════════════════════════════════════${NC}"
    echo ""
    echo "${GREEN}Recommended approach for GitHub (especially with SSO):${NC}"
    echo ""
    echo "1️⃣  ${CYAN}SSH Keys${NC} for Git operations (push/pull/clone)"
    echo "   • Works immediately with SSO"
    echo "   • Most secure and convenient"
    echo "   • Never expires"
    echo ""
    echo "2️⃣  ${CYAN}Personal Access Token (PAT)${NC} for GitHub CLI"
    echo "   • Required for SSO organizations"
    echo "   • Enables 'gh' CLI features (PRs, issues, etc.)"
    echo "   • Must be authorized for your SSO org"
    echo ""
    echo "${YELLOW}📖 Complete setup guide: docs/GITHUB_SETUP.md${NC}"
    echo ""
    echo -n "Do you have a ${YELLOW}Personal Access Token${NC} ready? (y/n): "
    read pat_ready

    if [[ $pat_ready =~ ^[Yy]$ ]]; then
        echo ""
        log_success "Great! You can authenticate GitHub CLI after installation:"
        echo ""
        echo "  ${CYAN}gh auth login${NC}"
        echo "  → Choose: GitHub.com"
        echo "  → Choose: HTTPS"
        echo "  → Choose: Paste an authentication token"
        echo "  → Paste your PAT"
        echo ""
        echo "  ${YELLOW}Don't forget to authorize your PAT for SSO:${NC}"
        echo "  https://github.com/settings/tokens → Configure SSO → Authorize"
        echo ""
    else
        echo ""
        log_info "You'll need to set up GitHub authentication after installation."
        echo ""
        echo "${YELLOW}Quick setup checklist:${NC}"
        echo ""
        echo "1. Generate SSH key:"
        echo "   ${CYAN}ssh-keygen -t ed25519 -C \"your@email.com\"${NC}"
        echo "   ${CYAN}cat ~/.ssh/id_ed25519.pub${NC}  # Copy this"
        echo "   Add to: https://github.com/settings/keys"
        echo ""
        echo "2. Create Personal Access Token:"
        echo "   Go to: https://github.com/settings/tokens"
        echo "   Click: Generate new token (classic)"
        echo "   Scopes: ${CYAN}repo, read:org, read:user, workflow${NC}"
        echo ""
        echo "3. Authenticate GitHub CLI:"
        echo "   ${CYAN}gh auth login${NC}  # Use your PAT"
        echo ""
        echo "4. Authorize PAT for SSO (if applicable):"
        echo "   https://github.com/settings/tokens → Configure SSO"
        echo ""
        echo "${YELLOW}📖 Full guide: docs/GITHUB_SETUP.md${NC}"
        echo ""
    fi

    log_success "Essential tools installed"
fi

# ============================================================================
# SECTION 4: Terminal Enhancements
# ============================================================================

if [ "$INSTALL_TERMINAL" = true ]; then
    log_header "SECTION 4: Terminal Enhancements"

    # Zsh already configured in Section 1 - skip
    log_skip "Zsh plugins and .zshrc already configured"

    # Enhanced tmux.conf
    log_info "Configuring tmux..."
    if [ -f ~/.tmux.conf ]; then
        backup_config ~/.tmux.conf
    fi

    # Ensure TPM is installed
    if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
        log_info "Installing Tmux Plugin Manager..."
        git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    else
        log_skip "TPM already installed"
    fi

    cp configs/tmux.conf ~/.tmux.conf
    log_success "tmux.conf configured"
    log_info "To install tmux plugins: Start tmux and press 'Ctrl+b' then 'Shift+I'"

    # Starship prompt - check if already configured
    if [ -f ~/.config/starship.toml ]; then
        log_skip "Starship already configured at ~/.config/starship.toml"
    else
        log_info "Configuring Starship prompt..."
        mkdir -p ~/.config
        cp configs/starship.toml ~/.config/starship.toml
        log_success "Starship configured"
    fi

    # Ghostty terminal - check if already configured
    if [ -f ~/.config/ghostty/config ]; then
        log_skip "Ghostty already configured at ~/.config/ghostty/config"
    else
        log_info "Configuring Ghostty terminal..."
        mkdir -p ~/.config/ghostty
        cp configs/ghostty ~/.config/ghostty/config
        log_success "Ghostty configured"
    fi

    # Neovim with LazyVim - check if already configured
    if [ -d ~/.config/nvim ]; then
        log_skip "Neovim already configured at ~/.config/nvim"
    else
        log_info "Setting up Neovim with LazyVim..."
        git clone https://github.com/LazyVim/starter ~/.config/nvim
        rm -rf ~/.config/nvim/.git
        log_success "LazyVim configured"
        echo ""
        log_info "Note: Run 'nvim' to complete LazyVim setup (will auto-install plugins)"
    fi

    # Verify all configs were applied
    echo ""
    log_header "Configuration Verification"
    [ -f ~/.zshrc ] && log_success "✓ ~/.zshrc" || log_warning "✗ ~/.zshrc"
    [ -f ~/.tmux.conf ] && log_success "✓ ~/.tmux.conf" || log_warning "✗ ~/.tmux.conf"
    [ -f ~/.config/starship.toml ] && log_success "✓ ~/.config/starship.toml" || log_warning "✗ ~/.config/starship.toml"
    [ -f ~/.config/ghostty/config ] && log_success "✓ ~/.config/ghostty/config" || log_warning "✗ ~/.config/ghostty/config"
    [ -d ~/.tmux/plugins/tpm ] && log_success "✓ ~/.tmux/plugins/tpm" || log_warning "✗ ~/.tmux/plugins/tpm"
    [ -d ~/.config/nvim ] && log_success "✓ ~/.config/nvim" || log_warning "✗ ~/.config/nvim"
fi

# ============================================================================
# SECTION 5: GitHub Dashboard
# ============================================================================

if [ "$INSTALL_GHDASH" = true ]; then
    log_header "SECTION 5: GitHub Dashboard"

    echo ""
    log_warning "gh-dash requires GitHub authentication (gh auth login)"
    log_info "Note: May not work with Google SSO - requires browser-based GitHub login"
    echo ""
    echo -n "Do you want to install gh-dash? (y/n): "
    read install_ghdash_confirm

    if [[ $install_ghdash_confirm =~ ^[Yy]$ ]]; then
        if is_brew_installed "gh-dash"; then
            log_skip "gh-dash already installed"
        else
            log_info "Installing gh-dash..."
            brew install dlvhdr/gh-dash/gh-dash
        fi

        log_info "Configuring gh-dash..."
        mkdir -p ~/.config/gh-dash
        if [ -f ~/.config/gh-dash/config.yml ]; then
            backup_config ~/.config/gh-dash/config.yml
        fi
        cp configs/gh-dash.yml ~/.config/gh-dash/config.yml
        log_success "gh-dash configured"

        GHDASH_INSTALLED=true
    else
        log_skip "Skipping gh-dash installation"
        GHDASH_INSTALLED=false
    fi
else
    GHDASH_INSTALLED=false
fi

# ============================================================================
# SECTION 6: Window Manager (Optional)
# ============================================================================

if [ "$INSTALL_AEROSPACE" = true ]; then
    log_header "SECTION 6: Window Manager (AeroSpace)"

    if is_app_installed "AeroSpace"; then
        log_skip "AeroSpace already installed"
    else
        log_info "Installing AeroSpace..."
        brew install --cask nikitabobko/tap/aerospace
    fi

    log_info "Configuring AeroSpace..."
    mkdir -p ~/.config/aerospace
    if [ -f ~/.config/aerospace/aerospace.toml ]; then
        backup_config ~/.config/aerospace/aerospace.toml
    fi
    cp configs/aerospace.toml ~/.config/aerospace/aerospace.toml
    log_success "AeroSpace configured"
fi

# ============================================================================
# POST-INSTALLATION VERIFICATION
# ============================================================================

log_header "POST-INSTALLATION VERIFICATION"

# Verify key installations
VERIFICATION_FAILED=false

if command -v git &> /dev/null; then
    log_success "Git: $(git --version | cut -d' ' -f3)"
else
    log_error "Git not found"
    VERIFICATION_FAILED=true
fi

if command -v gh &> /dev/null; then
    log_success "GitHub CLI: $(gh --version | head -1 | cut -d' ' -f3)"
else
    log_warning "GitHub CLI not found"
fi

if command -v tmux &> /dev/null; then
    log_success "Tmux: $(tmux -V)"
else
    log_warning "Tmux not found"
fi

if command -v nvim &> /dev/null; then
    log_success "Neovim: $(nvim --version | head -1 | cut -d' ' -f2)"
else
    log_warning "Neovim not found"
fi

if command -v starship &> /dev/null; then
    log_success "Starship prompt: installed"
else
    log_warning "Starship not found"
fi

if [ -f ~/.zshrc ]; then
    log_success "Shell configuration: ~/.zshrc exists"
else
    log_warning "Shell configuration not found"
fi

if [ -d ~/.tmux/plugins/tpm ]; then
    log_success "Tmux Plugin Manager: installed"
else
    log_warning "Tmux Plugin Manager not found"
fi

# ============================================================================
# VERIFICATION (Always runs)
# ============================================================================

echo ""
log_header "Configuration Verification"
log_info "Checking core configurations..."
echo ""

# Core configs (always installed)
[ -f ~/.zshrc ] && log_success "✓ ~/.zshrc (aliases and shell config)" || log_warning "✗ ~/.zshrc MISSING!"
[ -d ~/.zsh/zsh-autosuggestions ] && log_success "✓ zsh-autosuggestions" || log_warning "✗ zsh-autosuggestions MISSING!"
[ -d ~/.zsh/zsh-syntax-highlighting ] && log_success "✓ zsh-syntax-highlighting" || log_warning "✗ zsh-syntax-highlighting MISSING!"
[ -f ~/.config/starship.toml ] && log_success "✓ Starship prompt config" || log_warning "✗ Starship prompt MISSING!"
[ -f ~/.config/ghostty/config ] && log_success "✓ Ghostty config" || log_skip "  Ghostty config (not installed)"
[ -d ~/.config/nvim ] && log_success "✓ Neovim/LazyVim" || log_skip "  Neovim config (not installed)"

# Optional configs (only if installed)
if [ "$INSTALL_TERMINAL" = true ]; then
    [ -f ~/.tmux.conf ] && log_success "✓ ~/.tmux.conf" || log_warning "✗ ~/.tmux.conf MISSING!"
    [ -d ~/.tmux/plugins/tpm ] && log_success "✓ Tmux Plugin Manager" || log_warning "✗ Tmux Plugin Manager MISSING!"
fi

# ============================================================================
# COMPLETION
# ============================================================================

log_header "✅ Installation Complete!"

if [ "$VERIFICATION_FAILED" = true ]; then
    log_error "Some verifications failed. Please check the errors above."
    exit 1
fi

echo -e "${GREEN}Your terminal setup is ready!${NC}"
echo ""
echo "📋 Next Steps:"
echo ""

if [ "$INSTALL_ESSENTIAL" = true ] || [ "$INSTALL_TERMINAL" = true ]; then
    echo -e "  ${YELLOW}⚠️  IMPORTANT: Restart your terminal for all changes to take effect!${NC}"
    echo -e "     Or run: ${CYAN}exec zsh${NC} to reload shell and activate aliases"
    echo ""
fi

if [ "$INSTALL_ESSENTIAL" = true ]; then
    if ! gh auth status &> /dev/null; then
        echo "  2. Authenticate with GitHub: ${CYAN}gh auth login${NC}"
    fi
    if ! aws configure list &> /dev/null 2>&1; then
        echo "  3. Configure AWS: ${CYAN}aws configure${NC}"
    fi
    if ! docker info &> /dev/null 2>&1; then
        echo "  4. Launch Docker Desktop from Applications"
    fi
    echo ""
fi

if [ "$INSTALL_TERMINAL" = true ]; then
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${YELLOW}⚠️  REQUIRED: Install Tmux Plugins${NC}"
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo "  1. Start tmux: ${CYAN}tmux${NC}"
    echo "  2. Press: ${YELLOW}Ctrl+b${NC} then ${YELLOW}Shift+I${NC} (capital I)"
    echo "  3. Wait for plugins to install (sessionx, floax, thumbs, catppuccin)"
    echo "  4. Detach from tmux: ${YELLOW}Ctrl+b${NC} then ${YELLOW}d${NC}"
    echo ""
    echo "  Once plugins are installed, try these features:"
    echo "     • ${YELLOW}Ctrl+b o${NC} - Session manager (fuzzy find)"
    echo "     • ${YELLOW}Ctrl+b p${NC} - Floating window"
    echo "     • ${YELLOW}Ctrl+b u${NC} - URL finder"
    echo "     • ${YELLOW}Ctrl+b F${NC} - Text selection with hints"
    echo ""
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
fi

# Show Neovim/Ghostty instructions if they were configured (regardless of section choice)
if [ -d ~/.config/nvim ]; then
    echo "  6. Launch Neovim to complete LazyVim setup: ${CYAN}nvim${NC} or ${CYAN}vi${NC}"
    echo "     • LazyVim will auto-install plugins on first launch"
    echo "     • Press ${YELLOW}q${NC} to quit once installation completes"
    echo ""
fi

if [ -f ~/.config/ghostty/config ]; then
    echo "  7. Launch Ghostty terminal: Open from Applications"
    echo "     • Already configured with JetBrains Mono font"
    echo "     • Theme: Dark+ with 90% opacity and blur"
    echo ""
fi

if [ "$GHDASH_INSTALLED" = true ]; then
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${YELLOW}⚠️  GitHub Dashboard (gh-dash) Setup Required${NC}"
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo "  Before using gh-dash, you must authenticate with GitHub:"
    echo ""
    echo "  1. Run: ${CYAN}gh auth login${NC}"
    echo "  2. Choose: ${YELLOW}GitHub.com${NC}"
    echo "  3. Choose: ${YELLOW}HTTPS${NC}"
    echo "  4. Choose: ${YELLOW}Login with a web browser${NC}"
    echo "  5. Copy the one-time code and press Enter"
    echo "  6. Paste code in browser to authenticate"
    echo ""
    echo -e "  ${RED}⚠️  Google SSO Limitation:${NC}"
    echo "     If your GitHub uses Google SSO, you may need to:"
    echo "     • Use a Personal Access Token instead"
    echo "     • Run: ${CYAN}gh auth login --with-token${NC}"
    echo "     • Create token at: ${CYAN}https://github.com/settings/tokens${NC}"
    echo "     • Scopes needed: repo, read:org, read:user"
    echo ""
    echo "  Once authenticated, try: ${CYAN}gh dash${NC}"
    echo "     • View PRs/issues across all your repos"
    echo "     • Press ${YELLOW}g${NC} to open lazygit"
    echo "     • Press ${YELLOW}o${NC} to open in browser"
    echo "     • Press ${YELLOW}?${NC} for help"
    echo ""
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
fi

if [ "$INSTALL_AEROSPACE" = true ]; then
    echo "  9. Launch AeroSpace from Applications"
    echo "     • Grant accessibility permissions when prompted"
    echo "     • Use ${YELLOW}Alt+h/j/k/l${NC} to navigate windows"
    echo ""
fi

echo -e "${CYAN}📚 Documentation:${NC}"
echo "  • docs/QUICKSTART.md - Get started quickly"
echo "  • docs/REFERENCE.md - Commands and shortcuts"
echo "  • docs/ADVANCED.md - Advanced features"
echo ""

echo -e "${YELLOW}💡 Quick Commands:${NC}"
echo "  • ${CYAN}z <dir>${NC}       - Jump to directory"
echo "  • ${CYAN}↑${NC}             - Intelligent history search"
echo "  • ${CYAN}lg${NC}            - LazyGit TUI"
echo "  • ${CYAN}vf${NC}            - Fuzzy find files"
echo "  • ${CYAN}killport 8080${NC} - Kill process on port"
echo ""

if [ -d "$HOME/.config_backup_"* 2>/dev/null ]; then
    echo -e "${BLUE}📦 Backups created in:${NC}"
    ls -dt ~/.config_backup_* 2>/dev/null | head -1
    echo ""
fi

echo -e "${BLUE}📝 Full installation log saved to:${NC}"
echo "   $LOG_FILE"
echo ""

echo -e "${BLUE}ℹ️  Optional: AI-specific tools available in:${NC} ${CYAN}./install-ai-tools.sh${NC}"
echo ""

echo -e "${GREEN}🎉 Happy coding!${NC}"
echo ""

# Offer to restart shell to activate changes
if [ "$INSTALL_ESSENTIAL" = true ] || [ "$INSTALL_TERMINAL" = true ]; then
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo -e "${YELLOW}🔄 Shell restart required to activate all changes${NC}"
    echo ""
    echo -n "Restart your shell now? (y/n): "
    read restart_choice
    echo ""

    if [[ $restart_choice =~ ^[Yy]$ ]]; then
        echo -e "${GREEN}✅ Restarting shell...${NC}"
        echo ""
        exec zsh -l
    else
        echo -e "${BLUE}ℹ️  Remember to restart your terminal or run:${NC} ${CYAN}exec zsh${NC}"
        echo ""
    fi
fi
echo ""
