<div align="center">

# Terminal Setup for AI Development

**A production-ready, idempotent terminal environment for macOS & Windows**
*Optimized for AI/ML developers working with AWS Bedrock, Claude Code, and modern development workflows*

[![macOS 14+](https://img.shields.io/badge/macOS-14%2B-blue.svg)](https://www.apple.com/macos/)
[![Windows 11 + WSL2](https://img.shields.io/badge/Windows-11%20%2B%20WSL2-0078D4.svg)](https://www.microsoft.com/windows/)
[![Apple Silicon M1+](https://img.shields.io/badge/Apple_Silicon-M1%2B-red.svg)](https://www.apple.com/mac/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Version](https://img.shields.io/badge/version-1.7.0-green.svg)](VERSION)

[Quick Start](#-quick-start) •
[Features](#-features) •
[Documentation](docs/QUICKSTART.md) •
[Contributing](#-contributing)

</div>

---

## 📋 Table of Contents

- [Overview](#overview)
- [Features](#-features)
- [Quick Start](#-quick-start)
- [What's Included](#whats-included)
- [Documentation](#-documentation)
- [Key Features](#-key-features-explained)
- [Project Structure](#-project-structure)
- [Customization](#-customization)
- [Contributing](#-contributing)
- [License](#-license)

---

## Overview

This repository provides a **complete, battle-tested terminal setup** specifically designed for AI/ML developers on **macOS and Windows 11 + WSL2**. Whether you're building with Claude, training models, or managing cloud infrastructure, this setup gives you a powerful, productive terminal environment out of the box.

### Platform Support

- **macOS** - Native setup for Apple Silicon (M1+) and Intel Macs
- **Windows 11 + WSL2** - Full development environment with Homebrew in Ubuntu 24.04

Both platforms share the same tooling and configuration for consistency!

### Why This Setup?

- ✅ **Idempotent & Safe** - Run multiple times without breaking existing tools
- ✅ **Automatic Backups** - All configs backed up before modification
- ✅ **Smart Detection** - Skips already installed applications
- ✅ **Production Ready** - Tested, documented, and maintained
- ✅ **AI-Optimized** - Built for modern AI development workflows
- ✅ **SSO-Friendly** - First-class support for GitHub with Google SSO

---

## ✨ Features

<table>
<tr>
<td width="50%">

### 🎨 Terminal Stack
- **Ghostty** - GPU-accelerated terminal
- **Tmux** - Advanced session management
- **Zsh** - Enhanced shell with plugins
- **Starship** - Beautiful, fast prompt
- **Atuin** - Intelligent shell history

### ⚡ Modern CLI Tools
- **ripgrep** - Blazing fast grep
- **fd** - User-friendly find
- **bat** - Cat with wings
- **eza** - Modern ls replacement
- **zoxide** - Smarter cd command
- **fzf** - Fuzzy finder for everything

</td>
<td width="50%">

### 🛠️ Development Tools
- **Claude Code CLI** + VS Code extensions
- **VS Code** + 24 extensions (Claude, Python, Jupyter, Docker)
- **Neovim** + LazyVim preconfigured
- **Docker Desktop** - Container management
- **Node.js** (nvm) + **Python** (pyenv)
- **Git** + lazygit + gh CLI
- **PostgreSQL 16** + **Redis**
- **AWS CLI v2**

### 🤖 AI/ML Tools (Optional)
- **Jupyter Lab** - Interactive notebooks
- **Ollama** + **LM Studio** - Local LLMs
- **pgvector** - Vector database
- **httpie** - API testing
- **DBeaver** - Database GUI

</td>
</tr>
</table>

---

## 🚀 Quick Start

### macOS Installation

```bash
# Clone the repository
git clone https://github.com/AlexCiortan/terminal-setup.git
cd terminal-setup

# Run the interactive installer
chmod +x install.sh
./install.sh
```

### Windows 11 + WSL2 Installation

**See the complete [Windows Setup Guide](windows/README.md)**

```bash
# 1. First, install WSL2 on Windows (PowerShell as Admin):
wsl --install -d Ubuntu-24.04

# 2. After restart, inside WSL2 Ubuntu:
git clone https://github.com/AlexCiortan/terminal-setup.git
cd terminal-setup/windows

# 3. Run the WSL2 installer
chmod +x install-wsl2.sh
./install-wsl2.sh
```

**Key differences:**
- Install VS Code, Docker Desktop, and LM Studio on Windows
- All dev tools run in WSL2 (Ubuntu 24.04)
- Automatic port forwarding between WSL2 and Windows
- Use Windows Terminal for optimal experience

The installer presents an interactive menu:

| Option | Description | Includes |
|--------|-------------|----------|
| **1** | Essential Tools | Git, Node.js, Python, Docker, AWS CLI, Databases |
| **2** | Terminal Enhancements | Tmux plugins, Enhanced shell, Starship, LazyVim |
| **3** | GitHub Dashboard | gh-dash for managing PRs/issues* |
| **4** | Window Manager | AeroSpace tiling manager (optional) |
| **5** | Everything | All of the above ⭐ *Recommended* |
| **0** | Update Only | Just update existing tools |

\* *gh-dash requires GitHub authentication. May not work with Google SSO (use PAT instead).*

### Post-Installation

```bash
# Reload your shell
source ~/.zshrc

# Install tmux plugins (if using option 2 or 5)
tmux                    # Start tmux
# Press: Ctrl+b then Shift+I (capital I)
# This installs all tmux plugins (sessionx, floax, thumbs, catppuccin theme, etc.)
# Wait for installation to complete, then exit: Ctrl+b then d

# Authenticate with GitHub (if using option 1 or 5)
gh auth login  # Or see docs/GITHUB_SETUP.md for SSO setup

# Try out new features
z ~/projects     # Smart directory jumping
lg               # LazyGit TUI
gh dash          # GitHub dashboard
vf               # Fuzzy find files in current directory
```

### 🔒 Safety Features

> **Safe to run multiple times!** The installer:
> - Detects existing installations and skips them
> - Creates timestamped backups of all configs
> - Validates your system before installation
> - Provides clear rollback instructions

---

## What's Included

### Terminal & Shell
- **Ghostty** with JetBrains Mono font, transparency, and blur effects
- **Tmux** with sessionx (fuzzy session finder), floax (floating windows), and thumbs (text hints)
- **Zsh** with autosuggestions, syntax highlighting, and custom functions
- **Starship** prompt showing Git status, Python/Node versions, AWS profile
- **Atuin** for powerful shell history search and sync

### Development Environment
- **Claude Code CLI** - Official Anthropic CLI for AI development with AWS Bedrock
- **Visual Studio Code** - Pre-installed with 24 curated extensions (Claude, Python, Jupyter, Docker, GitLens)
- **Neovim + LazyVim** - Pre-configured, ready for coding
- **Git tools** - lazygit (TUI), gh CLI, git-delta (better diffs)
- **Version managers** - nvm (Node.js), pyenv (Python)
- **Docker Desktop** - Container development
- **Google Chrome** - Modern browser

### Python Ecosystem
- **uv** - Ultra-fast Python package installer
- **poetry** - Dependency management
- **pipx** - Install Python apps in isolated environments
- **black**, **ruff**, **ipython** - Code formatting and REPL

### Optional: AI/ML Tools

Run `./install-ai-tools.sh` for:
- Jupyter Lab for interactive development
- Ollama (CLI) and LM Studio (GUI) for local LLM testing
- pgvector for PostgreSQL vector operations
- Monitoring tools (glances, bottom)
- DBeaver for database management

See [RECOMMENDED_ADDITIONS.md](docs/RECOMMENDED_ADDITIONS.md) for complete AI tools guide.

---

## 📖 Documentation

| Document | Description |
|----------|-------------|
| [**Quick Start Guide**](docs/QUICKSTART.md) | Get up and running in minutes |
| [**Windows Setup Guide**](windows/README.md) | Complete Windows 11 + WSL2 setup 🪟 |
| [**GitHub Integration**](docs/GITHUB_SETUP.md) | SSH keys, GitHub CLI, and SSO setup |
| [**Command Reference**](docs/REFERENCE.md) | Complete shortcuts and commands |
| [**Advanced Features**](docs/ADVANCED.md) | Power-user tips and customization |
| [**AI Tools Guide**](docs/RECOMMENDED_ADDITIONS.md) | Optional AI/ML development tools |
| [**Testing Guide**](docs/TEST_ON_OLD_COMPUTER.md) | Test safely on existing setups |
| [**Contributing**](CONTRIBUTING.md) | How to contribute |

---

## 🎯 Key Features Explained

### ⚠️ First-Time Tmux Setup

After installation, you need to install tmux plugins **once**:

```bash
# Start tmux
tmux

# Press: Ctrl+b then Shift+I (capital I)
# Wait for plugins to install (~30 seconds)
# Detach: Ctrl+b then d
```

This installs: sessionx, floax, tmux-thumbs, catppuccin theme, and more. Only needed once!

### Smart Tmux Session Management

Instantly switch between projects with fuzzy finding:

```bash
Ctrl+b o    # Open session manager
            # Type to search your projects
            # Enter to switch instantly
```

### Floating Terminal Windows

Quick commands without disrupting your layout:

```bash
Ctrl+b p    # Toggle floating window
            # Perfect for one-off commands
```

### GitHub Workflow Integration

Manage PRs and issues without leaving the terminal:

```bash
gh dash     # Interactive dashboard
            # Review PRs, check CI status
            # Open in lazygit for detailed view
```

### Smart Shell Functions

Pre-configured productivity boosters:

```bash
mkcd my-project        # Create directory and cd into it
killport 8080          # Kill process on specified port
pyproject ai-app       # Create Python project with venv
nodeproject web-app    # Create Node.js project
vf                     # Fuzzy find and open in nvim
aws-profile            # Switch AWS profiles with fzf
```

---

## 🏗️ Project Structure

```
terminal-setup/
├── install.sh                   # Main interactive installer (idempotent)
├── install-ai-tools.sh          # Optional AI/ML tools installer
├── configs/                     # Configuration templates
│   ├── zshrc                    # Enhanced shell with aliases & functions
│   ├── tmux.conf                # Tmux with plugins & custom keybindings
│   ├── starship.toml            # Prompt configuration
│   ├── ghostty                  # Terminal settings (font, theme, opacity)
│   ├── gh-dash.yml              # GitHub dashboard configuration
│   └── aerospace.toml           # Window manager (optional)
├── docs/                        # Complete documentation
│   ├── QUICKSTART.md
│   ├── REFERENCE.md
│   ├── ADVANCED.md
│   ├── RECOMMENDED_ADDITIONS.md
│   └── TEST_ON_OLD_COMPUTER.md
└── scripts/                     # Utility scripts
    ├── validate.sh              # Pre-installation validation
    └── uninstall.sh             # Safe removal with backup restore
```

### Script Reference

| Script | Purpose |
|--------|---------|
| `install.sh` | Main installer with interactive menu |
| `install-ai-tools.sh` | AI/ML development tools (Jupyter, Ollama, LM Studio) |
| `scripts/validate.sh` | Validates repository integrity |
| `scripts/uninstall.sh` | Safely removes configs with restore option |

---

## 🔧 Customization

All configuration files are in the `configs/` directory. After installation, customize:

| File | Purpose |
|------|---------|
| `~/.zshrc` | Shell aliases, functions, and environment |
| `~/.tmux.conf` | Tmux settings and keybindings |
| `~/.config/starship.toml` | Prompt customization |
| `~/.config/ghostty/config` | Terminal appearance and behavior |
| `~/.config/gh-dash/config.yml` | GitHub dashboard sections |
| `~/.config/aerospace/aerospace.toml` | Window management |

See [ADVANCED.md](docs/ADVANCED.md) for detailed customization guides.

---

## 🤝 Contributing

Contributions, issues, and feature requests are welcome!

- 🐛 [Report a Bug](../../issues/new?template=bug_report.md)
- 💡 [Request a Feature](../../issues/new?template=feature_request.md)
- 🔧 [Submit a Pull Request](../../pulls)
- ⭐ Star this repo if you find it useful!

See [CONTRIBUTING.md](CONTRIBUTING.md) for development guidelines.

---

## 📝 License

This project is licensed under the **MIT License** - see the [LICENSE](LICENSE) file for details.

---

<div align="center">

### Ready to supercharge your terminal?

**[Get Started →](docs/QUICKSTART.md)** • **[View Features →](docs/ADVANCED.md)** • **[Report Issue →](../../issues)**

<sub>Made for AI developers by AI developers</sub>

</div>
