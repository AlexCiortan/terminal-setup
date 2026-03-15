#!/bin/bash

# WSL2 Development Environment Installer for Windows 11
# Combined installer for terminal setup + AI development tools
# Author: Alex Ciortan
# Platform: WSL2 Ubuntu 24.04

# Ensure script runs with bash (required for [[ ]] syntax)
if [ -z "$BASH_VERSION" ]; then
    if command -v bash >/dev/null 2>&1; then
        exec bash "$0" "$@"
    else
        echo "Error: bash is required but not found in PATH"
        echo "Please run with: bash $0"
        exit 1
    fi
fi

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Color definitions
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Logging functions
log_info() { echo -e "${BLUE}ℹ️  $1${NC}"; }
log_success() { echo -e "${GREEN}✅ $1${NC}"; }
log_warning() { echo -e "${YELLOW}⚠️  $1${NC}"; }
log_error() { echo -e "${RED}❌ $1${NC}"; }
log_header() { echo -e "\n${CYAN}╔═══════════════════════════════════════════╗${NC}"; echo -e "${CYAN}║  $1${NC}"; echo -e "${CYAN}╚═══════════════════════════════════════════╝${NC}\n"; }
log_skip() { echo -e "${YELLOW}⏭️  $1${NC}"; }

# Helper function to check if a brew package is installed
is_brew_installed() {
    brew list "$1" &> /dev/null
}

# Helper function to install or upgrade brew packages
brew_install_or_upgrade() {
    local package=$1
    local display_name=${2:-$package}

    if is_brew_installed "$package"; then
        log_success "$display_name already installed"
        return 0
    fi

    log_info "Installing $display_name..."
    if brew install "$package"; then
        log_success "$display_name installed"
        return 0
    else
        log_error "Failed to install $display_name"
        return 1
    fi
}

# Display banner
clear
echo -e "${CYAN}"
cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║                                                              ║
║          WSL2 Development Environment Installer             ║
║          Terminal Setup + AI Tools for Windows 11           ║
║                                                              ║
╚══════════════════════════════════════════════════════════════╝
EOF
echo -e "${NC}"

# Verify we're running in WSL2
if ! grep -qi microsoft /proc/version; then
    log_error "This script must be run in WSL2 Ubuntu"
    log_info "Please install WSL2 first:"
    echo "  1. Open PowerShell as Administrator"
    echo "  2. Run: wsl --install -d Ubuntu-24.04"
    echo "  3. Restart your computer"
    echo "  4. Run this script inside WSL2"
    exit 1
fi

log_success "Running in WSL2 environment"
echo ""

# Display what will be installed
echo "This installer sets up a complete AI development environment in WSL2:"
echo ""
echo "📦 Core Tools:"
echo "  • Homebrew (package manager)"
echo "  • Git + GitHub CLI (gh) + lazygit"
echo "  • Modern CLI tools (ripgrep, fzf, bat, eza, zoxide)"
echo "  • Claude Code CLI (for AI-assisted development)"
echo ""
echo "🔧 Development Stack:"
echo "  • zsh + Oh My Zsh + Starship prompt"
echo "  • tmux + plugins (sessionx, floax, thumbs)"
echo "  • Neovim + LazyVim configuration"
echo "  • Python (pyenv) + Node.js (nvm)"
echo "  • AWS CLI v2"
echo ""
echo "💾 Databases & Services:"
echo "  • PostgreSQL 16 + pgvector"
echo "  • Redis"
echo ""
echo "🤖 AI/ML Tools (optional):"
echo "  • Jupyter Lab & Notebooks"
echo "  • Ollama (local LLM - CLI)"
echo "  • httpie, monitoring tools"
echo "  • Kubernetes & Terraform tools"
echo ""
echo -e "${YELLOW}Note: GUI apps like VS Code, Docker Desktop, and LM Studio${NC}"
echo -e "${YELLOW}      should be installed on Windows (see README.md)${NC}"
echo ""

# Installation mode selection
echo "Installation mode:"
echo "  [1] Everything (recommended for new setup)"
echo "  [2] Essential tools only (skip AI/ML tools)"
echo "  [3] Custom selection (interactive prompts)"
echo "  [0] Cancel"
echo ""
echo -n "Choose [0-3]: "
read install_mode

case $install_mode in
    0)
        echo "Cancelled."
        exit 0
        ;;
    1)
        INSTALL_MODE="full"
        INSTALL_AI_TOOLS=true
        log_info "Installing everything..."
        ;;
    2)
        INSTALL_MODE="essential"
        INSTALL_AI_TOOLS=false
        log_info "Installing essential tools only..."
        ;;
    3)
        INSTALL_MODE="custom"
        log_info "Custom installation - you'll be prompted for each component..."
        ;;
    *)
        echo "Invalid choice. Cancelled."
        exit 0
        ;;
esac

echo ""
log_info "Starting installation..."
sleep 2

# ============================================================================
# SECTION 1: System Prerequisites
# ============================================================================

log_header "SECTION 1: System Prerequisites"

# Update system packages
log_info "Updating system packages..."
sudo apt update
sudo apt upgrade -y
log_success "System packages updated"

# Install build essentials
log_info "Installing build essentials..."
sudo apt install -y build-essential curl file git
log_success "Build essentials installed"

# ============================================================================
# SECTION 2: Homebrew Installation
# ============================================================================

log_header "SECTION 2: Homebrew Package Manager"

if command -v brew >/dev/null 2>&1; then
    log_success "Homebrew already installed"
    log_info "Updating Homebrew..."
    brew update || log_warning "Homebrew update had issues, continuing anyway..."
else
    log_info "Installing Homebrew..."
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add Homebrew to PATH
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.bashrc

    log_success "Homebrew installed"
fi

# Install Homebrew dependencies
log_info "Installing Homebrew dependencies..."
sudo apt install -y gcc
log_success "Homebrew dependencies installed"

# ============================================================================
# SECTION 3: Essential Development Tools
# ============================================================================

log_header "SECTION 3: Essential Development Tools"

# Git
brew_install_or_upgrade git "Git"

# GitHub CLI
brew_install_or_upgrade gh "GitHub CLI"

# Claude Code CLI
log_info "Installing Claude Code CLI..."
if ! brew tap | grep -q "anthropics/claude"; then
    brew tap anthropics/claude 2>/dev/null || {
        log_warning "Failed to tap anthropics/claude, retrying..."
        brew untap anthropics/claude 2>/dev/null || true
        brew tap anthropics/claude
    }
fi
brew_install_or_upgrade claude-code "Claude Code CLI"

# Modern CLI tools
log_info "Installing modern CLI tools..."
brew_install_or_upgrade ripgrep "ripgrep (rg)"
brew_install_or_upgrade fd "fd"
brew_install_or_upgrade bat "bat"
brew_install_or_upgrade eza "eza"
brew_install_or_upgrade zoxide "zoxide"
brew_install_or_upgrade fzf "fzf"
brew_install_or_upgrade atuin "atuin"
brew_install_or_upgrade jq "jq"
brew_install_or_upgrade yq "yq"

# lazygit
brew_install_or_upgrade lazygit "lazygit"

# git-delta
brew_install_or_upgrade git-delta "git-delta"

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
    echo -e "${CYAN}═══════════════════════════════════════════════════════════════${NC}"
    echo -e "${YELLOW}Git Identity Configuration${NC}"
    echo -e "${CYAN}═══════════════════════════════════════════════════════════════${NC}"
    echo ""
    echo -e "Git needs your name and email to identify your commits."
    echo -e "This is ${YELLOW}separate${NC} from GitHub authentication (handled with PAT)."
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
echo -e "${CYAN}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${YELLOW}GitHub Authentication Setup${NC}"
echo -e "${CYAN}═══════════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${GREEN}Recommended approach for GitHub (especially with SSO):${NC}"
echo ""
echo -e "1️⃣  ${CYAN}SSH Keys${NC} for Git operations (push/pull/clone)"
echo -e "   • Works immediately with SSO"
echo -e "   • Most secure and convenient"
echo -e "   • Never expires"
echo ""
echo -e "2️⃣  ${CYAN}Personal Access Token (PAT)${NC} for GitHub CLI"
echo -e "   • Required for SSO organizations"
echo -e "   • Enables 'gh' CLI features (PRs, issues, etc.)"
echo -e "   • Must be authorized for your SSO org"
echo ""
echo -e "${YELLOW}📖 Complete setup guide: docs/GITHUB_SETUP.md${NC}"
echo ""
echo -en "Do you have a ${YELLOW}Personal Access Token${NC} ready? (y/n): "
read pat_ready

if [[ $pat_ready =~ ^[Yy]$ ]]; then
    echo ""
    log_success "Great! You can authenticate GitHub CLI after installation:"
    echo ""
    echo -e "  ${CYAN}gh auth login${NC}"
    echo -e "  → Choose: GitHub.com"
    echo -e "  → Choose: HTTPS"
    echo -e "  → Choose: Paste an authentication token"
    echo -e "  → Paste your PAT"
    echo ""
    echo -e "  ${YELLOW}Don't forget to authorize your PAT for SSO:${NC}"
    echo -e "  https://github.com/settings/tokens → Configure SSO → Authorize"
    echo ""
else
    echo ""
    log_info "You'll need to set up GitHub authentication after installation."
    echo ""
    echo -e "${YELLOW}Quick setup checklist:${NC}"
    echo ""
    echo -e "1. Generate SSH key:"
    echo -e "   ${CYAN}ssh-keygen -t ed25519 -C \"your@email.com\"${NC}"
    echo -e "   ${CYAN}cat ~/.ssh/id_ed25519.pub${NC}  # Copy this"
    echo -e "   Add to: https://github.com/settings/keys"
    echo ""
    echo -e "2. Create Personal Access Token:"
    echo -e "   Go to: https://github.com/settings/tokens"
    echo -e "   Click: Generate new token (classic)"
    echo -e "   Scopes: ${CYAN}repo, read:org, read:user, workflow${NC}"
    echo ""
    echo -e "3. Authenticate GitHub CLI:"
    echo -e "   ${CYAN}gh auth login${NC}  # Use your PAT"
    echo ""
    echo -e "4. Authorize PAT for SSO (if applicable):"
    echo -e "   https://github.com/settings/tokens → Configure SSO"
    echo ""
    echo -e "${YELLOW}📖 Full guide: docs/GITHUB_SETUP.md${NC}"
    echo ""
fi

log_success "Essential development tools installed"

# ============================================================================
# SECTION 4: Shell Configuration
# ============================================================================

log_header "SECTION 4: Shell Configuration"

# Install zsh
log_info "Installing zsh..."
sudo apt install -y zsh
log_success "zsh installed"

# Install Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    log_info "Installing Oh My Zsh..."
    RUNZSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    log_success "Oh My Zsh installed"
else
    log_success "Oh My Zsh already installed"
fi

# Install zsh plugins
log_info "Installing zsh plugins..."
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions
fi

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
fi

log_success "zsh plugins installed"

# Install Starship prompt
brew_install_or_upgrade starship "Starship prompt"

# Configure Starship
log_info "Configuring Starship prompt..."
mkdir -p ~/.config
if [ -f "$REPO_ROOT/configs/starship.toml" ]; then
    cp "$REPO_ROOT/configs/starship.toml" ~/.config/starship.toml
    log_success "Starship configured"
else
    log_warning "Starship config not found, skipping..."
fi

# Install tmux
brew_install_or_upgrade tmux "tmux"

# Install TPM (Tmux Plugin Manager)
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    log_info "Installing Tmux Plugin Manager..."
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    log_success "TPM installed"
else
    log_success "TPM already installed"
fi

# Copy tmux configuration
if [ -f "$REPO_ROOT/configs/tmux.conf" ]; then
    log_info "Configuring tmux..."
    if [ -f ~/.tmux.conf ]; then
        cp ~/.tmux.conf ~/.tmux.conf.backup.$(date +%Y%m%d_%H%M%S)
    fi
    cp "$REPO_ROOT/configs/tmux.conf" ~/.tmux.conf
    log_success "tmux configured"
    log_warning "To install tmux plugins:"
    echo "  1. Start tmux: tmux"
    echo "  2. Press: Ctrl+b then Shift+I (capital I)"
    echo "  3. Wait for plugins to install"
    echo "  4. Detach: Ctrl+b then d"
else
    log_warning "tmux config not found, skipping..."
fi

# Copy zshrc configuration (WSL2-specific)
if [ -f "$REPO_ROOT/configs/zshrc.wsl2" ]; then
    log_info "Configuring zsh for WSL2..."
    if [ -f ~/.zshrc ]; then
        cp ~/.zshrc ~/.zshrc.backup.$(date +%Y%m%d_%H%M%S)
    fi
    cp "$REPO_ROOT/configs/zshrc.wsl2" ~/.zshrc
    log_success "zshrc configured for WSL2"
else
    log_warning "WSL2 zshrc config not found, skipping..."
fi

# Set zsh as default shell
if [ "$SHELL" != "$(which zsh)" ]; then
    log_info "Setting zsh as default shell..."
    chsh -s $(which zsh)
    log_success "zsh set as default shell"
else
    log_success "zsh already default shell"
fi

# ============================================================================
# SECTION 5: Neovim + LazyVim
# ============================================================================

log_header "SECTION 5: Neovim + LazyVim"

brew_install_or_upgrade neovim "Neovim"

if [ ! -d "$HOME/.config/nvim" ]; then
    log_info "Installing LazyVim..."
    git clone https://github.com/LazyVim/starter ~/.config/nvim
    rm -rf ~/.config/nvim/.git
    log_success "LazyVim installed"
else
    log_success "Neovim config already exists"
fi

# ============================================================================
# SECTION 6: Programming Languages & Version Managers
# ============================================================================

log_header "SECTION 6: Programming Languages"

# Python with pyenv
log_info "Installing pyenv..."
if [ ! -d "$HOME/.pyenv" ]; then
    curl https://pyenv.run | bash

    # Add pyenv to PATH
    cat >> ~/.bashrc << 'EOL'

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
EOL

    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init -)"

    log_success "pyenv installed"
else
    log_success "pyenv already installed"
fi

# Python tools (install pipx via Homebrew for Ubuntu 24.04 compatibility)
log_info "Installing pipx..."
brew_install_or_upgrade pipx "pipx"
pipx ensurepath

log_info "Installing Python tools..."
pipx install poetry 2>/dev/null || log_success "poetry already installed"
pipx install black 2>/dev/null || log_success "black already installed"
pipx install ruff 2>/dev/null || log_success "ruff already installed"
pipx install ipython 2>/dev/null || log_success "ipython already installed"

# Install uv (fast Python package installer)
if ! command -v uv >/dev/null 2>&1; then
    curl -LsSf https://astral.sh/uv/install.sh | sh
    log_success "uv installed"
else
    log_success "uv already installed"
fi

# Node.js with nvm
log_info "Installing nvm..."
if [ ! -d "$HOME/.nvm" ]; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash

    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

    nvm install --lts
    log_success "nvm and Node.js installed"
else
    log_success "nvm already installed"
fi

# ============================================================================
# SECTION 7: Cloud & Infrastructure Tools
# ============================================================================

log_header "SECTION 7: Cloud & Infrastructure Tools"

# AWS CLI (ensure unzip is available first)
log_info "Installing AWS CLI v2..."
if ! command -v aws >/dev/null 2>&1; then
    # Install unzip if not present
    if ! command -v unzip >/dev/null 2>&1; then
        log_info "Installing unzip..."
        sudo apt install -y unzip
    fi

    cd /tmp
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip -q awscliv2.zip
    sudo ./aws/install
    rm -rf aws awscliv2.zip
    cd -
    log_success "AWS CLI installed"
else
    log_success "AWS CLI already installed"
fi

# ============================================================================
# SECTION 8: Databases
# ============================================================================

log_header "SECTION 8: Databases"

# Ensure locale is set for PostgreSQL
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# PostgreSQL 16
log_info "Installing PostgreSQL 16..."
if brew_install_or_upgrade postgresql@16 "PostgreSQL 16"; then
    # Initialize database with correct locale
    log_info "Initializing PostgreSQL database..."
    brew postinstall postgresql@16 2>/dev/null || log_warning "PostgreSQL initialization completed with warnings"
fi

# pgvector
brew_install_or_upgrade pgvector "pgvector"

# Redis
brew_install_or_upgrade redis "Redis"

log_success "Databases installed"
log_info "To start PostgreSQL: brew services start postgresql@16"
log_info "To start Redis: brew services start redis"

# ============================================================================
# SECTION 9: AI/ML Tools (Optional)
# ============================================================================

if [ "$INSTALL_MODE" = "custom" ]; then
    echo ""
    echo -n "Install AI/ML development tools (Jupyter, Ollama, etc.)? (y/n): "
    read ai_tools_choice
    if [[ $ai_tools_choice =~ ^[Yy]$ ]]; then
        INSTALL_AI_TOOLS=true
    else
        INSTALL_AI_TOOLS=false
    fi
fi

if [ "$INSTALL_AI_TOOLS" = true ]; then
    log_header "SECTION 9: AI/ML Development Tools"

    # Jupyter
    log_info "Installing Jupyter Lab & Notebook..."
    pipx install jupyterlab 2>/dev/null || log_success "jupyterlab already installed"
    pipx install notebook 2>/dev/null || log_success "notebook already installed"
    pipx install jupyter 2>/dev/null || log_success "jupyter already installed"
    log_success "Jupyter installed"

    # Ollama
    if [ "$INSTALL_MODE" = "custom" ]; then
        echo ""
        echo -n "Install Ollama for local LLM testing? (y/n): "
        read ollama_choice
    else
        ollama_choice="y"
    fi

    if [[ $ollama_choice =~ ^[Yy]$ ]]; then
        brew_install_or_upgrade ollama "Ollama"
        log_info "Note: LM Studio should be installed on Windows for GPU access"
    else
        log_info "Skipping Ollama"
        log_info "Install LM Studio on Windows for local LLM testing with GPU"
    fi

    # httpie
    brew_install_or_upgrade httpie "httpie"

    # Monitoring tools
    log_info "Installing monitoring tools..."
    brew_install_or_upgrade glances "glances"
    brew_install_or_upgrade bottom "bottom"

    # Documentation tools
    log_info "Installing documentation tools..."
    brew_install_or_upgrade mermaid-cli "mermaid-cli"
    brew_install_or_upgrade graphviz "graphviz"

    log_success "AI/ML tools installed"
fi

# ============================================================================
# SECTION 10: Optional Tools
# ============================================================================

if [ "$INSTALL_MODE" = "custom" ] || [ "$INSTALL_MODE" = "full" ]; then
    log_header "SECTION 10: Optional Tools"

    # Kubernetes tools
    if [ "$INSTALL_MODE" = "full" ]; then
        k8s_choice="y"
    else
        echo ""
        echo -n "Install Kubernetes tools (k9s, kubectx, stern)? (y/n): "
        read k8s_choice
    fi

    if [[ $k8s_choice =~ ^[Yy]$ ]]; then
        log_info "Installing Kubernetes tools..."
        brew_install_or_upgrade k9s "k9s"
        brew_install_or_upgrade kubectx "kubectx"
        brew_install_or_upgrade stern "stern"
        log_success "Kubernetes tools installed"
    fi

    # Terraform tools
    if [ "$INSTALL_MODE" = "full" ]; then
        iac_choice="y"
    else
        echo ""
        echo -n "Install IaC tools (tfenv, tflint, terraform-docs)? (y/n): "
        read iac_choice
    fi

    if [[ $iac_choice =~ ^[Yy]$ ]]; then
        log_info "Installing IaC tools..."
        brew_install_or_upgrade tfenv "tfenv"
        brew_install_or_upgrade tflint "tflint"
        brew_install_or_upgrade terraform-docs "terraform-docs"
        log_success "IaC tools installed"
    fi

    # Git LFS
    if [ "$INSTALL_MODE" = "full" ]; then
        lfs_choice="y"
    else
        echo ""
        echo -n "Install Git LFS (for versioning large files)? (y/n): "
        read lfs_choice
    fi

    if [[ $lfs_choice =~ ^[Yy]$ ]]; then
        brew_install_or_upgrade git-lfs "Git LFS"
        git lfs install
        log_success "Git LFS installed"
    fi
fi

# ============================================================================
# COMPLETION
# ============================================================================

clear
echo -e "${GREEN}"
cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║                                                              ║
║          ✅ Installation Complete!                          ║
║                                                              ║
╚══════════════════════════════════════════════════════════════╝
EOF
echo -e "${NC}"

echo ""
echo -e "${CYAN}🎉 Your WSL2 development environment is ready!${NC}"
echo ""

echo -e "${GREEN}Next Steps:${NC}"
echo ""
echo -e "1. Reload your shell:"
echo -e "   ${CYAN}source ~/.zshrc${NC}"
echo -e "   Or close and reopen your terminal"
echo ""
echo -e "2. Install tmux plugins (one-time setup):"
echo -e "   ${CYAN}tmux${NC}                           # Start tmux"
echo -e "   Press: ${CYAN}Ctrl+b then Shift+I${NC}      # Install plugins"
echo -e "   Press: ${CYAN}Ctrl+b then d${NC}            # Detach from tmux"
echo ""
echo -e "3. Set up GitHub authentication (SSH keys + GitHub CLI):"
echo -e "   ${CYAN}ssh-keygen -t ed25519 -C \"your@email.com\"${NC}"
echo -e "   ${CYAN}cat ~/.ssh/id_ed25519.pub${NC}     # Copy and add to GitHub"
echo -e "   https://github.com/settings/keys"
echo ""
echo -e "4. Configure Git:"
echo -e "   ${CYAN}git config --global user.name \"Your Name\"${NC}"
echo -e "   ${CYAN}git config --global user.email \"your@email.com\"${NC}"
echo -e "   ${CYAN}ssh -T git@github.com${NC}         # Test SSH connection"
echo ""
echo -e "5. Authenticate GitHub CLI:"
echo -e "   ${CYAN}gh auth login${NC}"
echo -e "   ${YELLOW}For Google SSO: Use Personal Access Token (see docs/GITHUB_SETUP.md)${NC}"
echo ""
echo -e "6. Create your projects directory:"
echo -e "   ${CYAN}mkdir -p ~/projects${NC}"
echo -e "   ${CYAN}cd ~/projects${NC}"
echo ""
echo -e "7. ${YELLOW}[PREREQUISITE]${NC} Install WSL extension and connect to WSL2:"
echo -e "   ${YELLOW}   On Windows, open VS Code → Extensions (Ctrl+Shift+X)${NC}"
echo -e "   ${YELLOW}   Search and install: 'WSL' (by Microsoft)${NC}"
echo -e "   ${YELLOW}   Press F1 → 'WSL: Connect to WSL' → Select 'Ubuntu-24.04'${NC}"
echo -e "   ${YELLOW}   This is REQUIRED for VS Code to connect to WSL2${NC}"
echo ""
echo -e "8. ${YELLOW}[IMPORTANT]${NC} Set up VS Code Server in WSL2 (after step 7):"
echo -e "   ${CYAN}cd ~/terminal-setup${NC}"
echo -e "   ${CYAN}code .${NC}                         # Opens VS Code, installs VS Code Server in WSL2"
echo -e "   ${YELLOW}   Wait for VS Code Server to install (~30 seconds)${NC}"
echo ""
echo -e "9. Install VS Code extensions (after step 8):"
echo -e "   ${CYAN}cd ~/terminal-setup${NC}"
echo -e "   ${CYAN}./scripts/install-vscode-extensions.sh${NC}"
echo -e "   ${YELLOW}   This installs 21 extensions from configs/vscode-extensions.txt${NC}"
echo ""

if [ "$INSTALL_AI_TOOLS" = true ]; then
    echo ""
    echo -e "${YELLOW}🤖 AI/ML Tools Installed:${NC}"
    echo ""
    echo -e "• Jupyter Lab: ${CYAN}jupyter lab${NC}"
    echo -e "• Jupyter Notebook: ${CYAN}jupyter notebook${NC}"

    if is_brew_installed ollama; then
        echo ""
        echo -e "• Ollama:"
        echo -e "  ${CYAN}ollama pull llama2${NC}       # Download a model"
        echo -e "  ${CYAN}ollama run llama2${NC}        # Run locally"
        echo -e "  ${CYAN}ollama serve${NC}             # Start API (localhost:11434)"
    fi

    echo ""
    echo -e "• LM Studio: Install on Windows for full GPU access"
    echo -e "  Download: https://lmstudio.ai/"
    echo -e "  After starting server, access from WSL2: ${CYAN}curl http://localhost:1234/v1/models${NC}"
fi

echo ""
echo -e "${YELLOW}📝 Important Notes:${NC}"
echo ""
echo -e "• Store your projects in WSL2: ${CYAN}~/projects/${NC} (fast performance)"
echo -e "• Access WSL2 from Windows: ${CYAN}\\\\wsl\$\\Ubuntu-24.04\\home\\yourusername${NC}"
echo -e "• Docker: Install Docker Desktop on Windows with WSL2 integration"
echo -e "• VS Code workflow:"
echo -e "  ${YELLOW}1. Install WSL extension + F1 connect to WSL2 (see step 7)${NC}"
echo -e "  ${YELLOW}2. Run 'code .' from WSL2 to install VS Code Server (see step 8)${NC}"
echo -e "  ${YELLOW}3. Install extensions via script (see step 9)${NC}"
echo -e "• Ports from WSL2 are automatically forwarded to Windows"
echo ""

echo -e "${CYAN}📚 Documentation:${NC}"
echo ""
echo -e "• Full setup guide: ${CYAN}$(pwd)/README.md${NC}"
echo -e "• Main project README: ${CYAN}$REPO_ROOT/README.md${NC}"
echo -e "• Windows setup: ${CYAN}$REPO_ROOT/windows/README.md${NC}"
echo ""

echo -e "${GREEN}🚀 Ready to code with Claude Code!${NC}"
echo ""
echo -e "Try: ${CYAN}claude \"help me set up a Python project\"${NC}"
echo ""

echo -e "${YELLOW}💡 Tip: Restart your terminal to ensure all changes take effect${NC}"
echo ""
