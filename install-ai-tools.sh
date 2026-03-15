#!/bin/bash

# AI Development Tools Installer
# Optional extension for terminal-setup
# Author: Alex Ciortan

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

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

log_info() { echo -e "${BLUE}ℹ️  $1${NC}"; }
log_success() { echo -e "${GREEN}✅ $1${NC}"; }
log_warning() { echo -e "${YELLOW}⚠️  $1${NC}"; }
log_error() { echo -e "${RED}❌ $1${NC}"; }

# Helper function to check if a brew package is installed
is_brew_installed() {
    brew list "$1" &> /dev/null
}

# Helper function to check if a cask/app is installed
is_app_installed() {
    local app_name="$1"
    [ -d "/Applications/${app_name}.app" ]
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

# Helper function to install or skip cask applications
brew_cask_install_or_skip() {
    local cask=$1
    local app_name=$2
    local display_name=${3:-$app_name}

    if is_app_installed "$app_name"; then
        log_success "$display_name already installed"
        return 0
    fi

    log_info "Installing $display_name..."
    if brew install --cask "$cask"; then
        log_success "$display_name installed"
        return 0
    else
        log_error "Failed to install $display_name"
        return 1
    fi
}

clear
echo -e "${CYAN}"
cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║                                                              ║
║          AI Development Tools - Optional Installer          ║
║                                                              ║
╚══════════════════════════════════════════════════════════════╝
EOF
echo -e "${NC}"

echo "This installs AI-specific development tools:"
echo ""
echo "  • Jupyter Lab & Notebooks"
echo "  • Ollama (local LLM testing)"
echo "  • Vector database tools (pgvector)"
echo "  • API testing (httpie, Insomnia)"
echo "  • Performance monitoring (glances)"
echo "  • Database GUI (DBeaver)"
echo "  • Documentation tools (mermaid, graphviz)"
echo ""
echo -e "${YELLOW}Note: These are additions to the base terminal setup.${NC}"
echo -e "${YELLOW}Run the main install.sh first if you haven't already.${NC}"
echo ""
echo "Installation mode:"
echo "  [1] Install everything (non-interactive, recommended)"
echo "  [2] Interactive installation (choose each tool)"
echo "  [0] Cancel"
echo ""
echo -n "Choose [0-2]: "
read install_mode

case $install_mode in
    0)
        echo "Cancelled."
        exit 0
        ;;
    1)
        INSTALL_ALL=true
        log_info "Installing all AI development tools..."
        ;;
    2)
        INSTALL_ALL=false
        log_info "Starting interactive installation..."
        ;;
    *)
        echo "Invalid choice. Cancelled."
        exit 0
        ;;
esac

echo ""
log_info "Starting AI tools installation..."

# Update Homebrew
log_info "Updating Homebrew..."
if ! brew update 2>&1 | tee /tmp/brew_update_ai.log; then
    # Check if it's a tap issue
    if grep -q "anthropics/homebrew-claude" /tmp/brew_update_ai.log; then
        log_warning "Homebrew tap issue detected, cleaning up anthropics/claude tap..."
        brew untap anthropics/claude 2>/dev/null || true
        log_info "Retrying Homebrew update..."
        brew update || log_warning "Homebrew update had issues, continuing anyway..."
    else
        log_warning "Homebrew update had issues, continuing anyway..."
    fi
fi
rm -f /tmp/brew_update_ai.log
log_success "Homebrew ready"

# ============================================================================
# P0 - CRITICAL TOOLS
# ============================================================================

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "P0 - Critical AI Development Tools"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Jupyter
log_info "Installing Jupyter Lab & Notebook..."
if pipx list | grep -q jupyterlab; then
    log_success "JupyterLab already installed"
else
    pipx install jupyterlab
    pipx install notebook
    log_success "Jupyter installed"
fi

# Local LLM Tools
echo ""
log_info "Installing local LLM tools..."

if [ "$INSTALL_ALL" = true ]; then
    llm_choice=3  # Install both
    log_info "Installing both Ollama and LM Studio..."
else
    echo "  [1] Ollama only (CLI, scriptable)"
    echo "  [2] LM Studio only (GUI, easier)"
    echo "  [3] Both (recommended)"
    echo "  [4] Skip"
    echo -n "Choose [1-4]: "
    read llm_choice
fi

case $llm_choice in
    1|3)
        if is_brew_installed ollama; then
            log_success "Ollama already installed"
        else
            brew install ollama
            log_success "Ollama installed"
        fi
        ;;
esac

case $llm_choice in
    2|3)
        if is_app_installed "LM Studio"; then
            log_success "LM Studio already installed"
        else
            brew install --cask lm-studio
            log_success "LM Studio installed"
        fi
        ;;
    4) log_info "Skipping local LLM tools" ;;
esac

# pgvector
log_info "Installing pgvector (PostgreSQL vector extension)..."
if is_brew_installed pgvector; then
    log_success "pgvector already installed"
else
    brew install pgvector
    log_success "pgvector installed"
fi

# httpie
log_info "Installing httpie (better HTTP client)..."
if is_brew_installed httpie; then
    log_success "httpie already installed"
else
    brew install httpie
    log_success "httpie installed"
fi

# ============================================================================
# P1 - HIGHLY RECOMMENDED
# ============================================================================

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "P1 - Highly Recommended Tools"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# API Testing
echo ""
log_info "Installing API testing tool..."

if [ "$INSTALL_ALL" = true ]; then
    api_choice=1  # Install Insomnia (simpler, free)
    log_info "Installing Insomnia..."
else
    echo "  [1] Insomnia (free, simpler)"
    echo "  [2] Postman (more features)"
    echo "  [3] Skip"
    echo -n "Choose [1-3]: "
    read api_choice
fi

case $api_choice in
    1)
        if is_app_installed "Insomnia"; then
            log_success "Insomnia already installed"
        else
            brew install --cask insomnia
            log_success "Insomnia installed"
        fi
        ;;
    2)
        if is_app_installed "Postman"; then
            log_success "Postman already installed"
        else
            brew install --cask postman
            log_success "Postman installed"
        fi
        ;;
    3) log_info "Skipping API testing tool" ;;
esac

# System Monitoring
log_info "Installing system monitoring tools..."
if is_brew_installed glances; then
    log_success "glances already installed"
else
    brew install glances
    log_success "glances installed"
fi

if is_brew_installed bottom; then
    log_success "bottom already installed"
else
    brew install bottom
    log_success "bottom installed"
fi

# Database GUI
log_info "Installing DBeaver (database GUI)..."
if is_app_installed "DBeaver"; then
    log_success "DBeaver already installed"
else
    brew install --cask dbeaver-community
    log_success "DBeaver installed"
fi

# Documentation tools
log_info "Installing documentation tools..."
if is_brew_installed mermaid-cli; then
    log_success "mermaid-cli already installed"
else
    brew install mermaid-cli
    log_success "mermaid-cli installed"
fi

if is_brew_installed graphviz; then
    log_success "graphviz already installed"
else
    brew install graphviz
    log_success "graphviz installed"
fi

# ============================================================================
# OPTIONAL - KUBERNETES & IaC
# ============================================================================

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Optional Tools"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Kubernetes
echo ""
if [ "$INSTALL_ALL" = true ]; then
    k8s_choice="y"
    log_info "Installing Kubernetes tools..."
else
    echo -n "Install Kubernetes tools (k9s, kubectx, stern)? (y/n): "
    read k8s_choice
fi

if [[ $k8s_choice =~ ^[Yy]$ ]]; then
    log_info "Installing Kubernetes tools..."
    for tool in k9s kubectx stern; do
        if is_brew_installed $tool; then
            log_success "$tool already installed"
        else
            brew install $tool
        fi
    done
    log_success "Kubernetes tools installed"
fi

# Infrastructure as Code
echo ""
if [ "$INSTALL_ALL" = true ]; then
    iac_choice="y"
    log_info "Installing IaC tools..."
else
    echo -n "Install IaC tools (tfenv, tflint, terraform-docs)? (y/n): "
    read iac_choice
fi

if [[ $iac_choice =~ ^[Yy]$ ]]; then
    log_info "Installing IaC tools..."
    for tool in tfenv tflint terraform-docs; do
        if is_brew_installed $tool; then
            log_success "$tool already installed"
        else
            brew install $tool
        fi
    done
    log_success "IaC tools installed"
fi

# Git LFS
echo ""
if [ "$INSTALL_ALL" = true ]; then
    lfs_choice="y"
    log_info "Installing Git LFS..."
else
    echo -n "Install Git LFS (for versioning large AI models)? (y/n): "
    read lfs_choice
fi

if [[ $lfs_choice =~ ^[Yy]$ ]]; then
    if is_brew_installed git-lfs; then
        log_success "git-lfs already installed"
    else
        brew install git-lfs
        git lfs install
        log_success "Git LFS installed"
    fi
fi

# ============================================================================
# POST-INSTALLATION
# ============================================================================

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ AI Tools Installation Complete!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

echo -e "${GREEN}Installed Tools:${NC}"
echo ""
echo "🧪 Jupyter:"
echo "   $ jupyter lab              # Start Jupyter Lab"
echo "   $ jupyter notebook        # Classic notebook"
echo ""

if is_brew_installed ollama; then
    echo "🤖 Ollama (CLI):"
    echo "   $ ollama pull llama2     # Download a model"
    echo "   $ ollama run llama2      # Run locally"
    echo "   $ ollama serve           # Start API server (localhost:11434)"
    echo ""
fi

if is_app_installed "LM Studio"; then
    echo "🎨 LM Studio (GUI):"
    echo "   • Open from Applications folder"
    echo "   • Browse and download models in GUI"
    echo "   • Start local server (localhost:1234)"
    echo "   • Chat interface for testing"
    echo ""
fi

echo "🔌 API Testing:"
echo "   $ http GET https://api.example.com"
echo "   $ http POST :8000/api/chat content='hello'"
echo ""

echo "📊 Monitoring:"
echo "   $ glances                  # System monitor"
echo "   $ btm                      # Bottom (Rust monitor)"
echo ""

echo "🗃️ Database:"
echo "   • DBeaver in Applications"
echo "   • pgvector extension available for PostgreSQL"
echo ""

if is_brew_installed mermaid-cli; then
    echo "📝 Documentation:"
    echo "   $ mmdc -i diagram.mmd -o diagram.png"
    echo ""
fi

echo -e "${CYAN}Next Steps:${NC}"
echo ""
echo "1. Install per-project AI libraries:"
echo "   $ uv venv"
echo "   $ source .venv/bin/activate"
echo "   $ uv pip install anthropic boto3 langchain"
echo ""

echo "2. Configure pgvector in PostgreSQL:"
echo "   $ psql"
echo "   CREATE EXTENSION vector;"
echo ""

echo "3. Download models for local LLM testing:"
if is_brew_installed ollama; then
    echo "   Ollama: $ ollama pull llama2"
fi
if is_app_installed "LM Studio"; then
    echo "   LM Studio: Browse models in the GUI"
fi
echo ""

echo "4. Try Jupyter Lab:"
echo "   $ jupyter lab"
echo ""

if is_brew_installed ollama && is_app_installed "LM Studio"; then
    echo "5. Test both LLM tools:"
    echo "   Ollama: $ ollama run llama2"
    echo "   LM Studio: Open app and chat with models"
    echo ""
fi

echo -e "${YELLOW}📚 See docs/RECOMMENDED_ADDITIONS.md for more details!${NC}"
echo ""
