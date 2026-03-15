# Quick Start Guide

Get your terminal up and running in minutes!

## Installation

### One-Line Install

```bash
git clone https://github.com/AlexCiortan/terminal-setup.git
cd terminal-setup
chmod +x install.sh && ./install.sh
```

The installer will ask you what to install and handle everything automatically.

---

## What Gets Installed

### Option 1: Essential Tools
- Git + GitHub CLI + LazyGit
- Node.js (via nvm) + Python (via pyenv)
- Docker Desktop
- AWS CLI
- Modern CLI tools (ripgrep, fd, bat, eza, etc.)
- Databases (PostgreSQL, Redis)

### Option 2: Terminal Enhancements
- Enhanced tmux with advanced plugins:
  - **tmux-sessionx** - Fuzzy find sessions
  - **tmux-floax** - Floating windows
  - **tmux-thumbs** - Quick text selection
  - Catppuccin theme
- Enhanced .zshrc with smart functions
- Starship prompt configuration

### Option 3: GitHub Dashboard
- **gh-dash** - Terminal UI for GitHub PRs/issues

### Option 4: Window Manager
- **AeroSpace** - i3-like window tiling for macOS

### Option 5: Everything (Recommended)
All of the above except AeroSpace (optional)

---

## Post-Installation

### 1. Reload Shell
```bash
source ~/.zshrc
```

### 2. Authenticate with GitHub
```bash
gh auth login
```

### 3. Configure AWS
```bash
aws configure
# Enter your credentials for AWS Bedrock
```

### 4. Install Node.js LTS
```bash
nvm install --lts
nvm use --lts
```

### 5. Start Tmux
```bash
tmux new -s main
```

Inside tmux, press `Ctrl+b` then `Shift+I` to install plugins.

### 6. Launch Docker Desktop
Open from Applications folder and complete setup.

---

## First Steps

### Jump to Directories Smart
```bash
z project-name    # Smart directory jumping with zoxide
```

### Beautiful Git UI
```bash
lg                # Launch LazyGit
```

### GitHub Dashboard
```bash
gh dash           # View PRs and issues
```

### Fuzzy Find Files
```bash
vf                # Find and open file in nvim
```

### Create Projects
```bash
pyproject my-ai-app      # Python project with venv
nodeproject my-web-app   # Node.js project
```

---

## Essential Keyboard Shortcuts

### Tmux (Prefix: Ctrl+b)
- `o` - Session manager (fuzzy find!)
- `p` - Floating window
- `u` - URL finder
- `F` - Text selection (thumbs)
- `|` - Split vertical
- `-` - Split horizontal
- `Alt+Arrow` - Navigate panes (no prefix!)

### Shell
- `↑` - Intelligent history search (Atuin)
- `Ctrl+R` - Fuzzy search history (FZF)
- `Ctrl+T` - Fuzzy find files (FZF)

### Neovim (LazyVim)
- `Space e` - File explorer
- `Space f f` - Find files
- `Space f g` - Find text (grep)
- `Space g g` - LazyGit
- `Space /` - Comment line

---

## Common Commands

### File Operations
```bash
ll                 # Better ls with icons
lt                 # Tree view
cat file.py        # Syntax-highlighted view
rg "pattern"       # Fast search in files
fd "*.py"          # Fast file find
```

### Git
```bash
gst                # git status
lg                 # LazyGit UI
gco branch         # git checkout
gcb new-branch     # create new branch
```

### Docker
```bash
d ps               # docker ps
dc up -d           # docker-compose up
```

### AWS
```bash
awsp               # Switch AWS profile (fuzzy)
aws-profile        # Alternative profile switcher
```

### Utils
```bash
mkcd dirname       # Create and cd into directory
killport 8080      # Kill process on port
note "message"     # Quick note-taking
notes              # View all notes
extract file.zip   # Universal extractor
```

---

## Troubleshooting

### Shell not loading properly
```bash
# Check for errors
zsh -n ~/.zshrc

# Reload
source ~/.zshrc
```

### Tmux plugins not working
```bash
# Inside tmux, reinstall
Ctrl+b then Shift+I
```

### NVM not found
```bash
# Reload shell
source ~/.zshrc

# Or manually
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
```

### Neovim issues
```bash
# Check health
nvim +checkhealth

# Reset if needed (careful!)
rm -rf ~/.config/nvim ~/.local/share/nvim
```

---

## Next Steps

Check out:
- [REFERENCE.md](REFERENCE.md) - Complete command reference
- [ADVANCED.md](ADVANCED.md) - Power-user features and customization

---

**Happy coding! 🚀**
