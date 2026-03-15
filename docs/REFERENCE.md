# Quick Reference Guide

## Essential Keyboard Shortcuts

### Ghostty Terminal
- `Cmd + T` - New tab
- `Cmd + W` - Close tab
- `Cmd + ,` - Settings
- `Cmd + K` - Clear screen

### Tmux (Prefix: `Ctrl+b`)
- `Prefix + |` - Split vertically
- `Prefix + -` - Split horizontally
- `Alt + Arrow` - Navigate panes (no prefix needed)
- `Prefix + d` - Detach from session
- `Prefix + [` - Enter copy mode (use vi keys to navigate)
- `Prefix + ]` - Paste
- `Prefix + c` - Create new window
- `Prefix + n/p` - Next/previous window
- `Prefix + ,` - Rename window
- `Prefix + r` - Reload config
- `Prefix + Shift+I` - Install plugins

#### Tmux Sessions
```bash
tmux new -s session-name     # Create new session
tmux ls                      # List sessions
tmux attach -t session-name  # Attach to session
tmux kill-session -t name    # Kill session
```

### Neovim (LazyVim)
- `Space` - Leader key
- `Space + e` - File explorer
- `Space + f + f` - Find files
- `Space + f + g` - Find text (grep)
- `Space + /` - Comment line
- `Space + w` - Save file
- `Space + q` - Quit
- `Space + Tab` - Last buffer
- `Space + g + g` - LazyGit
- `Ctrl + h/j/k/l` - Navigate splits
- `:Lazy` - Plugin manager
- `:Mason` - LSP manager

### FZF
- `Ctrl + R` - Search history
- `Ctrl + T` - Find files
- `Alt + C` - Change directory
- In FZF interface:
  - `Ctrl + J/K` - Navigate up/down
  - `Enter` - Select
  - `Tab` - Multi-select
  - `Ctrl + C` - Cancel

---

## Command Aliases

### File & Directory
```bash
ls         → eza --icons --group-directories-first
ll         → eza -lh --icons --grid
la         → eza -lah --icons --grid
lt         → eza --tree --level=2 --icons
cat        → bat (syntax highlighting)
cd         → z (smart jump)
find       → fd (fast find)
grep       → rg (ripgrep)
vim/vi     → nvim
```

### Git Shortcuts
```bash
g          → git
lg         → lazygit (TUI)
gst        → git status
gco        → git checkout
gcb        → git checkout -b
gp         → git push
gl         → git pull
glog       → git log --oneline --graph --all
```

### Docker
```bash
d          → docker
dc         → docker-compose
dps        → docker ps
dim        → docker images
```

### System
```bash
..         → cd ..
...        → cd ../..
....       → cd ../../..
reload     → source ~/.zshrc
zshconfig  → nvim ~/.zshrc
path       → echo $PATH (formatted)
```

### Python
```bash
py         → python3
ipy        → ipython
```

### AWS
```bash
awsp       → export AWS_PROFILE=$(aws configure list-profiles | fzf)
```

---

## Custom Functions

```bash
mkcd dirname              # Create directory and cd into it
killport 8080            # Kill process on port 8080
note "your note"         # Quick note-taking to ~/notes.txt
extract file.zip         # Universal archive extractor
aws-profile              # AWS profile switcher with fzf
```

---

## Tool Commands

### Zoxide (Smart CD)
```bash
z project       # Jump to directory matching "project"
z foo bar       # Jump to directory matching "foo" and "bar"
zi              # Interactive selection with fzf
```

### Atuin (History)
- `↑` (Up Arrow) - Interactive history search
- `Ctrl + R` - Alternative history search (FZF)

### LazyGit
```bash
lg              # Launch LazyGit
# In LazyGit:
# Tab - Switch panels
# Space - Stage/unstage
# c - Commit
# P - Push
# p - Pull
# ? - Help
```

### GitHub CLI (gh)
```bash
gh repo create              # Create new repo
gh pr create               # Create pull request
gh pr list                 # List PRs
gh pr checkout 123         # Checkout PR #123
gh issue create            # Create issue
gh issue list              # List issues
gh auth login              # Authenticate
gh auth status             # Check auth status
```

### AWS CLI
```bash
aws configure                          # Configure credentials
aws configure list-profiles            # List profiles
export AWS_PROFILE=profile-name        # Switch profile
aws sts get-caller-identity           # Check current identity
aws bedrock list-foundation-models     # List Bedrock models
```

### Docker
```bash
docker ps                              # List running containers
docker ps -a                           # List all containers
docker images                          # List images
docker logs container-name             # View logs
docker exec -it container-name bash    # Enter container
docker-compose up -d                   # Start services
docker-compose down                    # Stop services
docker system prune -a                 # Clean up everything
```

### Python Tools
```bash
# uv (fast package manager)
uv venv                    # Create virtual environment
uv pip install package     # Install package
uv pip list               # List packages

# poetry (project management)
poetry new project        # New project
poetry add package        # Add dependency
poetry install            # Install dependencies
poetry run python         # Run in environment
poetry shell              # Activate environment

# pipx (isolated CLI tools)
pipx install package      # Install CLI tool
pipx list                 # List installed tools
pipx upgrade package      # Upgrade tool
pipx upgrade-all          # Upgrade all tools
```

### Node.js (nvm)
```bash
nvm install node          # Install latest
nvm install --lts         # Install LTS
nvm install 18            # Install specific version
nvm use 18                # Use version
nvm ls                    # List installed versions
nvm current               # Show current version
```

### Python (pyenv)
```bash
pyenv install 3.12.0      # Install version
pyenv versions            # List installed versions
pyenv global 3.12.0       # Set global version
pyenv local 3.11.0        # Set local version (per directory)
pyenv which python        # Show path to Python
```

---

## Development Workflow

### Starting a New Project

#### Python Project
```bash
mkcd ~/projects/my-project
git init
gh repo create
pyenv local 3.12.0
uv venv
source .venv/bin/activate
uv pip install anthropic boto3
code .
```

#### Node.js Project
```bash
mkcd ~/projects/my-project
git init
gh repo create
nvm use --lts
npm init -y
npm install
code .
```

#### With Tmux
```bash
tmux new -s project-name
# Ctrl+b then | (split vertically)
# Ctrl+b then - (split horizontally)
# Alt+Arrow to navigate
```

---

## Troubleshooting

### Clear Shell History Duplicates
```bash
atuin search --delete-it-all  # Clear Atuin history
# Or manually edit ~/.local/share/atuin/history.db
```

### Reset Neovim
```bash
rm -rf ~/.config/nvim ~/.local/share/nvim ~/.local/state/nvim ~/.cache/nvim
# Then reinstall LazyVim
```

### Fix Homebrew Permissions
```bash
sudo chown -R $(whoami) /opt/homebrew
brew doctor
```

### Reload Shell Config
```bash
source ~/.zshrc
# or
reload
```

### Check What's Using a Port
```bash
lsof -ti:8080
# or
killport 8080
```

---

## File Locations

### Configuration Files
- Shell: `~/.zshrc`
- Neovim: `~/.config/nvim/`
- Tmux: `~/.tmux.conf`
- Ghostty: `~/.config/ghostty/config`
- Starship: `~/.config/starship.toml`
- Git: `~/.gitconfig`
- AWS: `~/.aws/`
- SSH: `~/.ssh/`

### Plugin Directories
- Zsh plugins: `~/.zsh/`
- Tmux plugins: `~/.tmux/plugins/`
- Neovim plugins: `~/.local/share/nvim/`

### Data Directories
- Atuin history: `~/.local/share/atuin/`
- Zoxide database: `~/.local/share/zoxide/`
- NVM: `~/.nvm/`
- Pyenv: `~/.pyenv/`

---

## Performance Tips

### Speed Up Shell Startup
```bash
# Time zsh startup
time zsh -i -c exit

# Profile startup
zsh -xv 2>&1 | ts -i "%.s"
```

### Clear Caches
```bash
# Homebrew
brew cleanup

# Docker
docker system prune -a

# Python
uv cache clear
pip cache purge

# npm
npm cache clean --force
```

---

## Daily Commands to Remember

```bash
# Morning routine
tmux attach || tmux new -s main
aws-profile                    # Select AWS profile
code ~/projects/current-work   # Open VS Code

# During work
lg                             # Quick git status
z project-name                 # Jump to project
killport 8000                  # Free up port
note "Meeting at 2pm"          # Quick note

# End of day
git status                     # Check uncommitted changes
docker-compose down            # Stop services
tmux detach                    # Preserve session
```

---

## Getting Help

### Command Help
```bash
command --help
man command
tldr command        # Install: brew install tldr
```

### Tool Documentation
- Neovim: `:help` or `Space + f + h` (find help)
- Tmux: `Ctrl+b + ?` (list keybindings)
- LazyGit: `?` (help)

### Check Installed Versions
```bash
brew list --versions
npm list -g --depth=0
pipx list
nvm ls
pyenv versions
```

---

## Useful One-Liners

```bash
# Find large files
fd -t f -x du -h | sort -rh | head -20

# Find recently modified files
fd -t f -x stat -f "%m %N" | sort -rn | head -20

# Search for text in files
rg "pattern" --type py

# Count lines of code
fd -e py -x wc -l | awk '{sum+=$1} END {print sum}'

# JSON pretty print
cat file.json | jq .

# YAML to JSON
cat file.yaml | yq -o json

# Monitor file changes
watch -n 1 cat file.txt

# HTTP request
http GET https://api.example.com/endpoint

# Test network speed
curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python3 -

# Generate password
openssl rand -base64 32

# Check open ports
lsof -iTCP -sTCP:LISTEN -n -P
```

---

## Resources

- [Oh My Zsh Cheatsheet](https://github.com/ohmyzsh/ohmyzsh/wiki/Cheatsheet)
- [Tmux Cheatsheet](https://tmuxcheatsheet.com/)
- [Vim Cheatsheet](https://vim.rtorr.com/)
- [LazyVim Keymaps](https://www.lazyvim.org/keymaps)
- [Git Cheatsheet](https://education.github.com/git-cheat-sheet-education.pdf)
- [Docker Cheatsheet](https://docs.docker.com/get-started/docker_cheatsheet.pdf)
