#!/bin/bash

# Validate repository before installation
# Checks that all required files exist

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
NC='\033[0m'

ERRORS=0

echo "🔍 Validating terminal-setup repository..."
echo ""

# Check required files
REQUIRED_FILES=(
    "install.sh"
    "install-ai-tools.sh"
    "VERSION"
    "CHANGELOG.md"
    "README.md"
    "LICENSE"
    "configs/zshrc"
    "configs/tmux.conf"
    "configs/starship.toml"
    "configs/ghostty"
    "configs/gh-dash.yml"
    "configs/aerospace.toml"
    "configs/vscode-extensions.txt"
    "docs/QUICKSTART.md"
    "docs/REFERENCE.md"
    "docs/ADVANCED.md"
    "docs/RECOMMENDED_ADDITIONS.md"
    "docs/TEST_ON_OLD_COMPUTER.md"
    "scripts/install-vscode-extensions.sh"
    "scripts/uninstall.sh"
    "scripts/validate.sh"
    "logs/README.md"
    "logs/.gitkeep"
)

for file in "${REQUIRED_FILES[@]}"; do
    if [ -f "$file" ]; then
        echo -e "${GREEN}✓${NC} $file"
    else
        echo -e "${RED}✗${NC} $file (missing)"
        ERRORS=$((ERRORS + 1))
    fi
done

echo ""

# Validate config files are not empty
echo "📋 Checking config files..."
for config in configs/*; do
    if [ -f "$config" ] && [ ! -s "$config" ]; then
        echo -e "${RED}✗${NC} $(basename $config) is empty"
        ERRORS=$((ERRORS + 1))
    fi
done

# Check shell syntax
echo ""
echo "🔧 Checking shell script syntax..."
for script in install.sh install-ai-tools.sh scripts/install-vscode-extensions.sh scripts/uninstall.sh scripts/validate.sh; do
    if [ -f "$script" ]; then
        if bash -n "$script" 2>/dev/null; then
            echo -e "${GREEN}✓${NC} $script syntax valid"
        else
            echo -e "${RED}✗${NC} $script has syntax errors"
            ERRORS=$((ERRORS + 1))
        fi
    else
        echo -e "${YELLOW}⚠${NC} $script not found (skipping)"
    fi
done

# Check VERSION format
echo ""
echo "📦 Checking VERSION format..."
if [ -f "VERSION" ]; then
    VERSION_CONTENT=$(cat VERSION | tr -d '\n')
    if [[ $VERSION_CONTENT =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        echo -e "${GREEN}✓${NC} VERSION format valid: $VERSION_CONTENT"
    else
        echo -e "${RED}✗${NC} VERSION format invalid (should be X.Y.Z): $VERSION_CONTENT"
        ERRORS=$((ERRORS + 1))
    fi
fi

# Check logs directory structure
echo ""
echo "📁 Checking logs directory..."
if [ -d "logs" ]; then
    echo -e "${GREEN}✓${NC} logs directory exists"
    if [ -f "logs/.gitkeep" ]; then
        echo -e "${GREEN}✓${NC} logs/.gitkeep exists"
    else
        echo -e "${YELLOW}⚠${NC} logs/.gitkeep missing (not critical)"
    fi
    if [ -f "logs/README.md" ]; then
        echo -e "${GREEN}✓${NC} logs/README.md exists"
    else
        echo -e "${YELLOW}⚠${NC} logs/README.md missing (not critical)"
    fi
else
    echo -e "${RED}✗${NC} logs directory missing"
    ERRORS=$((ERRORS + 1))
fi

# Check .gitignore includes logs
echo ""
echo "🚫 Checking .gitignore..."
if [ -f ".gitignore" ]; then
    if grep -q "logs/" .gitignore && grep -q "*.log" .gitignore; then
        echo -e "${GREEN}✓${NC} .gitignore includes log files"
    else
        echo -e "${YELLOW}⚠${NC} .gitignore may not properly ignore log files"
    fi
else
    echo -e "${YELLOW}⚠${NC} .gitignore not found"
fi

echo ""
if [ $ERRORS -eq 0 ]; then
    echo -e "${GREEN}✅ All validations passed!${NC}"
    echo "Repository is ready for installation."
    exit 0
else
    echo -e "${RED}❌ $ERRORS validation error(s) found.${NC}"
    echo "Please fix the errors before running install.sh"
    exit 1
fi
