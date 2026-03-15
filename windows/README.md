# Terminal Setup for Windows 11 + WSL2

**Complete AI Development Environment for Windows 11 with WSL2 Backend**

This guide shows you how to set up a powerful development environment on Windows 11 using WSL2 (Windows Subsystem for Linux), providing a near-native Linux experience while retaining Windows applications.

---

## 🏗️ Architecture Overview

Your development environment will be split across Windows and WSL2:

```
┌─────────────────────────────────────────────────────────────┐
│                      WINDOWS 11                             │
│                                                             │
│  GUI Applications (Install These on Windows):              │
│  • VS Code + Remote WSL Extension                          │
│  • Windows Terminal (pre-installed)                        │
│  • Docker Desktop (WSL2 backend)                           │
│  • LM Studio (full GPU access for 9070XT)                  │
│  • Chrome/Edge browser                                     │
│  • DBeaver (optional - can run in WSL2 too)               │
│  • Insomnia/Postman (optional)                             │
│                                                             │
│  ┌───────────────────────────────────────────────────────┐ │
│  │          WSL2 - Ubuntu 24.04 LTS                      │ │
│  │                                                       │ │
│  │  Development Environment (Install These in WSL2):    │ │
│  │  • Homebrew (package manager for consistency)        │ │
│  │  • Claude Code CLI                                   │ │
│  │  • Git, GitHub CLI (gh)                              │ │
│  │  • Python (pyenv), Node.js (nvm)                     │ │
│  │  • Modern CLI tools (ripgrep, fzf, bat, eza, etc.)  │ │
│  │  • tmux, zsh, starship prompt                        │ │
│  │  • Neovim + LazyVim                                  │ │
│  │  • PostgreSQL, Redis                                 │ │
│  │  • AWS CLI, kubectl, terraform                       │ │
│  │  • All your project files and git repos              │ │
│  │                                                       │ │
│  │  Location: ~/projects/                               │ │
│  └───────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────┘
```

---

## 📋 Prerequisites

- **Windows 11** (version 22H2 or later recommended)
- **AMD 9800X3D** or equivalent modern CPU
- **64GB RAM** (plenty for both Windows and WSL2)
- **2TB storage** (WSL2 will use ~50-200GB depending on usage)
- **AMD 9070XT** (24GB VRAM for local LLMs on Windows side)

---

## 🚀 Installation Order

Follow these steps **in order**:

### Phase 1: Verify Windows Terminal (1 minute)

Windows Terminal is usually pre-installed on Windows 11. Verify or install:

```powershell
# Check if installed (open Start menu, search "Windows Terminal")
# If not found, install via winget:
winget install Microsoft.WindowsTerminal

# Or install from Microsoft Store
```

---

### Phase 2: Enable WSL2 + Ubuntu (5 minutes + restart)

Open PowerShell as **Administrator** and run:

```powershell
# Install WSL2 with Ubuntu 24.04
wsl --install -d Ubuntu-24.04
```

**What happens:**
- WSL2 and Ubuntu 24.04 will be installed
- You'll be prompted to restart your computer
- After restart, Ubuntu terminal opens automatically
- Create your Linux username and password (can be different from Windows)

**After restart, verify installation:**
```powershell
wsl --list --verbose
```

You should see:
```
  NAME            STATE           VERSION
* Ubuntu-24.04    Running         2
```

---

### Phase 3: Install Windows Applications (10 minutes)

**Now that WSL2 exists**, install these Windows applications that integrate with it:

#### 1. Docker Desktop
Download: https://www.docker.com/products/docker-desktop/

```powershell
# Or use winget:
winget install Docker.DockerDesktop
```

**Important Settings** (after installation):
- Choose "Use WSL2 based engine" during installation
- After install: Settings → Resources → WSL Integration
  - Enable integration with Ubuntu-24.04
  - Apply & Restart

#### 2. Visual Studio Code
Download: https://code.visualstudio.com/

```powershell
# Or use winget:
winget install Microsoft.VisualStudioCode
```

**IMPORTANT - Install WSL extension and connect to WSL2:**

After VS Code installs, open it on Windows:
1. Open VS Code on Windows
2. Press `Ctrl+Shift+X` (Extensions panel)
3. Search for: `WSL`
4. Install: `WSL` extension (by Microsoft - `ms-vscode-remote.remote-wsl`)
5. Press `F1` (Command Palette)
6. Type: `WSL: Connect to WSL`
7. Select `Ubuntu-24.04` from the list
8. A new VS Code window opens connected to WSL2 (see "WSL: Ubuntu-24.04" in bottom-left corner)

**This extension is required** for VS Code to connect to WSL2. Without this setup, the `code` command from WSL2 won't work.

**Note:** Other extensions (Claude Code, Python, etc.) will be installed later from WSL2 (Phase 6)

#### 3. LM Studio (Optional - for local LLMs with GPU)
Download: https://lmstudio.ai/

This runs on Windows for full AMD 9070XT GPU access.

#### 4. Chrome or Edge
Use your preferred browser (Edge comes with Windows 11).

---

### Phase 4: WSL2 Initial Verification (2 minutes)

When you first open Ubuntu (from Windows Terminal or wsl command):

```bash
# Update system packages (installer will do this again, but good practice)
sudo apt update && sudo apt upgrade -y

# Verify you're in WSL2
uname -a
# Should show: Linux ... x86_64 GNU/Linux with WSL2 kernel
```

---

### Phase 5: Run the WSL2 Installer (20-30 minutes)

Clone this repository and run the installer:

```bash
# Inside WSL2 Ubuntu terminal:

# Navigate to home directory
cd ~

# Clone this repository
git clone https://github.com/AlexCiortan/terminal-setup.git
cd terminal-setup/windows

# Make installer executable
chmod +x install-wsl2.sh

# Run the installer
./install-wsl2.sh
```

**What the installer does (in order):**
1. **System Prerequisites** - Updates Ubuntu, installs build-essential, curl, git
2. **Homebrew** - Installs Homebrew for Linux (consistent with macOS)
3. **Essential Dev Tools** - Git, GitHub CLI (gh), Claude Code CLI, lazygit
4. **Modern CLI Tools** - ripgrep, fd, bat, eza, zoxide, fzf, jq, yq, git-delta
5. **Shell Configuration** - zsh, Oh My Zsh, plugins, tmux + TPM, Starship prompt
6. **Neovim** - Neovim + LazyVim configuration
7. **Programming Languages** - Python (pyenv), Node.js (nvm), pipx, poetry, uv
8. **Cloud Tools** - AWS CLI v2
9. **Databases** - PostgreSQL 16 + pgvector, Redis
10. **AI/ML Tools** (optional) - Jupyter Lab, Ollama, httpie, monitoring tools
11. **Optional Tools** - Kubernetes (k9s, kubectx, stern), Terraform, Git LFS

**Configuration files copied** (same as macOS for consistency):
- `configs/starship.toml` → `~/.config/starship.toml`
- `configs/tmux.conf` → `~/.tmux.conf`
- `configs/zshrc` → `~/.zshrc`

**Note:** The installer is idempotent - safe to run multiple times. Already installed tools are skipped.

**Interactive prompts:**
- Choose between basic or full installation
- Select LLM tools (Ollama is recommended for WSL2)
- Choose optional tools (K8s, Terraform, etc.)

---

### Phase 6: Post-Installation Configuration (10 minutes)

#### 1. Configure VS Code for WSL2 (IMPORTANT - Do This First!)

**PREREQUISITE:** Make sure you installed the **WSL** extension in VS Code on Windows and connected it to WSL2 using F1 → "WSL: Connect to WSL" (from Phase 3, Step 2). Without this setup, the `code` command won't work from WSL2.

**Now open a project from WSL2 to install VS Code Server:**

```bash
# In WSL2, navigate to the terminal-setup directory:
cd ~/terminal-setup

# Open VS Code (this installs VS Code Server in WSL2):
code .
```

**What happens:**
- WSL extension connects VS Code (Windows) to WSL2
- VS Code Server is installed in WSL2 (~30 seconds)
- VS Code opens on Windows showing "WSL: Ubuntu-24.04" in bottom-left corner
- The `code` command is now available for installing extensions

**Now install all VS Code extensions:**

```bash
# Still in ~/terminal-setup directory in WSL2:
./scripts/install-vscode-extensions.sh
```

This installs 21 extensions from `configs/vscode-extensions.txt`:
- Claude Code, Python, Pylance, GitLens, Docker, and more
- Extensions install in WSL2 context automatically
- Takes 2-3 minutes

**Alternative:** Install extensions manually via VS Code UI (Ctrl+Shift+X)

#### 2. Set up GitHub Authentication

**📖 Complete guide:** [docs/GITHUB_SETUP.md](../docs/GITHUB_SETUP.md)

**🔒 If your organization uses Google SSO:** See the [SSO-specific setup guide](../docs/GITHUB_SETUP.md#-recommended-setup-for-github-with-google-sso) - you'll need to use Personal Access Tokens instead of browser auth.

**Quick setup (standard GitHub accounts):**

```bash
# 1. Generate SSH key
ssh-keygen -t ed25519 -C "your@email.com"

# 2. Copy public key
cat ~/.ssh/id_ed25519.pub
# Copy the output and add to GitHub: https://github.com/settings/keys

# 3. Configure Git
git config --global user.name "Your Name"
git config --global user.email "your@email.com"

# 4. Test SSH connection
ssh -T git@github.com

# 5. Authenticate GitHub CLI
gh auth login
# Follow prompts for browser-based auth
```

**Note:** Browser auth (step 5) won't work with SSO. See [GITHUB_SETUP.md](../docs/GITHUB_SETUP.md#-recommended-setup-for-github-with-google-sso) for PAT setup.

#### 3. Install tmux plugins (one-time setup)

```bash
# Start tmux
tmux

# Inside tmux, press: Ctrl+b then Shift+I (capital I)
# Wait for plugins to install (~30 seconds)
# Detach from tmux: Ctrl+b then d
```

#### 4. Create projects directory

```bash
# In WSL2:
mkdir -p ~/projects
cd ~/projects

# Clone your repos here
git clone git@github.com:you/your-repo.git
```

---

## 🔧 How Development Works

### Daily Workflow

```bash
# 1. Open Windows Terminal

# 2. It opens Ubuntu by default (you can set this)
#    Or manually: click "+" → Ubuntu-24.04

# 3. Navigate to your project
cd ~/projects/my-app

# 4. Open in VS Code
code .

# 5. VS Code opens on Windows, connected to WSL2
#    All terminals in VS Code are WSL2 terminals
#    Claude Code CLI works directly
#    Git operations happen in WSL2
```

### File Location Strategy

**✅ Recommended: Store files in WSL2**
```bash
~/projects/          # Your code, git repos
~/documents/         # Documents
~/.config/           # Configurations
```

**Why?**
- Fast file operations
- No line ending issues (CRLF vs LF)
- Better tool compatibility
- Optimal performance

**Accessing WSL2 files from Windows:**
```
In Windows File Explorer, navigate to:
\\wsl$\Ubuntu-24.04\home\yourusername\projects

Pin this to Quick Access!
```

### Running Applications

| Task | Where | How |
|------|-------|-----|
| **Code editing** | VS Code (Windows) | Connected to WSL2 via Remote extension |
| **Terminal commands** | WSL2 | Windows Terminal → Ubuntu |
| **Docker containers** | Docker Desktop | Engine in WSL2, manage from Windows GUI or WSL2 CLI |
| **Databases** | WSL2 or Docker | `postgresql://localhost:5432` |
| **Web servers** | WSL2 | Access via `localhost:3000` in Windows browser |
| **Local LLMs** | LM Studio (Windows) | Full GPU access, accessible from WSL2 via localhost |
| **API testing** | Insomnia (Windows) | Or use httpie in WSL2 |
| **Database GUI** | DBeaver (Windows) | Connect to `localhost:5432` (WSL2 databases) |

### Port Forwarding (Automatic!)

**WSL2 ports are automatically forwarded to Windows:**

```bash
# In WSL2, run a web server:
cd ~/projects/my-app
python -m http.server 8000

# Access from Windows browser:
http://localhost:8000

# Works automatically - no configuration needed!
```

---

## 🐳 Docker Workflow

### Using Docker

```bash
# In WSL2:
cd ~/projects/my-app

# Regular docker commands work:
docker run -d -p 5432:5432 postgres:16
docker compose up -d

# Manage via Docker Desktop GUI (Windows):
# - View all containers
# - Check logs
# - Monitor resources
```

### Docker + GPU (AMD 9070XT)

```bash
# ROCm support for AMD GPUs in Docker:
docker run --rm -it \
  --device=/dev/kfd \
  --device=/dev/dri \
  --group-add video \
  rocm/pytorch:latest \
  python -c "import torch; print(torch.cuda.is_available())"
```

---

## 🎮 Claude Code Workflow

### Using Claude Code CLI

```bash
# In WSL2 terminal (or VS Code terminal):
claude "help me build a FastAPI endpoint"

# Claude Code has full access to:
# - Your codebase in ~/projects/
# - Git repository
# - Can run commands, edit files, commit changes
```

### VS Code Extension

- Runs in WSL2 context automatically
- Use chat panel or inline commands
- Seamless integration with Remote WSL

---

## 📦 What's Installed Where

### Windows (Native Apps)

```
C:\Program Files\
├── Docker\                   # Docker Desktop
├── Microsoft VS Code\        # VS Code
└── LM Studio\               # LM Studio (in AppData)

C:\Users\YourName\AppData\Local\
└── Programs\
    └── Microsoft VS Code\
```

### WSL2 Ubuntu

```bash
~/
├── .config/                  # Configurations
│   └── starship.toml        # Starship prompt config
├── .tmux.conf               # Tmux config
├── .tmux/                   # Tmux plugins (TPM)
├── .zshrc                   # Zsh config
├── .oh-my-zsh/              # Oh My Zsh installation
├── projects/                # Your code repositories
├── .ssh/                    # SSH keys for Git
├── .pyenv/                  # Python version manager
└── .nvm/                    # Node.js version manager

/home/linuxbrew/.linuxbrew/  # Homebrew installations
/opt/                        # Some tools install here
```

---

## 🔄 Backup & Restore

### Backup Your WSL2 Environment

```powershell
# In PowerShell:
wsl --export Ubuntu-24.04 D:\Backups\ubuntu-wsl2-backup.tar

# This creates a complete backup (10-30GB)
```

### Restore from Backup

```powershell
# Unregister old instance
wsl --unregister Ubuntu-24.04

# Import from backup
wsl --import Ubuntu-24.04 C:\WSL\Ubuntu D:\Backups\ubuntu-wsl2-backup.tar
```

### Quick Rebuild (with scripts)

If you lose your WSL2 environment:

```bash
# 1. Fresh WSL2 install (2 min)
wsl --unregister Ubuntu-24.04
wsl --install -d Ubuntu-24.04

# 2. Clone and run installer (20 min)
git clone https://github.com/AlexCiortan/terminal-setup.git
cd terminal-setup/windows
chmod +x install-wsl2.sh
./install-wsl2.sh

# 3. Re-clone your repos (5 min)
cd ~/projects
git clone git@github.com:you/repo1.git
# etc.

# Total: ~30 minutes to full recovery
```

### Uninstall (if needed)

If you want to remove the terminal setup from WSL2:

```bash
# In WSL2:
cd ~/terminal-setup/windows
chmod +x uninstall-wsl2.sh
./uninstall-wsl2.sh
```

**Uninstall options:**
1. **Config files only** - Removes .zshrc, .tmux.conf, starship.toml (keeps tools)
2. **Config + tmux plugins** - Also removes tmux plugins
3. **Everything** - Removes all tools and configurations

**What gets removed (option 3):**
- All Homebrew packages (git, gh, Claude Code CLI, etc.)
- System packages (optionally: zsh, build-essential)
- Version managers (nvm, pyenv)
- Databases (PostgreSQL, Redis)
- Configuration files
- Optionally: Homebrew itself

**What does NOT get removed:**
- Windows applications (VS Code, Docker Desktop, LM Studio)
- Your project files in `~/projects/`
- Backups (automatic backup created before removal)

**Note:** The uninstaller creates a timestamped backup before removing anything.

---

## 🆚 Comparison: Windows vs macOS

| Feature | macOS (M5 Max) | Windows (9800X3D + 9070XT) |
|---------|----------------|----------------------------|
| **Dev Environment** | Native Unix | WSL2 (95-98% native speed) |
| **Terminal** | Ghostty | Windows Terminal |
| **Package Manager** | Homebrew | Homebrew (in WSL2) |
| **Local LLMs** | Limited by unified memory | 24GB VRAM dedicated |
| **GPU for ML** | Unified memory | Discrete AMD GPU (better for large models) |
| **File I/O** | Native | Fast in WSL2 |
| **Docker** | Docker Desktop | Docker Desktop (WSL2 backend) |
| **Claude Code** | Native | Runs in WSL2 |

**Your Windows setup advantages:**
- More RAM (64GB vs typical Mac configs)
- Dedicated 24GB VRAM for LLMs
- Can run Windows-exclusive software
- Gaming on the same machine
- Lower cost for equivalent performance

---

## 🐛 Troubleshooting

### WSL2 not starting

```powershell
# Check WSL version
wsl --status

# Update WSL
wsl --update

# Restart WSL
wsl --shutdown
wsl
```

### VS Code can't connect to WSL2

```bash
# In WSL2, reinstall VS Code Server:
rm -rf ~/.vscode-server
code .
```

### Docker Desktop issues

```
Settings → Reset → Reset to factory defaults
Then re-enable WSL2 integration
```

### Slow file performance

**Problem:** Accessing `/mnt/c/` (Windows files) from WSL2 is slow

**Solution:** Keep your projects in WSL2:
```bash
# Good (fast):
~/projects/my-app

# Slow:
/mnt/c/Users/You/projects/my-app
```

---

## 📚 Additional Resources

- [WSL Documentation](https://docs.microsoft.com/en-us/windows/wsl/)
- [VS Code Remote WSL](https://code.visualstudio.com/docs/remote/wsl)
- [Docker Desktop WSL2 Backend](https://docs.docker.com/desktop/windows/wsl/)
- [Homebrew on Linux](https://docs.brew.sh/Homebrew-on-Linux)
- [Main terminal-setup README](../README.md) (macOS version)

---

## 🎯 Next Steps

After completing installation:

1. **Set Windows Terminal default profile to Ubuntu:**
   - Open Windows Terminal Settings
   - Set "Default profile" to Ubuntu-24.04

2. **Configure Windows Terminal appearance:**
   - Install JetBrains Mono font on Windows
   - Apply Catppuccin theme (see configs in parent directory)

3. **Set up your development workflow:**
   - Clone your repositories to `~/projects/`
   - Open in VS Code with `code .`
   - Start coding with Claude Code assistance!

4. **Test LM Studio integration:**
   - Download a model in LM Studio (Windows)
   - Start local server (localhost:1234)
   - Access from WSL2: `curl http://localhost:1234/v1/models`

---

**Ready to install?** Start with [Phase 1: Verify Windows Terminal](#phase-1-verify-windows-terminal-1-minute) above!
