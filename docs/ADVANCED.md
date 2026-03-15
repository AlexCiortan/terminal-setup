# Advanced Features & Customization

Beyond the basics - power-user features, additional tools, and customization options.

---

## Table of Contents

1. [Advanced Tmux Features](#advanced-tmux-features)
2. [AI/ML Development Tools](#aiml-development-tools)
3. [Cloud & Infrastructure Tools](#cloud--infrastructure-tools)
4. [Database Tools](#database-tools)
5. [API Development](#api-development)
6. [Monitoring & Observability](#monitoring--observability)
7. [macOS Productivity Apps](#macos-productivity-apps)
8. [Dotfiles Management](#dotfiles-management)
9. [Security Tools](#security-tools)
10. [Customization Tips](#customization-tips)

---

## Advanced Tmux Features

### What's Already Included

Your tmux setup includes these power-user plugins:

#### tmux-sessionx
Fuzzy find and manage sessions with zoxide integration.

**Usage:**
```bash
# Inside tmux
Ctrl+b o              # Open session manager
# Type to search
# Enter to switch
# Ctrl+d to delete session
```

#### tmux-floax
Floating terminal windows (like VSCode terminal).

**Usage:**
```bash
Ctrl+b p              # Toggle floating window
```

#### tmux-thumbs
Quick text selection with keyboard hints.

**Usage:**
```bash
Ctrl+b F              # Activate thumbs mode
# Type hint letters to copy text
```

### Advanced Tmux Tips

#### Custom Layouts
```bash
# Save current layout
Ctrl+b :
set-window-option -g window-layout "custom-layout-string"

# Rotate panes
Ctrl+b Ctrl+o
```

#### Session Management
```bash
# Create named session
tmux new -s work

# Attach to session
tmux attach -t work

# List sessions
tmux ls

# Kill session
tmux kill-session -t work

# Rename session
Ctrl+b $
```

#### Copy Mode Power
```bash
# Enter copy mode
Ctrl+b [

# Vi-style navigation
h,j,k,l           # Move cursor
w,b               # Jump words
0,$               # Start/end of line
Ctrl+d, Ctrl+u    # Half page down/up

# Select and copy
Space             # Start selection
Enter             # Copy selection
Ctrl+b ]          # Paste
```

---

## AI/ML Development Tools

### Jupyter Notebooks

```bash
# Install
pipx install jupyterlab
pipx install notebook

# Run
jupyter lab

# Or classic notebook
jupyter notebook
```

### Ollama (Local LLMs)

```bash
# Install
brew install ollama

# Download and run models
ollama pull llama2
ollama run llama2

# Use in Python
pip install ollama-python
```

### Vector Databases

#### PostgreSQL with pgvector
```bash
# Install extension
brew install pgvector

# In PostgreSQL
CREATE EXTENSION vector;

# Create table with vector column
CREATE TABLE embeddings (
  id SERIAL PRIMARY KEY,
  content TEXT,
  embedding vector(1536)
);
```

#### ChromaDB
```bash
# Install
pip install chromadb

# Use for semantic search
```

### AI Development Tools

```bash
# Install common AI tools via pipx
pipx install huggingface-cli
pipx install datasets-cli

# For local development
pip install transformers
pip install langchain
pip install anthropic  # Claude API
```

---

## Cloud & Infrastructure Tools

### Terraform & IaC

```bash
# Install terraform version manager
brew install tfenv

# Install specific version
tfenv install 1.7.0
tfenv use 1.7.0

# Install complementary tools
brew install tflint        # Linter
brew install terraform-docs # Documentation generator
```

### Kubernetes Tools

```bash
# Already have kubectl, add these:
brew install k9s           # Terminal UI
brew install kubectx       # Context switching
brew install helm          # Package manager
brew install kustomize     # Configuration management

# Aliases to add to .zshrc
alias k9='k9s'
alias kc='kubectx'
alias kn='kubens'
```

### Multi-Cloud CLIs

```bash
# Azure (if not already installed)
brew install azure-cli

# Google Cloud
brew install google-cloud-sdk

# DigitalOcean
brew install doctl
```

---

## Database Tools

### CLI Clients

```bash
# PostgreSQL client (already installed)
psql --version

# MySQL
brew install mysql-client

# MongoDB
brew install mongodb-community

# Redis CLI (already installed)
redis-cli
```

### GUI Tools

```bash
# Universal database tool
brew install --cask dbeaver-community

# PostgreSQL/MySQL
brew install --cask tableplus

# Redis
brew install --cask another-redis-desktop-manager

# MongoDB
brew install --cask mongodb-compass
```

### Database Development

```bash
# Migration tools
pipx install alembic      # Python
npm install -g prisma     # Node.js

# Query builders
npm install -g @databases/cli
```

---

## API Development

### HTTP Clients

```bash
# Better curl
brew install httpie

# Usage
http GET https://api.example.com/users
http POST https://api.example.com/users name="John"

# Curl alternative with httpie syntax
brew install curlie
```

### API Testing

```bash
# GUI tools
brew install --cask postman
brew install --cask insomnia

# CLI testing
npm install -g newman      # Postman CLI

# gRPC
brew install grpcurl
```

### API Development Tools

```bash
# OpenAPI tools
npm install -g @openapitools/openapi-generator-cli

# GraphQL
npm install -g graphql-cli

# REST client in terminal
brew install --cask restfox
```

---

## Monitoring & Observability

### System Monitoring

```bash
# Better than htop
brew install glances
brew install bottom        # Rust-based alternative

# Usage
glances
btm
```

### Network Tools

```bash
# Network bandwidth monitor
brew install bandwhich

# Network diagnostic
brew install mtr

# Port scanner
brew install nmap

# DNS tools
brew install dog
```

### Log Viewing

```bash
# Log file navigator
brew install lnav

# Usage
lnav /var/log/system.log

# Follow multiple logs
lnav /var/log/*.log
```

---

## macOS Productivity Apps

### Window Management

```bash
# Free option (already included if you chose it)
# AeroSpace - i3-like tiling

# Alternative: Rectangle (free)
brew install --cask rectangle

# Paid option: Magnet
brew install --cask magnet
```

### Launcher & Spotlight

```bash
# Better Spotlight
brew install --cask alfred

# Configure Alfred:
# - Set hotkey (e.g., Cmd+Space)
# - Add workflows
# - Enable clipboard history
```

### Clipboard Manager

```bash
# Free option
brew install --cask maccy

# Usage: Cmd+Shift+C to open history
```

### Screenshot Tools

```bash
# Advanced screenshots
brew install --cask shottr

# Features:
# - Annotations
# - OCR
# - Scrolling capture
```

### Menu Bar Management

```bash
# Hide menu bar icons
brew install --cask bartender  # Paid
brew install --cask hidden     # Free alternative
```

### Quick Look Plugins

```bash
# Enhance Quick Look for developers
brew install --cask \
  qlcolorcode \
  qlstephen \
  qlmarkdown \
  quicklook-json \
  qlimagesize
```

---

## Dotfiles Management

### GNU Stow

Already have individual config files? Organize them better:

```bash
# Install
brew install stow

# Structure
~/dotfiles/
  ├── zsh/
  │   └── .zshrc
  ├── tmux/
  │   └── .tmux.conf
  ├── nvim/
  │   └── .config/nvim/
  └── git/
      └── .gitconfig

# Deploy
cd ~/dotfiles
stow zsh tmux nvim git

# This creates symlinks in your home directory
```

### Alternative: Chezmoi

```bash
# Install
brew install chezmoi

# Initialize
chezmoi init

# Add files
chezmoi add ~/.zshrc
chezmoi add ~/.tmux.conf

# Edit
chezmoi edit ~/.zshrc

# Apply changes
chezmoi apply
```

---

## Security Tools

### Password Managers

```bash
# 1Password CLI
brew install --cask 1password-cli

# Bitwarden CLI
brew install bitwarden-cli

# Usage
bw login
bw get password github.com
```

### Secret Management

```bash
# Encrypt secrets in git
brew install sops

# Modern encryption
brew install age

# Usage
age-keygen -o key.txt
age -r $(cat key.txt.pub) -o secret.age secret.txt
age -d -i key.txt secret.age
```

### SSH Key Management

```bash
# Generate new key
ssh-keygen -t ed25519 -C "your_email@example.com"

# Copy to clipboard
pbcopy < ~/.ssh/id_ed25519.pub

# Add to GitHub
gh ssh-key add ~/.ssh/id_ed25519.pub -t "macbook-pro"

# SSH config (~/.ssh/config)
Host github.com
  AddKeysToAgent yes
  UseKeychain yes
  IdentityFile ~/.ssh/id_ed25519
```

---

## Customization Tips

### Personalize Your Prompt

Edit `~/.config/starship.toml`:

```toml
# Add more info to prompt
[aws]
disabled = false
symbol = "☁️ "

[docker_context]
disabled = false
symbol = "🐳 "

[terraform]
disabled = false
symbol = "💠 "
```

### Custom Tmux Theme

Edit `~/.tmux.conf`:

```bash
# Change Catppuccin flavor
set -g @catppuccin_flavor 'frappe'  # or 'latte', 'macchiato'

# Customize status modules
set -g @catppuccin_status_modules_right "directory user session date_time"
```

### Add Your Own Aliases

Edit `~/.zshrc` and add:

```bash
# Your custom aliases
alias work='cd ~/projects/work && tmux attach -t work || tmux new -s work'
alias personal='cd ~/projects/personal && code .'
alias backup='rsync -av --exclude node_modules ~/projects /backup/'

# Company-specific
alias vpn='sudo openconnect vpn.company.com'
alias prod='export AWS_PROFILE=production'
```

### Custom Shell Functions

```bash
# Create a new feature branch
feat() {
    local branch="feature/$1"
    git checkout -b "$branch"
    git push -u origin "$branch"
}

# Quick PR creation
pr() {
    local title="$1"
    gh pr create --title "$title" --fill
}

# Deploy to staging
deploy-staging() {
    git push staging main
    echo "Deployed to staging. Check: https://staging.example.com"
}
```

---

## VS Code Integration

### Recommended Extensions for AI Development

```
# Essential
- AWS Toolkit
- Python
- Pylance
- Jupyter
- Docker
- GitLens

# AI/ML Specific
- GitHub Copilot (if available)
- Tabnine AI (alternative)
- Python Indent
- Python Test Explorer

# General Development
- ESLint
- Prettier
- YAML
- Markdown All in One
- Thunder Client (API testing)
- Remote - SSH
- Error Lens
```

### Terminal Integration

Settings.json additions:

```json
{
  "terminal.integrated.defaultProfile.osx": "zsh",
  "terminal.integrated.fontFamily": "Anka/Coder",
  "terminal.integrated.fontSize": 14,
  "terminal.integrated.cursorBlinking": true,
  "terminal.integrated.cursorStyle": "line"
}
```

---

## Performance Tips

### Speed Up Shell Startup

```bash
# Time your shell startup
time zsh -i -c exit

# Profile what's slow
zsh -xv 2>&1 | ts -i "%.s"

# Lazy load nvm (if slow)
# Add to .zshrc:
nvm() {
    unset -f nvm
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    nvm "$@"
}
```

### Clear Caches

```bash
# Homebrew
brew cleanup

# Docker
docker system prune -a

# Python
pip cache purge
uv cache clear

# npm
npm cache clean --force

# macOS
sudo rm -rf ~/Library/Caches/*
```

---

## Maintenance

### Update Everything

```bash
# Homebrew
brew update && brew upgrade

# npm packages
npm update -g

# Python tools
pipx upgrade-all

# Zsh plugins
cd ~/.zsh/zsh-autosuggestions && git pull
cd ~/.zsh/zsh-syntax-highlighting && git pull

# Tmux plugins
~/.tmux/plugins/tpm/bin/update_plugins all

# macOS
softwareupdate -l
```

### Backup Important Configs

```bash
# Create backup script
cat > ~/backup-configs.sh << 'EOF'
#!/bin/bash
BACKUP_DIR="$HOME/config-backup-$(date +%Y%m%d)"
mkdir -p "$BACKUP_DIR"

cp ~/.zshrc "$BACKUP_DIR/"
cp ~/.tmux.conf "$BACKUP_DIR/"
cp ~/.gitconfig "$BACKUP_DIR/"
cp -r ~/.config/nvim "$BACKUP_DIR/"
cp -r ~/.ssh/config "$BACKUP_DIR/"
cp -r ~/.aws "$BACKUP_DIR/"

echo "Backed up to $BACKUP_DIR"
EOF

chmod +x ~/backup-configs.sh
```

---

## Resources

- [Homebrew Documentation](https://docs.brew.sh/)
- [tmux Guide](https://github.com/tmux/tmux/wiki)
- [LazyVim](https://www.lazyvim.org/)
- [Starship](https://starship.rs/)
- [Modern Unix Tools](https://github.com/ibraheemdev/modern-unix)

---

**Keep exploring and customizing! 🚀**
