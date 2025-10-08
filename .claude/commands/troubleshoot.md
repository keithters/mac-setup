---
description: Troubleshoot common issues with the Mac setup automation
---

**🔧 Troubleshooting Guide**

Having issues with the Mac setup? Here are common solutions:

## Check Prerequisites
First, ensure all prerequisites are installed:

!./run.sh --help

## Common Issues & Solutions

### 🔍 **Issue**: "Command not found" errors
```bash
# Check if Homebrew is in PATH
echo $PATH | grep -q "/opt/homebrew/bin" && echo "✅ Homebrew in PATH" || echo "❌ Missing Homebrew PATH"

# Fix: Add to shell profile
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
source ~/.zprofile
```

### 🐚 **Issue**: Shell changes not taking effect
```bash
# Reload shell configuration
source ~/.zshrc

# Check if Oh My Zsh is installed
ls -la ~/.oh-my-zsh && echo "✅ Oh My Zsh installed" || echo "❌ Oh My Zsh missing"
```

### 📦 **Issue**: Node.js conflicts between fnm and Homebrew
```bash
# Check current Node.js source
which node
node --version

# Should show fnm path like: /Users/username/.local/share/fnm/node-versions/...
# If shows /opt/homebrew/bin/node, run: brew uninstall node
```

### 🎯 **Issue**: Dock not updating correctly
```bash
# Check if dockutil is installed
brew list dockutil && echo "✅ dockutil installed" || echo "❌ Install with: brew install dockutil"

# Reset Dock if corrupted
defaults delete com.apple.dock && killall Dock
```

## Debug Commands
```bash
# Check Ansible syntax
ansible-playbook --syntax-check playbook.yml

# Run with verbose output
ansible-playbook playbook.yml -v

# Test specific component
ansible-playbook playbook.yml --tags "shell" --check --diff
```

## Get Help
- Check logs for error details
- Run `/check-diff` to see current system state  
- Try running individual components with `--tags`

💡 **Still stuck?** Try running the problematic component individually (e.g., `/run-shell`, `/run-homebrew`) to isolate the issue.