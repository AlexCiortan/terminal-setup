#!/bin/bash

# VS Code Extensions Installer
# Installs extensions from configs/vscode-extensions.txt
# Author: Alex Ciortan

# Ensure script runs with bash
if [ -z "$BASH_VERSION" ]; then
    if command -v bash >/dev/null 2>&1; then
        exec bash "$0" "$@"
    else
        echo "Error: bash is required but not found in PATH"
        exit 1
    fi
fi

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() { echo -e "${BLUE}ℹ️  $1${NC}"; }
log_success() { echo -e "${GREEN}✅ $1${NC}"; }
log_warning() { echo -e "${YELLOW}⚠️  $1${NC}"; }
log_error() { echo -e "${RED}❌ $1${NC}"; }

# Determine script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_FILE="$SCRIPT_DIR/../configs/vscode-extensions.txt"

# Check if config file exists
if [ ! -f "$CONFIG_FILE" ]; then
    log_error "Config file not found: $CONFIG_FILE"
    exit 1
fi

echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}    VS Code Extensions Installer${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Check if VS Code CLI is available
if ! command -v code &> /dev/null; then
    log_error "VS Code 'code' command not found"
    echo ""

    # Detect if running in WSL2
    if grep -qi microsoft /proc/version 2>/dev/null; then
        echo "You're running in WSL2. To use this script:"
        echo ""
        echo "1. Install VS Code on Windows (if not already installed)"
        echo "2. Install the 'WSL' extension in VS Code"
        echo "3. Connect VS Code to WSL2:"
        echo "   - Press F1 in VS Code"
        echo "   - Type 'WSL: Connect to WSL'"
        echo "   - Select 'Ubuntu-24.04'"
        echo ""
        echo "4. From WSL2 terminal, run: cd ~/terminal_setup && code ."
        echo "   (This installs VS Code Server in WSL2)"
        echo ""
        echo "5. Wait ~30 seconds for VS Code Server to install"
        echo "6. Run this script again"
    else
        # macOS
        echo "VS Code not found. Please install it:"
        echo "https://code.visualstudio.com/download"
    fi
    echo ""
    exit 1
fi

VSCODE_CLI="code"
log_info "Using 'code' command from PATH"

# Test if CLI works
if ! "$VSCODE_CLI" --version &> /dev/null; then
    log_error "VS Code CLI is not working properly"
    exit 1
fi

log_success "VS Code CLI is ready"
echo ""

# Read extensions from config file
TOTAL=0
INSTALLED=0
SKIPPED=0
FAILED=0
FAILED_EXTENSIONS=()

log_info "Reading extensions from: $(basename $CONFIG_FILE)"
echo ""

while IFS= read -r line || [ -n "$line" ]; do
    # Skip empty lines and comments
    [[ -z "$line" ]] && continue
    [[ "$line" =~ ^[[:space:]]*# ]] && continue

    # Extract extension ID (remove comments)
    ext=$(echo "$line" | cut -d'#' -f1 | xargs)
    [[ -z "$ext" ]] && continue

    TOTAL=$((TOTAL + 1))

    # Check if already installed
    if "$VSCODE_CLI" --list-extensions 2>/dev/null | grep -qi "^${ext}$"; then
        log_success "Already installed: $ext"
        SKIPPED=$((SKIPPED + 1))
        continue
    fi

    # Install extension
    log_info "Installing: $ext"

    if "$VSCODE_CLI" --install-extension "$ext" --force &> /dev/null; then
        log_success "Installed: $ext"
        INSTALLED=$((INSTALLED + 1))
    else
        log_warning "Failed: $ext"
        FAILED=$((FAILED + 1))
        FAILED_EXTENSIONS+=("$ext")
    fi
done < "$CONFIG_FILE"

# Summary
echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}    Installation Summary${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo "Total extensions: $TOTAL"
echo -e "${GREEN}✅ Newly installed: $INSTALLED${NC}"
echo -e "${YELLOW}⏭️  Already installed: $SKIPPED${NC}"

if [ $FAILED -gt 0 ]; then
    echo -e "${RED}❌ Failed: $FAILED${NC}"
    echo ""
    echo "Failed extensions:"
    for ext in "${FAILED_EXTENSIONS[@]}"; do
        echo "  - $ext"
    done
    echo ""
    log_warning "Some extensions require manual trust approval in VS Code:"
    echo "  1. Open VS Code"
    echo "  2. Go to Extensions (⇧⌘X)"
    echo "  3. Search for the extension"
    echo "  4. Click 'Install' and approve trust prompt"
    echo ""
    echo "Or install via CLI:"
    echo "  code --install-extension <extension-id>"
fi

echo ""

if [ $FAILED -eq 0 ]; then
    log_success "All extensions installed successfully!"
else
    log_warning "Some extensions failed to install. See above for details."
fi

echo ""
