# GitHub Integration Setup Guide

Complete guide for connecting Git/GitHub on macOS and Windows WSL2.

---

## Quick Overview

You have **two options** for GitHub authentication:

1. **SSH Keys** (Recommended) - Best for regular git operations
2. **GitHub CLI (`gh`)** - Best for GitHub-specific features (PRs, issues)

**Most users should set up both.**

---

## 🔒 Recommended Setup for GitHub with Google SSO

**If your organization uses Google SSO for GitHub, follow this approach:**

### Best Practice for SSO Users

**1. Use SSH Keys for Git Operations** ✅
- SSH keys work perfectly with SSO
- No special configuration needed
- Most reliable for daily git operations (push/pull/clone)
- **Follow:** [Option 1: SSH Keys](#option-1-ssh-keys-required-for-git-pushpull) below

**2. Use Personal Access Token (PAT) for GitHub CLI** ✅
- Browser auth won't work with SSO organizations
- PAT gives you full control over permissions
- Must authorize PAT for your SSO organization
- **Follow:** [GitHub with Google SSO](#special-case-github-with-google-sso) section below

### Quick Setup for SSO Users

```bash
# 1. Set up SSH keys for git (works immediately)
ssh-keygen -t ed25519 -C "your.email@example.com"
cat ~/.ssh/id_ed25519.pub
# Add to: https://github.com/settings/keys

# 2. Test SSH
ssh -T git@github.com

# 3. Configure Git
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"

# 4. Create Personal Access Token
# Go to: https://github.com/settings/tokens
# Click: Generate new token (classic)
# Scopes: repo, read:org, read:user, workflow
# Copy the token!

# 5. Authenticate GitHub CLI with token
gh auth login
# Choose: GitHub.com → HTTPS → Paste an authentication token
# Paste your token

# 6. Authorize token for SSO
# Go to: https://github.com/settings/tokens
# Click: Configure SSO → Authorize for your organization
```

**Why this approach?**
- ✅ SSH keys: Zero configuration, works immediately
- ✅ PAT with GitHub CLI: Full control, explicit SSO authorization
- ❌ Browser auth: Won't work for SSO-protected repos

---

## Option 1: SSH Keys (Required for Git Push/Pull)

### Step 1: Generate SSH Key

```bash
# Generate a new SSH key (use your GitHub email)
ssh-keygen -t ed25519 -C "your.email@example.com"

# When prompted:
# - Save location: Press Enter (default: ~/.ssh/id_ed25519)
# - Passphrase: Press Enter twice (no passphrase) or enter a secure passphrase
```

**Why ed25519?** It's more secure and faster than RSA.

### Step 2: Copy Your Public Key

```bash
# Display and copy your public key
cat ~/.ssh/id_ed25519.pub

# Example output:
# ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAI... your.email@example.com
```

Copy the **entire output** (starts with `ssh-ed25519`).

### Step 3: Add SSH Key to GitHub

1. Go to: https://github.com/settings/keys
2. Click **"New SSH key"**
3. Fill in:
   - **Title**: Something descriptive (e.g., "MacBook Pro M5" or "Windows PC WSL2")
   - **Key type**: Authentication Key
   - **Key**: Paste your public key from Step 2
4. Click **"Add SSH key"**
5. Confirm with your GitHub password if prompted

### Step 4: Test SSH Connection

```bash
# Test the connection
ssh -T git@github.com

# Expected output:
# Hi YourUsername! You've successfully authenticated, but GitHub does not provide shell access.
```

✅ **Success!** You can now clone, push, and pull via SSH.

### Step 5: Configure Git

```bash
# Set your name and email (should match your GitHub account)
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"

# Verify settings
git config --global --list
```

### Using SSH URLs

```bash
# Clone a repository using SSH
git clone git@github.com:username/repository.git

# If you already have a repo with HTTPS, switch to SSH:
cd your-repo
git remote set-url origin git@github.com:username/repository.git
```

---

## Option 2: GitHub CLI Authentication (For GitHub Features)

The GitHub CLI (`gh`) provides additional features beyond git:
- Create/manage PRs and issues from CLI
- View repository information
- Manage GitHub Actions
- Authentication for private repos

### Step 1: Authenticate with GitHub

```bash
# Start the authentication process
gh auth login
```

### Step 2: Follow the Prompts

```
? What account do you want to log into?
  → GitHub.com

? What is your preferred protocol for Git operations?
  → SSH (or HTTPS if you prefer)

? Authenticate Git with your GitHub credentials?
  → Yes

? How would you like to authenticate GitHub CLI?
  → Login with a web browser
```

### Step 3: Browser Authentication

1. Copy the one-time code shown in terminal (e.g., `ABCD-1234`)
2. Press Enter - browser opens to https://github.com/login/device
3. Paste the code
4. Click **"Authorize github"**
5. Return to terminal - you're authenticated!

### Step 4: Verify Authentication

```bash
# Check authentication status
gh auth status

# Test by viewing your repos
gh repo list

# Test by viewing issues
gh issue list
```

### Special Case: GitHub with Google SSO

If your organization uses Google SSO:

**Option A: Personal Access Token (Recommended)**

1. Go to: https://github.com/settings/tokens
2. Click **"Generate new token"** → **"Generate new token (classic)"**
3. Fill in:
   - **Note**: "CLI access from my machine"
   - **Expiration**: 90 days (or No expiration if you accept the risk)
   - **Scopes**: Select:
     - `repo` (Full control of private repositories)
     - `read:org` (Read org and team membership)
     - `read:user` (Read user profile data)
     - `workflow` (Update GitHub Action workflows)
4. Click **"Generate token"**
5. **Copy the token immediately** (you won't see it again!)

Then authenticate with `gh`:

```bash
gh auth login

# Choose:
# → GitHub.com
# → HTTPS
# → Paste an authentication token
# → Paste your token
```

**Option B: Authorize SSO for Tokens**

After creating any token or authenticating:
1. Go to: https://github.com/settings/tokens
2. Find your token
3. Click **"Configure SSO"** next to your organization
4. Click **"Authorize"**

---

## What's the Difference?

| Feature | SSH Keys | GitHub CLI (`gh`) |
|---------|----------|-------------------|
| **Git clone/push/pull** | ✅ Yes | ✅ Yes (if configured) |
| **Create PRs** | ❌ No | ✅ Yes (`gh pr create`) |
| **View issues** | ❌ No | ✅ Yes (`gh issue list`) |
| **Manage Actions** | ❌ No | ✅ Yes (`gh run list`) |
| **View repo info** | ❌ No | ✅ Yes (`gh repo view`) |
| **Authentication method** | Public/private key pair | OAuth token |
| **Expires?** | ❌ Never | ⚠️ Token can expire |

**Recommendation:** Set up both!
- **SSH keys** for daily git operations (push/pull/clone)
- **GitHub CLI** for GitHub-specific features (PRs, issues, workflows)

---

## Quick Reference Commands

### SSH Keys
```bash
# Generate key
ssh-keygen -t ed25519 -C "your@email.com"

# Copy public key to clipboard (macOS)
pbcopy < ~/.ssh/id_ed25519.pub

# Copy public key to clipboard (WSL2)
cat ~/.ssh/id_ed25519.pub | clip.exe

# Test connection
ssh -T git@github.com
```

### GitHub CLI
```bash
# Login
gh auth login

# Check status
gh auth status

# View your repos
gh repo list

# Clone repo (automatically uses correct URL)
gh repo clone username/repository

# Create a PR
gh pr create

# View PRs
gh pr list

# View issues
gh issue list
```

### Git Configuration
```bash
# Set global config
git config --global user.name "Your Name"
git config --global user.email "your@email.com"

# View all config
git config --global --list

# Switch remote from HTTPS to SSH
git remote set-url origin git@github.com:username/repo.git
```

---

## Troubleshooting

### "Permission denied (publickey)"

**Problem:** Git push/pull fails with SSH.

**Solution:**
1. Check SSH key was added to GitHub: https://github.com/settings/keys
2. Test SSH connection: `ssh -T git@github.com`
3. Check SSH agent is running:
   ```bash
   eval "$(ssh-agent -s)"
   ssh-add ~/.ssh/id_ed25519
   ```

### "Could not read from remote repository"

**Problem:** Cloned with HTTPS but want to use SSH.

**Solution:**
```bash
# Check current remote
git remote -v

# Change to SSH
git remote set-url origin git@github.com:username/repo.git
```

### GitHub CLI Not Working with SSO

**Problem:** `gh` commands fail with "Resource not accessible by personal access token".

**Solution:**
1. Go to: https://github.com/settings/tokens
2. Click **"Configure SSO"** next to your token
3. Click **"Authorize"** for your organization

### SSH Key Already in Use

**Problem:** "Key is already in use" when adding to GitHub.

**Solution:** That public key is used by another GitHub account. Generate a new key:
```bash
ssh-keygen -t ed25519 -C "your@email.com" -f ~/.ssh/id_ed25519_work
```

Then add to SSH config:
```bash
cat >> ~/.ssh/config << 'EOF'
Host github.com-work
  HostName github.com
  User git
  IdentityFile ~/.ssh/id_ed25519_work
EOF

# Use in git:
git clone git@github.com-work:company/repo.git
```

---

## Security Best Practices

1. **Use SSH keys with passphrases** - Adds extra security layer
2. **Never share your private key** (`~/.ssh/id_ed25519`) - Only share public key (`.pub`)
3. **Set token expiration** - Personal Access Tokens should expire (90 days recommended)
4. **Use different keys for different machines** - Makes it easy to revoke access
5. **Enable 2FA on GitHub** - Protects your account from unauthorized access

---

## Already Set Up?

To verify your GitHub integration is working:

```bash
# Test SSH
ssh -T git@github.com

# Test GitHub CLI
gh auth status

# Test Git
git config --global user.name
git config --global user.email

# Clone a test repo
gh repo clone octocat/Hello-World
cd Hello-World
```

✅ If all commands work, you're all set!

---

## Next Steps

After setting up GitHub:

1. **Clone your repositories**
   ```bash
   mkdir -p ~/projects
   cd ~/projects
   gh repo clone yourusername/your-repo
   ```

2. **Set up GPG signing** (optional but recommended)
   - Guide: https://docs.github.com/en/authentication/managing-commit-signature-verification

3. **Configure git aliases** (already in zshrc):
   ```bash
   lg    # lazygit (visual git UI)
   ```

4. **Start developing with Claude Code!**
   ```bash
   cd ~/projects/your-repo
   claude "help me understand this codebase"
   ```
