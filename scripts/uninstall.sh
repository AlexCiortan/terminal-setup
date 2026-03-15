#!/bin/bash

# Terminal Setup - Uninstaller
# Author: Alex Ciortan
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
NC='\033[0m'

log_info() { echo -e "${BLUE}ℹ️  $1${NC}"; }
log_success() { echo -e "${GREEN}✅ $1${NC}"; }
log_warning() { echo -e "${YELLOW}⚠️  $1${NC}"; }

clear
echo -e "${RED}"
cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║                                                              ║
║              Terminal Setup - Uninstaller                   ║
║                                                              ║
╚══════════════════════════════════════════════════════════════╝
EOF
echo -e "${NC}"

echo -e "${YELLOW}This will remove terminal setup configurations.${NC}"
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
    echo -e "${BLUE}ℹ️  Some uninstallations require administrator access.${NC}"
    echo -e "${BLUE}ℹ️  Please enter your password if prompted:${NC}"
    sudo -v

    # Keep sudo alive in background (save PID to kill later)
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
[ -f ~/.config/ghostty/config ] && cp ~/.config/ghostty/config "$FINAL_BACKUP/"
[ -d ~/.config/gh-dash ] && cp -r ~/.config/gh-dash "$FINAL_BACKUP/"
[ -d ~/.config/aerospace ] && cp -r ~/.config/aerospace "$FINAL_BACKUP/"

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
        rm -rf ~/.config/ghostty
        rm -rf ~/.config/gh-dash
        rm -rf ~/.config/aerospace
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
    log_warning "This will uninstall ALL tools and configs. Are you SURE?"
    echo -n "Type 'DELETE' to confirm complete removal: "
    read confirm

    if [ "$confirm" = "DELETE" ]; then
        log_info "Uninstalling everything..."
        echo ""

        # Core development tools
        log_info "Removing core tools..."
        for pkg in git gh lazygit git-delta ripgrep fd tree htop glow jq yq shellcheck shfmt watch wget curl; do
            brew list "$pkg" &> /dev/null && brew uninstall "$pkg" 2>/dev/null || true
        done

        # Terminal tools
        log_info "Removing terminal tools..."
        for pkg in tmux neovim starship atuin zoxide fzf bat eza; do
            brew list "$pkg" &> /dev/null && brew uninstall "$pkg" 2>/dev/null || true
        done

        # Fonts
        log_info "Removing fonts..."
        brew list --cask font-jetbrains-mono &> /dev/null && brew uninstall --cask font-jetbrains-mono 2>/dev/null || true

        # Python tools
        log_info "Removing Python tools..."
        for pkg in pyenv pipx uv; do
            brew list "$pkg" &> /dev/null && brew uninstall "$pkg" 2>/dev/null || true
        done

        # AWS CLI
        log_info "Removing AWS CLI..."
        brew list awscli &> /dev/null && brew uninstall awscli 2>/dev/null || true

        # Databases
        log_info "Removing databases..."
        for pkg in postgresql@16 redis; do
            brew list "$pkg" &> /dev/null && brew uninstall "$pkg" 2>/dev/null || true
        done

        # Optional tools
        log_info "Removing optional tools..."
        brew list gh-dash &> /dev/null && brew uninstall gh-dash 2>/dev/null || true

        # GUI Applications (no prompt - removing everything!)
        log_info "Removing GUI applications..."
        brew list --cask docker &> /dev/null && sudo brew uninstall --cask docker 2>/dev/null || true
        brew list --cask visual-studio-code &> /dev/null && sudo brew uninstall --cask visual-studio-code 2>/dev/null || true
        brew list --cask google-chrome &> /dev/null && sudo brew uninstall --cask google-chrome 2>/dev/null || true
        brew list --cask ghostty &> /dev/null && sudo brew uninstall --cask ghostty 2>/dev/null || true
        brew list --cask nikitabobko/tap/aerospace &> /dev/null && sudo brew uninstall --cask aerospace 2>/dev/null || true

        # Claude Code CLI
        log_info "Removing Claude Code CLI..."
        brew list claude-code &> /dev/null && brew uninstall claude-code 2>/dev/null || true
        brew untap anthropics/claude &> /dev/null || true

        # Version managers (no prompts - removing everything!)
        log_info "Removing version managers..."
        rm -rf ~/.nvm
        rm -rf ~/.pyenv

        # Zsh plugins
        log_info "Removing Zsh plugins..."
        rm -rf ~/.zsh

        # Pipx installed tools
        log_info "Removing pipx tools..."
        command -v pipx &> /dev/null && pipx uninstall-all 2>/dev/null || true

        # Neovim config
        log_info "Removing Neovim config..."
        rm -rf ~/.config/nvim

        log_success "All tools and configs uninstalled"
    else
        log_info "Uninstall cancelled (you must type DELETE to confirm)"
    fi
fi

echo ""
log_success "Uninstall complete!"
echo ""
echo "Your final backup is at: ${BLUE}$FINAL_BACKUP${NC}"
echo ""
