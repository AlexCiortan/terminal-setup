# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.7.0] - 2026-03-15

### Fixed
- **WSL2 Installer Critical Fixes**
  - Fixed pipx installation to use Homebrew instead of system pip (Ubuntu 24.04 compatibility)
  - Fixed AWS CLI installation by ensuring unzip is installed first
  - Fixed PostgreSQL initialization with correct locale settings (LC_ALL and LANG)
  - Added missing atuin installation (shell history tool)
  - Fixed Jupyter installation to include base `jupyter` command (not just jupyter-lab)
  - Fixed VS Code extension installer to work in WSL2 environment
  - Fixed escape code rendering in completion messages (added -e flag to echo commands)

### Added
- **Jupyter Aliases**
  - Added convenient aliases to zshrc.wsl2: `jupyter`, `jl`, `jn`
  - Makes Jupyter commands easier to use

### Improved
- **VS Code Extension Installer**
  - Now detects WSL2 environment and provides specific setup instructions
  - Clear guidance for installing VS Code Server before running extensions script
  - Removed macOS-specific paths that don't apply to WSL2
  - Better error messages with actionable next steps

## [1.6.6] - 2026-03-15

### Added
- **Windows WSL2 Uninstaller**
  - New script: `windows/uninstall-wsl2.sh`
  - 3 uninstall options: configs only, configs+tmux, everything
  - Automatic backup before removal (timestamped)
  - Option to restore from oldest backup
  - Comprehensive tool removal (Homebrew packages, system packages, version managers)
  - Safe removal with DELETE confirmation for full uninstall
  - Stops services before removal
  - Optional Homebrew removal
  - Optional system package removal (zsh, build-essential)
  - Detailed post-uninstall notes
  - Explains Windows apps are NOT removed (VS Code, Docker Desktop)
  - Instructions for WSL2 complete removal (if desired)

### Improved
- **WSL2 Uninstall Experience**
  - Clear distinction between WSL2 and Windows applications
  - Step-by-step cleanup process
  - Preserves backups for safety
  - User-friendly prompts with explanations

## [1.6.5] - 2026-03-15

### Changed
- **PAT-Focused GitHub Setup During Installation**
  - Completely redesigned Git/GitHub configuration section in both installers
  - Now explicitly educates users about Personal Access Token (PAT) workflow
  - Clear separation: Git identity (user.name/email) vs GitHub authentication (PAT)
  - Interactive prompts ask "Do you have a Personal Access Token ready?"
  - Provides immediate `gh auth login` instructions if PAT is ready
  - Full setup checklist displayed if PAT not ready (SSH keys + PAT creation)
  - Emphasizes SSO requirements and PAT authorization steps
  - Improved visual design with bordered sections and emoji indicators
  - References docs/GITHUB_SETUP.md for complete guidance

### Improved
- **Better User Education**
  - Explains that SSH keys are for Git operations (never expire)
  - Explains that PAT is for GitHub CLI features (PRs, issues)
  - Makes SSO authorization explicit in the workflow
  - Clearer distinction between commit identity and authentication
  - Step-by-step instructions for both ready and not-ready scenarios

## [1.6.4] - 2026-03-15

### Added
- **Interactive Git User Configuration During Installation**
  - Both `install.sh` (macOS) and `windows/install-wsl2.sh` now prompt for Git user configuration
  - Asks for `user.name` and `user.email` during installation with skip option
  - Automatically detects if Git is already configured and shows current values
  - Provides clear instructions for manual configuration if skipped
  - Mentions Personal Access Token option for users with Google SSO
  - Safe to skip - can be configured later manually
  - Includes validation to prevent empty values

### Improved
- **Git Configuration Experience**
  - Consolidated Git setup: delta configuration + defaults + user identity in one place
  - Clear prompts with examples (e.g., "John Doe", "john@example.com")
  - User-friendly skip option with helpful post-skip instructions
  - Git defaults automatically configured: delta pager, main branch, nvim editor, rebase settings

## [1.6.3] - 2026-03-15

### Added
- **Comprehensive GitHub Integration Guide**
  - New documentation: `docs/GITHUB_SETUP.md` (300+ lines)
  - **Prominent SSO section**: "Recommended Setup for GitHub with Google SSO"
  - Complete guide for both SSH keys and GitHub CLI authentication
  - Step-by-step instructions for SSO users with Personal Access Tokens
  - Clear recommendation: SSH keys + PAT (not browser auth) for SSO
  - Troubleshooting section for common issues
  - Security best practices
  - Quick reference commands
  - Comparison table: SSH keys vs GitHub CLI features
  - Works for both macOS and Windows WSL2

### Improved
- **SSO-First Documentation**
  - All documentation now prominently features SSO setup instructions
  - `windows/README.md`: Added SSO callout with direct link to SSO guide
  - `windows/install-wsl2.sh`: Completion message warns about SSO and references guide
  - `README.md`: Updated post-installation to reference SSO setup
  - `README.md`: Added GitHub Integration to documentation table
  - Clear guidance: Browser auth won't work with SSO, use PAT instead

- **Windows README Phase 6 Updates**
  - Updated GitHub authentication section to reference comprehensive guide
  - Combined Git configuration with GitHub authentication (now one step)
  - Renumbered post-installation steps (step 4 → step 3, step 5 → step 4)
  - Added quick setup commands for immediate use
  - Better guidance for users with Google SSO

### Confirmed
- **Windows Installer "Install Everything" Option Already Works**
  - Option 1 in `windows/install-wsl2.sh` installs all tools non-interactively
  - Includes: Core tools, AI/ML tools, Kubernetes, Terraform, Git LFS
  - Fully automated - no prompts during installation

## [1.6.2] - 2026-03-15

### Added
- **VS Code Extension Installation for Windows + WSL2**
  - Updated `windows/README.md` Phase 3 with WSL extension installation instructions
  - Documented manual connection step: F1 → "WSL: Connect to WSL" → Select Ubuntu-24.04
  - Clarified that WSL extension must be installed and connected BEFORE using `code` command from WSL2
  - Updated Phase 6 with prerequisite check for WSL extension connection
  - Added step-by-step guide for running `./scripts/install-vscode-extensions.sh`
  - Extensions install in WSL2 context automatically (21 extensions from configs/vscode-extensions.txt)
  - Updated `windows/install-wsl2.sh` completion message with 3-step VS Code workflow (steps 7-9)

### Improved
- **Critical Flow Clarification**: WSL extension is REQUIRED and must be manually connected via F1
- Correct workflow documented:
  1. Install VS Code on Windows
  2. Install WSL extension in VS Code (Windows)
  3. Press F1 → "WSL: Connect to WSL" → Select Ubuntu-24.04
  4. Run `code .` from WSL2 to install VS Code Server
  5. Run extension installer script from WSL2
- Completion message now shows prerequisite step (step 7) with F1 connection before VS Code Server setup (step 8)
- Better highlighting and warnings about prerequisites
- Corrected extension name from "Remote - WSL" to "WSL"

## [1.6.1] - 2026-03-15

### Fixed
- **Windows README: Installation Phase Order**
  - **Problem**: Windows applications (Docker, VS Code) were listed before WSL2 installation
  - **Impact**: Illogical order - Docker Desktop requires WSL2 to exist for its WSL2 backend
  - **Solution**: Reorganized installation phases:
    - Phase 1: Verify Windows Terminal (1 minute)
    - Phase 2: Enable WSL2 + Ubuntu (5 minutes + restart)
    - Phase 3: Install Windows Applications (10 minutes) - Now correctly positioned AFTER WSL2
    - Phase 4: WSL2 Initial Verification (2 minutes)
    - Phase 5: Run the WSL2 Installer (20-30 minutes) - Renumbered from Phase 4
    - Phase 6: Post-Installation Configuration (10 minutes) - Renumbered from Phase 5
  - Now follows correct dependency order: Terminal → WSL2 → Windows apps that need WSL2 → WSL2 config

### Improved
- Phase 3 explicitly notes "Now that WSL2 exists" before installing Windows applications
- Docker Desktop settings now clarify WSL2 integration must be enabled after WSL2 is ready
- Fixed "Ready to install?" link to point to correct Phase 1 instead of old Phase 1

## [1.6.0] - 2026-03-15

### Added
- **Windows 11 + WSL2 Support** 🎉
  - Complete Windows setup with new `windows/` directory
  - Comprehensive `windows/README.md` with full setup guide (500+ lines)
  - `windows/install-wsl2.sh` - Combined installer for WSL2 Ubuntu 24.04
  - Architecture diagram showing Windows vs WSL2 split
  - Complete installation walkthrough (5 phases)
  - Windows-specific guidance:
    - VS Code + Remote WSL extension workflow
    - Docker Desktop with WSL2 backend integration
    - LM Studio on Windows for full GPU access (AMD 9070XT support)
    - Port forwarding between WSL2 and Windows (automatic)
    - File location strategy (WSL2 vs Windows filesystem)
  - Development workflow documentation
  - Backup/restore procedures for WSL2
  - Troubleshooting guide for common WSL2 issues
  - Comparison table: Windows vs macOS setup

- **Platform-Agnostic Installer**
  - WSL2 installer combines `install.sh` + `install-ai-tools.sh`
  - Uses Homebrew in WSL2 for consistency with macOS
  - Three installation modes:
    - Everything (recommended for new setup)
    - Essential tools only (skip AI/ML)
    - Custom selection (interactive prompts)
  - Idempotent design - safe to re-run
  - Automatic detection of existing tools
  - Progress indicators and detailed logging

### Improved
- **Main README.md Updates**
  - Added Windows 11 + WSL2 badge
  - Updated title: "for macOS & Windows"
  - New platform support section
  - Windows quick start instructions
  - Links to Windows-specific documentation

- **Documentation**
  - Cross-platform guidance
  - Platform-specific notes where applicable
  - Unified tooling approach (Homebrew on both platforms)

### Technical Details
- WSL2 installer validates environment (ensures running in WSL2)
- Homebrew installation adapted for Linux/WSL2
- Removed macOS-specific apps (Ghostty, Aerospace, macOS casks)
- LM Studio noted as Windows-side app for GPU access
- VS Code integration via Remote WSL extension
- Docker Desktop managed from Windows with WSL2 backend
- All CLI tools work identically on both platforms

### Platform-Specific Features

**macOS:**
- Ghostty terminal
- AeroSpace window manager (optional)
- Native app installations via Homebrew casks

**Windows + WSL2:**
- Windows Terminal (pre-installed)
- VS Code Remote WSL integration
- Docker Desktop with WSL2 engine
- LM Studio on Windows (full GPU)
- Automatic WSL2 ↔ Windows port forwarding

## [1.5.0] - 2026-03-13

### Added
- **Install Everything Option in install-ai-tools.sh**
  - Added non-interactive "Install everything" mode for quick installation
  - New installation menu with 3 options:
    - [1] Install everything (non-interactive, recommended)
    - [2] Interactive installation (choose each tool)
    - [0] Cancel
  - "Install everything" mode automatically installs:
    - Both Ollama and LM Studio for LLM testing
    - Insomnia for API testing (simpler, free option)
    - All Kubernetes tools (k9s, kubectx, stern)
    - All IaC tools (tfenv, tflint, terraform-docs)
    - Git LFS for versioning large files
  - Streamlines setup for users who want all AI development tools
  - Maintains idempotency - safe to run multiple times

### Improved
- Better UX for AI tools installation with clearer options
- Consistent with install.sh "Everything" option pattern
- Reduced decision fatigue for users who want complete setup

## [1.4.2] - 2026-03-13

### Improved
- **Optimized install-ai-tools.sh Based on install.sh Best Practices**
  - Added helper functions for consistent package management:
    - `brew_install_or_upgrade`: Idempotent brew package installation with proper logging
    - `is_brew_installed`: Clean check for installed Homebrew packages
    - `is_app_installed`: Reusable check for macOS applications
    - `brew_cask_install_or_skip`: Idempotent cask installation
  - Added `log_error` function for consistent error reporting
  - Added Homebrew update with automatic tap error handling (like install.sh v1.4.1)
  - Replaced all direct `brew list` checks with `is_brew_installed` helper
  - Replaced all app directory checks with `is_app_installed` helper
  - Improved code maintainability and consistency with main installer
  - Better error messages and user feedback throughout installation

### Technical Details
- All brew package checks now use consistent helper functions
- Homebrew tap issues are automatically detected and resolved
- Installation is more robust and handles edge cases better
- Code is now more maintainable with reusable functions

## [1.4.1] - 2026-03-13

### Fixed
- **Critical: Starship Config TOML Parse Error**
  - **Problem**: Starship failed to load with "missing escaped value" error on line 32
  - **Root Cause**: Invalid TOML escaping `\$${count}` - backslash-dollar is not valid in TOML
  - **Solution**: Changed `stashed = "\$${count}"` to `stashed = "$${count}"`
  - Starship now loads without errors and displays git status correctly

- **Critical: Homebrew Update Failing on Re-runs**
  - **Problem**: Re-running install.sh failed with "Error: Fetching /opt/homebrew/Library/Taps/anthropics/homebrew-claude failed!"
  - **Root Cause**: anthropics/claude tap was empty/broken, causing brew update to fail on subsequent runs
  - **Solution**:
    - Added error detection for failed brew update
    - Automatically untaps and retries if anthropics/claude tap is broken
    - Made brew update non-fatal (continues even if update fails)
    - Added retry logic to Claude Code tap installation
  - Now idempotent - can re-run install.sh multiple times without errors

### Improved
- Better error handling for Homebrew tap issues
- Automatic cleanup of broken taps
- Installation no longer blocks on Homebrew update failures
- Clear warning messages when update issues are detected and resolved

## [1.4.0] - 2026-03-13

### Added
- **Optional gh-dash Installation with SSO Warning**
  - Added interactive prompt when installing gh-dash (option 3 or 5)
  - Warns users that gh-dash may not work with Google SSO before installation
  - Users can now skip gh-dash installation if they use SSO
  - Added comprehensive setup instructions at completion for gh-dash users
  - Instructions include alternative authentication method using Personal Access Token
  - Detailed steps for both standard auth (`gh auth login`) and PAT method
  - Shows required token scopes (repo, read:org, read:user)

### Improved
- **Enhanced gh-dash Documentation**
  - Added prominent highlighted box in completion message with setup instructions
  - Clear explanation of Google SSO limitation
  - Step-by-step authentication guide
  - Quick reference for gh-dash keyboard shortcuts
  - Updated README to note SSO limitation
  - Better user experience for those with SSO-enabled GitHub accounts

### Changed
- gh-dash installation now requires explicit user confirmation (y/n prompt)
- Tracks whether gh-dash was actually installed (`GHDASH_INSTALLED` variable)
- Only shows gh-dash instructions if it was installed

## [1.3.6] - 2026-03-13

### Improved
- **Enhanced Tmux Plugin Installation Documentation**
  - Added prominent highlighted box in completion message for required tmux plugin installation
  - Added detailed step-by-step instructions (start tmux → Ctrl+b + Shift+I → wait → detach)
  - Added tmux setup section to README Post-Installation guide
  - Added "First-Time Tmux Setup" section in Key Features with clear instructions
  - Includes list of plugins being installed (sessionx, floax, thumbs, catppuccin)
  - Users now have three places to find these instructions (completion message, README post-install, README features)
  - Clear visual separator makes the required step impossible to miss

## [1.3.5] - 2026-03-13

### Fixed
- **Critical: Tmux Plugin Installation Error**
  - **Problem**: Script failed with "FATAL: Tmux Plugin Manager not configured" error
  - **Root Cause**: TPM's install script requires being run inside a tmux session (uses tmux-specific environment variables)
  - **Solution**:
    - Removed automatic plugin installation via `~/.tmux/plugins/tpm/bin/install_plugins`
    - TPM and tmux.conf are properly configured during installation
    - Added clear instructions: Start tmux and press `Ctrl+b` then `Shift+I` to install plugins
    - Updated completion message with first-time plugin installation steps
  - This is the standard TPM installation flow and works reliably

### Improved
- Better user guidance for tmux plugin installation
- Clear instructions shown both during tmux.conf setup and in completion message
- Users understand they need one manual step (press Ctrl+b + Shift+I) in tmux

## [1.3.4] - 2026-03-13

### Fixed
- **Critical: Removed tmux-thumbs Homebrew Installation**
  - **Problem**: Script tried to install `tmux-thumbs` via Homebrew, causing installation to fail
  - **Root Cause**: `tmux-thumbs` is a tmux plugin (installed via TPM), NOT a Homebrew package
  - **Solution**:
    - Removed `brew_install_or_upgrade tmux-thumbs` from install.sh
    - tmux-thumbs is already configured in tmux.conf and installed automatically by TPM
    - Removed from uninstall.sh brew package list (handled by ~/.tmux/plugins removal)
  - Installation now completes successfully without errors

### Improved
- **VS Code Extension Installer: Better Trust Failure Messaging**
  - Added clear instructions for extensions that require manual trust approval
  - Explains how to manually install via VS Code UI with trust prompt
  - Specific guidance for extensions like `anthropics.claude-code` that need publisher trust
  - Users now understand why some extensions fail and how to fix it

## [1.3.3] - 2026-03-13

### Fixed
- **Critical: VS Code Extensions Now Install Only After VS Code is Ready**
  - **Problem**: Extensions were installed immediately after VS Code installation with no checks or wait time
  - **Impact**: On fresh installations, `code` CLI might not be ready, causing all extensions to fail silently
  - **Solution**:
    - Added check to verify VS Code is actually installed before attempting extension installation
    - If VS Code was just installed (not already present), wait 3 seconds for initialization
    - Only call extension installer if VS Code app is confirmed present
    - Provides clear skip message if VS Code not found
  - Now extensions install reliably on both fresh installs and existing VS Code setups

### Improved
- Better separation between VS Code installation and extension installation
- Clear feedback if VS Code installation failed or was skipped
- Graceful fallback with instructions if extension installation needs to be run manually

## [1.3.2] - 2026-03-13

### Fixed
- **Critical: Starship Configuration Now Always Installed**
  - **Problem**: Starship config was only installed if choosing option 2 or 5 (Terminal Enhancements)
  - **Impact**: If you chose option 1 (Essential Tools), Starship was installed but had NO config file
  - **Solution**: Moved starship.toml configuration to Section 1 (always runs)
  - Now configured immediately after installation, just like Ghostty and Neovim
  - Starship config is now part of core installation (not optional)

### Improved
- Section 4 (Terminal Enhancements) now checks if starship already configured before attempting to reconfigure
- Configuration verification now checks for starship.toml in core configs section
- Consistent pattern: all tools have their configs applied immediately after installation

## [1.3.1] - 2026-03-13

### Fixed
- **Sudo Password Still Asked During Installation**
  - **Problem**: Even though sudo password was requested at start, Docker and VS Code installations still prompted for password
  - **Root Cause**: Background sudo keep-alive process wasn't working properly for Homebrew cask subprocesses
  - **Solution**:
    - Improved sudo keep-alive with proper subprocess handling
    - Added explicit sudo refresh before Essential Tools section (where GUI apps are installed)
    - Reduced keep-alive interval from 60s to 50s for more reliability
  - Now sudo is refreshed right before Docker/VS Code installations for smoother experience

### Updated
- **validate.sh Script**
  - Added validation for `configs/vscode-extensions.txt`
  - Added validation for `scripts/install-vscode-extensions.sh`
  - Now validates 24 required files (was 22)
  - Validates all 5 shell scripts including new VS Code extension installer

- **uninstall.sh Script**
  - Updated sudo keep-alive to match improved pattern from install.sh
  - More reliable sudo session management during uninstall process

### Improved
- All three scripts (install, uninstall, validate) now use consistent sudo handling
- Better subprocess management for background keep-alive jobs

## [1.3.0] - 2026-03-13

### Changed - MAJOR IMPROVEMENT
- **VS Code Extensions Now in Separate Config File**
  - **Problem**: Extensions were hardcoded in install.sh (108 lines of code)
  - **Problem**: On test computer, ZERO extensions installed (entire process failed silently)
  - **Problem**: If `code` command unavailable, all extensions skipped with no clear error
  - **Solution**: Created new architecture:
    - `configs/vscode-extensions.txt` - Simple text file with extension list (21 extensions)
    - `scripts/install-vscode-extensions.sh` - Standalone installer script
    - Extensions now mandatory during setup (not optional)
  - **Benefits**:
    - ✅ Easy to customize (just edit text file)
    - ✅ Can be re-run if it fails: `./scripts/install-vscode-extensions.sh`
    - ✅ Works with `code` command OR full VS Code CLI path as fallback
    - ✅ Clear summary showing success/failed extensions
    - ✅ Much better error handling and visibility
    - ✅ Separated concerns (install.sh stays clean)

### Added
- **21 Curated VS Code Extensions** (all mandatory):
  - Claude AI: anthropics.claude-code, andrepimenta.claude-code-chat
  - Python: python, pylance, jupyter, ruff, black-formatter
  - Git: gitlens, github PRs, github-actions
  - Docker: vscode-docker, remote-containers
  - Languages: yaml
  - Productivity: errorlens, path-intellisense, better-comments
  - Themes: material-icon-theme, vscode-theme-onedark
  - Optional: copilot-chat, gitlab-workflow, vim keybindings

### Fixed
- VS Code extensions now install reliably even if `code` CLI not in PATH
- Clear error messages if VS Code not installed
- Installation summary shows what succeeded/failed
- Can re-run extension installer without re-running full setup

## [1.2.1] - 2026-03-13

### Fixed - CRITICAL
- **Option 5 "Everything" Now Actually Installs Everything**
  - **Problem**: Option 5 was missing AeroSpace installation
  - **Impact**: Choosing "Everything" didn't install the window manager
  - **Solution**: Added `INSTALL_AEROSPACE=true` to option 5 case
  - Now option 5 truly installs all 4 components (Essential, Terminal, gh-dash, AeroSpace)

- **Enhanced .zshrc Copy Verification**
  - **Problem**: User chose option 5 and still got empty .zshrc
  - **Solution**: Added multiple verification checks:
    - Verify source file exists
    - Verify source file is not empty
    - Use `cp -f` (force) to ensure overwrite
    - Verify destination file exists after copy
    - Verify destination file is not empty after copy
    - Show line count to confirm copy succeeded
    - Exit with clear error if any check fails
  - Now impossible for .zshrc to be empty silently

### Improved
- Better error messages showing current directory if configs/zshrc not found
- Line count shown in success message: ".zshrc configured with all aliases (257 lines copied)"
- Immediate failure if copy doesn't work (no silent failures)

## [1.2.0] - 2026-03-13

### Fixed - CRITICAL
- **Zsh Configuration Now ALWAYS Installed**
  - **Problem**: `.zshrc` and zsh plugins were ONLY installed if you chose option 2 or 5
  - **Impact**: If you chose option 1 (Essential Tools), you got:
    - EMPTY ~/.zshrc or only nvm initialization
    - NO aliases (vi, lg, z, etc.)
    - NO zsh-autosuggestions
    - NO zsh-syntax-highlighting
    - Shell was basically broken
  - **Solution**: Moved zshrc + zsh plugins to Section 1 (ALWAYS runs)
  - All shell configs now installed regardless of which option you choose
  - This is a breaking change in behavior, but fixes a critical bug

- **Docker Uninstall Password Prompt**
  - Added `sudo` to GUI app uninstall commands in uninstall.sh
  - Now uses the sudo session already established
  - No more mid-uninstall password prompts for Docker, VS Code, etc.

### Added
- **Comprehensive Configuration Verification**
  - Now ALWAYS runs at the end (not just for Terminal Enhancements)
  - Shows status of all core configs:
    - ~/.zshrc
    - zsh-autosuggestions
    - zsh-syntax-highlighting
    - Ghostty config
    - Neovim/LazyVim
    - Tmux configs (if installed)
  - Immediately see if any config failed to install
  - Clear ✓ checkmarks for what's working

### Changed
- Zsh plugins, fzf key bindings, and .zshrc now part of core installation
- Section 4 (Terminal Enhancements) is now truly optional - just for advanced tmux features
- Core shell functionality no longer depends on choosing the right installation option

## [1.1.6] - 2026-03-13

### Fixed
- **Uninstall Script UX Improvements**
  - **Sudo Password Upfront**: Now prompts for sudo at start (option 3 only)
  - Keeps sudo alive in background to prevent mid-uninstall prompts
  - Previously would interrupt with password requests during removal
- **Removed Redundant Confirmations**
  - **Problem**: Option 3 "Everything" required 8 separate confirmations
  - **Solution**: Changed confirmation from "yes" to "DELETE" (more explicit)
  - Now removes everything in one go without asking about each component
  - Individual prompts removed for: GUI apps, Claude CLI, nvm, pyenv, Zsh plugins, pipx, nvim
  - You confirm once with "DELETE", then it removes everything

### Improved
- Cleaner uninstall flow: choose option 3 → sudo password → type DELETE → done!
- Progress shown for each category as it's removed
- No more repetitive y/n questions after choosing "Everything"

## [1.1.5] - 2026-03-13

### Added
- **Interactive Shell Restart**
  - Now prompts to restart shell at completion to activate all changes
  - Automatically runs `exec zsh -l` if user confirms
  - Solves issue of aliases not working until manual shell restart
  - Previously only showed instructions, now actually does it
  - All aliases (vi, lg, z, etc.) work immediately after restart

### Improved
- Better workflow: install → restart shell → all features work!
- Simple reminder about optional AI tools script (install-ai-tools.sh)
- No more manual steps required to activate aliases and configs

## [1.1.4] - 2026-03-13

### Fixed
- **Critical: Installation Order - Configs Applied Immediately**
  - **Problem**: Ghostty config was installed 324 lines AFTER Ghostty installation
  - **Problem**: LazyVim config was installed 355 lines AFTER neovim installation
  - **Impact**: If users launched apps before Terminal Enhancements section, configs were missing
  - **Solution**: Now configs are applied IMMEDIATELY after each tool installation:
    - Ghostty installed → Config copied to ~/.config/ghostty/config → Done
    - Neovim installed → LazyVim cloned to ~/.config/nvim → Done
  - Configs are applied in Section 1 (always runs) not Section 4 (optional)
  - Made Terminal Enhancements section idempotent (skips if already configured)
- **UX: Completion Instructions**
  - Added Ghostty launch instructions (shows configured theme and font)
  - Updated Neovim instructions to mention `vi` alias works
  - Instructions now show regardless of which installation option was selected
  - Fixed numbering in next steps list

### Improved
- JetBrains Mono font now installed before Ghostty (required by config)
- Neovim LazyVim setup happens immediately after neovim installation
- All tool configurations applied in correct dependency order

## [1.1.3] - 2026-03-13

### Fixed
- **Critical: Logging Function**
  - Replaced `echo -e` with `printf` in `_log()` function for true POSIX compliance
  - Fixes `-e` appearing in log files when run with sh
  - Now works correctly with both sh and bash shells
- **Critical: VS Code Extension Installation**
  - Increased timeout from 60 to 120 seconds for extension installations
  - Added 2-second delay after VS Code installation to ensure binary is available
  - Added progress dots every 10 seconds during extension installation
  - Better handling for slow extension installations on fresh systems
- **UX: Sudo Password Prompt**
  - Now prompts for sudo password at the beginning of installation
  - Keeps sudo alive in background to avoid mid-installation prompts
  - Previously interrupted installation when Docker required sudo
- **UX: Configuration Verification**
  - Added configuration verification section after Terminal Enhancements
  - Shows checkmarks for successfully applied configs (zshrc, tmux.conf, starship, ghostty, nvim)
  - Warns about any missing configs immediately
- **UX: Shell Restart Notice**
  - Added prominent warning to restart terminal for aliases to work
  - Shows at completion with command to reload shell: `exec zsh`
  - Prevents confusion about aliases not working immediately

### Improved
- Better progress feedback during long-running operations
- Clearer next steps instructions after installation

## [1.1.2] - 2026-03-13

### Fixed
- **Critical: Shell Compatibility Check**
  - Added bash check at start of all scripts (install.sh, install-ai-tools.sh, uninstall.sh, validate.sh)
  - Scripts now automatically re-execute with bash if called with sh
  - Fixes "syntax error unexpected token '>'" when running with `sh install.sh`
  - Process substitution `>(tee)` requires bash, not available in standard sh
  - Scripts now work correctly regardless of how they're invoked (sh/bash/direct execution)

## [1.1.1] - 2026-03-13

### Fixed
- **Critical: macOS Compatibility for VS Code Extensions**
  - Replaced Linux `timeout` command with native bash implementation
  - Previous version would fail on fresh Macs (timeout command not available)
  - Now uses background processes with kill -0 polling (works on all Unix systems)
  - Fully compatible with macOS without requiring additional packages

## [1.1.0] - 2026-03-13

### Added
- **Comprehensive Uninstall Script**: Massively improved uninstall functionality
  - Now removes ALL packages installed by the installer (previously only removed 9 packages)
  - Organized removal by category: core tools, terminal tools, Python tools, databases, etc.
  - Added removal for GUI apps (Docker, VS Code, Chrome, Ghostty, AeroSpace)
  - Added removal for Claude Code CLI and tap
  - Added removal for Zsh plugins, pipx tools, Neovim config
  - Interactive prompts for each major component for user control
  - Backs up Ghostty config before removal
- **Enhanced Validate Script**: Comprehensive validation improvements
  - Now checks 21 required files (was 12): added VERSION, CHANGELOG, install-ai-tools.sh, docs
  - Validates VERSION file format (X.Y.Z)
  - Checks logs directory structure
  - Verifies .gitignore properly excludes log files
  - Validates all 4 shell scripts (including validate.sh itself)
  - Better error messages with warnings for non-critical issues

### Fixed
- **Uninstall Script**: Previously only removed 9 packages, now handles 40+ packages
- **Validate Script**: Was missing validation for VERSION, CHANGELOG, install-ai-tools.sh, and itself
- **UI: Fixed ASCII Art Box Alignment in uninstall.sh**
  - Banner now matches install.sh alignment (62 characters)

## [1.0.9] - 2026-03-13

### Fixed
- **Critical: VS Code Extension Installation Exit Code Check**
  - Now properly detects timeouts (exit code 124)
  - Correctly identifies failed installations (non-zero exit codes)
  - Previous version would incorrectly report success on timeouts
  - Shows actual error output when extensions fail
- **Security: Removed Hardcoded AWS Profile**
  - Removed personal AWS profile `gamekit-next-aq-prod-aws-bedrock-136172187201` from zshrc
  - Now commented out with placeholder for users to set their own
- **Code Quality: Fixed Shell Variable Quoting**
  - Properly quoted `$PYENV_ROOT` variable in zshrc for better safety
- **UI: Fixed ASCII Art Box Alignment**
  - Corrected banner box drawing characters in both install.sh and install-ai-tools.sh
  - Now perfectly aligned with 62 characters width

## [1.0.8] - 2026-03-13

### Added
- **Installation Logging**: All installation output now logs to `logs/install_YYYYMMDD_HHMMSS.log`
  - Complete record of every step for troubleshooting
  - Automatic cleanup keeps only the last 10 log files
  - Log file location shown at start and end of installation
  - Logs directory automatically created in repository root
  - Already included in .gitignore (won't be committed)

### Changed
- Removed `vim='nvim'` alias, keeping only `vi='nvim'` as requested

## [1.0.7] - 2026-03-13

### Fixed
- **Critical: VS Code Extension Installation Hanging**
  - Added 60-second timeout per extension to prevent script from blocking indefinitely
  - Extensions now continue installing even if one fails
  - Better error handling with warnings instead of silent failures
  - Shows progress messages during installation
- Script now completes all sections even if extension installation has issues

### Changed
- Extension installation shows "This may take a few minutes..." message for clarity
- Failed extensions log warnings but don't stop the installation process

## [1.0.6] - 2026-03-13

### Added
- **Claude Code CLI**: Installed via Homebrew tap (anthropics/claude)
- **Claude VS Code Extensions**:
  - Anthropics Claude Code (official extension)
  - Claude Code Chat by Andre Pimenta
- Both CLI and extensions use idempotent installation patterns

### Changed
- Claude extensions added at the top of VS Code extensions list for priority
- Total VS Code extensions increased to 24

## [1.0.5] - 2026-03-13

### Added
- **VS Code Extensions**: Automatic installation of 22 curated extensions for AI/ML development
  - Python ecosystem: Python, Pylance, Jupyter, Black formatter, Ruff linter
  - Git/GitHub: GitLens, GitHub Pull Requests
  - Docker: Docker support, Remote Containers
  - Database: SQLTools with PostgreSQL driver
  - Data formats: YAML, TOML, CSV highlighting
  - Productivity: Vim keybindings, Error Lens, Path Intellisense, TODO highlighting
  - Themes: Catppuccin theme, Material Icon theme
- Idempotent extension installation (skips if already installed)
- Graceful handling when `code` command is not yet available

## [1.0.4] - 2026-03-13

### Added
- Visual Studio Code installation (via Homebrew) for Claude Code and AI development
- Google Chrome browser installation (via Homebrew)
- Both use idempotent installation pattern (skip if already installed)

### Changed
- Updated README to list VS Code and Chrome in development tools section

## [1.0.3] - 2026-03-13

### Added
- **LazyVim setup**: Automatically clones LazyVim starter configuration for Neovim
- Post-installation instructions for completing LazyVim plugin setup
- Detects existing Neovim config to avoid overwriting custom setups

### Changed
- Updated completion messages to guide users through LazyVim first-time setup
- Improved step numbering in post-installation instructions

## [1.0.2] - 2026-03-13

### Added
- Ghostty terminal configuration file (`configs/ghostty`)
- JetBrains Mono font installation (via Homebrew)
- Automatic Ghostty config setup to `~/.config/ghostty/config`
- Configuration uses JetBrains Mono font with optimized settings:
  - Dark+ theme with 90% opacity and blur
  - Native macOS titlebar integration
  - Shell integration for sudo and title features
  - Blinking block cursor

### Changed
- Updated validation scripts to check for ghostty config
- Updated documentation to include Ghostty configuration

## [1.0.1] - 2026-03-13

### Fixed
- **Critical:** Added missing tool installations that configs depend on
  - Added tmux installation (was only installing tmux-thumbs plugin)
  - Added neovim installation (configs alias vim/vi to nvim)
  - Added starship prompt installation (config file existed but tool wasn't installed)
  - Added atuin shell history installation (referenced in zshrc)
  - Added zoxide smart cd installation (referenced in zshrc)
  - Added fzf fuzzy finder installation (referenced in zshrc)
  - Added bat cat replacement installation (aliased in zshrc)
  - Added eza modern ls installation (aliased in zshrc)
  - Added Ghostty terminal installation (mentioned in README)
  - Added zsh-autosuggestions plugin installation
  - Added zsh-syntax-highlighting plugin installation
  - Added fzf key bindings installation

### Changed
- Enhanced post-installation verification to check for tmux, neovim, and starship
- Moved tool installations to earlier in script (before configs that depend on them)

## [1.0.0] - 2026-03-13

### Added
- Initial release of Terminal Setup for AI Development
- Interactive installer with idempotent design
- Core terminal tools (Ghostty, Tmux with advanced plugins)
- Enhanced shell configuration (Zsh, Starship, Atuin, Zoxide)
- Git workflow tools (lazygit, gh, git-delta)
- Development tools (Node.js via nvm, Python via pyenv)
- Docker Desktop integration
- AWS CLI setup
- Databases (PostgreSQL 16, Redis)
- Modern CLI tools (ripgrep, fd, bat, eza, fzf)
- Tmux enhancements (sessionx, floax, thumbs, Catppuccin theme)
- GitHub dashboard (gh-dash)
- Optional window manager (AeroSpace)
- AI-specific tools installer
- Jupyter Lab support
- Local LLM tools (Ollama + LM Studio)
- Vector database support (pgvector, ChromaDB)
- API testing tools (httpie, Insomnia/Postman)
- System monitoring (glances, bottom)
- Database GUI (DBeaver)
- Documentation tools (mermaid-cli, graphviz)
- Comprehensive documentation (Quick Start, Reference, Advanced)
- Safe uninstall script with backup restore
- Pre-flight validation script
- Test guide for existing setups

### Features
- Automatic backup of existing configurations
- Idempotent installation (safe to run multiple times)
- Detects and skips existing installations
- Auto-upgrades outdated brew packages
- Pre-flight checks (Xcode tools, disk space, macOS version)
- Post-installation verification
- Interactive component selection

### Documentation
- README with badges and comprehensive guide
- QUICKSTART guide for fast setup
- REFERENCE guide with all commands and shortcuts
- ADVANCED guide for power users
- RECOMMENDED_ADDITIONS for AI development tools
- TEST_ON_OLD_COMPUTER guide for safe testing
- CONTRIBUTING guide for contributors

### Repository Structure
- Clean root directory with main entry point scripts
- Organized configs/ directory for all configuration templates
- Organized docs/ directory for all documentation
- Organized scripts/ directory for supporting utilities
- GitHub Actions CI/CD workflow for automated validation
- Issue and PR templates for contributions
- EditorConfig for consistent code style

---

[1.4.1]: https://github.com/AlexCiortan/terminal-setup/releases/tag/v1.4.1
[1.4.0]: https://github.com/AlexCiortan/terminal-setup/releases/tag/v1.4.0
[1.3.6]: https://github.com/AlexCiortan/terminal-setup/releases/tag/v1.3.6
[1.3.5]: https://github.com/AlexCiortan/terminal-setup/releases/tag/v1.3.5
[1.3.4]: https://github.com/AlexCiortan/terminal-setup/releases/tag/v1.3.4
[1.3.3]: https://github.com/AlexCiortan/terminal-setup/releases/tag/v1.3.3
[1.3.2]: https://github.com/AlexCiortan/terminal-setup/releases/tag/v1.3.2
[1.3.1]: https://github.com/AlexCiortan/terminal-setup/releases/tag/v1.3.1
[1.3.0]: https://github.com/AlexCiortan/terminal-setup/releases/tag/v1.3.0
[1.2.1]: https://github.com/AlexCiortan/terminal-setup/releases/tag/v1.2.1
[1.2.0]: https://github.com/AlexCiortan/terminal-setup/releases/tag/v1.2.0
[1.1.6]: https://github.com/AlexCiortan/terminal-setup/releases/tag/v1.1.6
[1.1.5]: https://github.com/AlexCiortan/terminal-setup/releases/tag/v1.1.5
[1.1.4]: https://github.com/AlexCiortan/terminal-setup/releases/tag/v1.1.4
[1.1.3]: https://github.com/AlexCiortan/terminal-setup/releases/tag/v1.1.3
[1.1.2]: https://github.com/AlexCiortan/terminal-setup/releases/tag/v1.1.2
[1.1.1]: https://github.com/AlexCiortan/terminal-setup/releases/tag/v1.1.1
[1.1.0]: https://github.com/AlexCiortan/terminal-setup/releases/tag/v1.1.0
[1.0.9]: https://github.com/AlexCiortan/terminal-setup/releases/tag/v1.0.9
[1.0.8]: https://github.com/AlexCiortan/terminal-setup/releases/tag/v1.0.8
[1.0.7]: https://github.com/AlexCiortan/terminal-setup/releases/tag/v1.0.7
[1.0.6]: https://github.com/AlexCiortan/terminal-setup/releases/tag/v1.0.6
[1.0.5]: https://github.com/AlexCiortan/terminal-setup/releases/tag/v1.0.5
[1.0.4]: https://github.com/AlexCiortan/terminal-setup/releases/tag/v1.0.4
[1.0.3]: https://github.com/AlexCiortan/terminal-setup/releases/tag/v1.0.3
[1.0.2]: https://github.com/AlexCiortan/terminal-setup/releases/tag/v1.0.2
[1.0.1]: https://github.com/AlexCiortan/terminal-setup/releases/tag/v1.0.1
[1.0.0]: https://github.com/AlexCiortan/terminal-setup/releases/tag/v1.0.0
