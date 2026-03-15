#!/bin/bash

# WSL2 Terminal Setup - Uninstaller
# Author: Alex Ciortan
# Platform: WSL2 Ubuntu 24.04
# Removes configurations and optionally tools

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

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

log_info() { echo -e "${BLUE}ℹ️  $1${NC}"; }
log_success() { echo -e "${GREEN}✅ $1${NC}"; }
log_warning() { echo -e "${YELLOW}⚠️  $1${NC}"; }
log_error() { echo -e "${RED}❌ $1${NC}"; }

clear
echo -e "${RED}"
cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║                                                              ║
║          WSL2 Terminal Setup - Uninstaller                  ║
║                                                              ║
╚══════════════════════════════════════════════════════════════╝
EOF
echo -e "${NC}"

# Verify we're running in WSL2
if ! grep -qi microsoft /proc/version; then
    log_error "This script must be run in WSL2"
    exit 1
fi

log_success "Running in WSL2 environment"
echo ""

echo -e "${YELLOW}This will remove terminal setup configurations from WSL2.${NC}"
echo ""
echo -e "${CYAN}Important:${NC} This only removes WSL2 configurations and tools."
echo "Windows applications (VS Code, Docker Desktop, LM Studio) are not affected."
echo ""
echo "What to remove:"
echo "  [1] Just config files (keep tools installed)"
echo "  [2] Config files + tmux plugins"
echo "  [3] Everything (configs + all installed tools)"
echo "  [0] Cancel"
echo ""
echo -n "Enter your choice [0-3]: "
read choice

if [ "$choice" = "0" ]; then
    echo "Cancelled."
    exit 0
fi

# If removing everything, ask for sudo upfront
if [ "$choice" = "3" ]; then
    echo ""
    log_info "Some uninstallations require administrator access."
    log_info "Please enter your password if prompted:"
    sudo -v

    # Keep sudo alive in background
    if sudo -n true 2>/dev/null; then
        (
            while true; do
                sudo -n true
                sleep 50
            done
        ) &
    fi
fi

# Create final backup before removal
FINAL_BACKUP="$HOME/.config_final_backup_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$FINAL_BACKUP"

log_info "Creating final backup at: $FINAL_BACKUP"

# Backup configs
[ -f ~/.zshrc ] && cp ~/.zshrc "$FINAL_BACKUP/"
[ -f ~/.tmux.conf ] && cp ~/.tmux.conf "$FINAL_BACKUP/"
[ -f ~/.config/starship.toml ] && cp ~/.config/starship.toml "$FINAL_BACKUP/"
[ -d ~/.config/nvim ] && cp -r ~/.config/nvim "$FINAL_BACKUP/"

log_success "Backup created"

# Remove config files
if [ "$choice" -ge 1 ]; then
    log_info "Removing configuration files..."

    # Restore from oldest backup if exists
    OLDEST_BACKUP=$(ls -dt ~/.config_backup_* 2>/dev/null | tail -1)
    if [ -n "$OLDEST_BACKUP" ]; then
        log_info "Found backup: $OLDEST_BACKUP"
        echo -n "Restore from backup? (y/n): "
        read restore
        if [[ $restore =~ ^[Yy]$ ]]; then
            [ -f "$OLDEST_BACKUP/.zshrc" ] && cp "$OLDEST_BACKUP/.zshrc" ~/.zshrc
            [ -f "$OLDEST_BACKUP/.tmux.conf" ] && cp "$OLDEST_BACKUP/.tmux.conf" ~/.tmux.conf
            log_success "Restored from backup"
        fi
    else
        # Just remove the files
        rm -f ~/.zshrc
        rm -f ~/.tmux.conf
        rm -f ~/.config/starship.toml
        log_success "Configuration files removed"
    fi
fi

# Remove tmux plugins
if [ "$choice" -ge 2 ]; then
    log_info "Removing tmux plugins..."
    rm -rf ~/.tmux/plugins
    log_success "Tmux plugins removed"
fi

# Remove all tools (dangerous!)
if [ "$choice" = "3" ]; then
    log_warning "This will uninstall ALL tools and configs from WSL2. Are you SURE?"
    echo ""
    echo -e "${CYAN}This removes:${NC}"
    echo "  • Homebrew and all packages installed via Homebrew"
    echo "  • System packages (zsh, tmux, neovim)"
    echo "  • Python (pyenv), Node.js (nvm)"
    echo "  • Databases (PostgreSQL, Redis)"
    echo "  • All configuration files"
    echo ""
    echo -e "${YELLOW}Windows applications (VS Code, Docker Desktop) are NOT removed.${NC}"
    echo ""
    echo -n "Type 'DELETE' to confirm complete removal: "
    read confirm

    if [ "$confirm" = "DELETE" ]; then
        log_info "Uninstalling everything from WSL2..."
        echo ""

        # Stop services first
        log_info "Stopping services..."
        command -v brew &> /dev/null && {
            brew services list | grep started | awk '{print $1}' | while read service; do
                brew services stop "$service" 2>/dev/null || true
            done
        }

        # Core development tools
        if command -v brew &> /dev/null; then
            log_info "Removing Homebrew packages..."

            # Essential dev tools
            for pkg in git gh lazygit git-delta claude-code ripgrep fd bat eza zoxide fzf jq yq; do
                brew list "$pkg" &> /dev/null && brew uninstall "$pkg" 2>/dev/null || true
            done

            # Terminal tools
            for pkg in tmux neovim starship atuin; do
                brew list "$pkg" &> /dev/null && brew uninstall "$pkg" 2>/dev/null || true
            done

            # Python tools
            for pkg in pyenv pipx uv poetry; do
                brew list "$pkg" &> /dev/null && brew uninstall "$pkg" 2>/dev/null || true
            done

            # Databases
            for pkg in postgresql@16 redis pgvector; do
                brew list "$pkg" &> /dev/null && brew uninstall "$pkg" 2>/dev/null || true
            done

            # AI/ML tools
            for pkg in ollama httpie glances bottom mermaid-cli graphviz; do
                brew list "$pkg" &> /dev/null && brew uninstall "$pkg" 2>/dev/null || true
            done

            # Optional tools
            for pkg in k9s kubectx stern tfenv tflint terraform-docs git-lfs; do
                brew list "$pkg" &> /dev/null && brew uninstall "$pkg" 2>/dev/null || true
            done

            # Claude Code tap
            brew list claude-code &> /dev/null && brew uninstall claude-code 2>/dev/null || true
            brew untap anthropics/claude &> /dev/null || true

            # AWS CLI (if installed via Homebrew)
            brew list awscli &> /dev/null && brew uninstall awscli 2>/dev/null || true

            log_success "Homebrew packages removed"

            # Remove Homebrew itself
            echo ""
            log_warning "Remove Homebrew package manager itself?"
            echo "This is the last Homebrew step. You can reinstall it easily later."
            echo -n "Remove Homebrew? (y/n): "
            read remove_brew
            if [[ $remove_brew =~ ^[Yy]$ ]]; then
                log_info "Removing Homebrew..."
                /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)" -- --force 2>/dev/null || true
                rm -rf /home/linuxbrew/.linuxbrew 2>/dev/null || true
                log_success "Homebrew removed"
            else
                log_info "Keeping Homebrew installed"
            fi
        else
            log_info "Homebrew not found, skipping..."
        fi

        # System packages installed via apt
        echo ""
        log_info "Removing system packages..."
        log_warning "This will remove zsh (your shell will revert to bash)"
        echo -n "Remove system packages (zsh, build-essential)? (y/n): "
        read remove_apt
        if [[ $remove_apt =~ ^[Yy]$ ]]; then
            sudo apt remove -y zsh build-essential 2>/dev/null || true
            sudo apt autoremove -y 2>/dev/null || true
            log_success "System packages removed"
            log_warning "Your shell is now bash. Close and reopen terminal."
        else
            log_info "Keeping system packages"
        fi

        # Version managers
        echo ""
        log_info "Removing version managers..."
        rm -rf ~/.nvm
        rm -rf ~/.pyenv
        log_success "Version managers removed"

        # Zsh plugins and Oh My Zsh
        log_info "Removing Oh My Zsh and plugins..."
        rm -rf ~/.oh-my-zsh
        rm -rf ~/.zsh
        log_success "Zsh components removed"

        # Pipx installed tools
        log_info "Removing pipx tools..."
        command -v pipx &> /dev/null && pipx uninstall-all 2>/dev/null || true

        # Jupyter (if installed)
        command -v jupyter &> /dev/null && pipx uninstall jupyterlab 2>/dev/null || true
        command -v jupyter &> /dev/null && pipx uninstall notebook 2>/dev/null || true

        # Neovim config
        log_info "Removing Neovim config..."
        rm -rf ~/.config/nvim
        rm -rf ~/.local/share/nvim
        rm -rf ~/.local/state/nvim
        rm -rf ~/.cache/nvim

        # Tmux config and plugins
        log_info "Removing Tmux configuration..."
        rm -rf ~/.tmux
        rm -f ~/.tmux.conf

        # AWS CLI (if installed manually)
        if [ -d "/usr/local/aws-cli" ]; then
            log_info "Removing AWS CLI..."
            sudo rm -rf /usr/local/aws-cli
            sudo rm -f /usr/local/bin/aws
            sudo rm -f /usr/local/bin/aws_completer
        fi

        # Other configs
        log_info "Removing other configurations..."
        rm -rf ~/.config/starship.toml
        rm -rf ~/.config/atuin

        log_success "All WSL2 tools and configs uninstalled"
    else
        log_info "Uninstall cancelled (you must type DELETE to confirm)"
    fi
fi

echo ""
log_success "Uninstall complete!"
echo ""
echo "Your final backup is at: ${BLUE}$FINAL_BACKUP${NC}"
echo ""

if [ "$choice" = "3" ] && [ "$confirm" = "DELETE" ]; then
    echo -e "${CYAN}═══════════════════════════════════════════════════════════════${NC}"
    echo -e "${YELLOW}Post-Uninstall Notes:${NC}"
    echo -e "${CYAN}═══════════════════════════════════════════════════════════════${NC}"
    echo ""
    echo "WSL2 Environment:"
    echo "  • Close and reopen your terminal if you removed zsh"
    echo "  • Your default shell is now bash"
    echo "  • To reinstall, run the installer again"
    echo ""
    echo "Windows Applications (NOT removed):"
    echo "  • VS Code - Still installed on Windows"
    echo "  • Docker Desktop - Still installed on Windows"
    echo "  • LM Studio - Still installed on Windows (if you had it)"
    echo "  • Windows Terminal - Still installed"
    echo ""
    echo "To remove Windows applications:"
    echo "  • Use Windows Settings → Apps → Installed Apps"
    echo "  • Or use: ${CYAN}winget uninstall <app-name>${NC} in PowerShell"
    echo ""
    echo "To completely remove WSL2 (from Windows PowerShell as Admin):"
    echo "  ${CYAN}wsl --unregister Ubuntu-24.04${NC}"
    echo "  ${RED}⚠️  This deletes the entire WSL2 instance!${NC}"
    echo ""
fi

echo "Done! 🎉"
echo ""
