---
description: Explain what this Mac automation does and how it works
---

**📖 Mac Setup Automation Explained**

This is an Ansible-based automation that transforms a fresh Mac into a fully configured development environment. Here's how it works:

## What It Does
- **🍺 Package Management**: Installs Homebrew and 50+ development tools
- **⚙️ System Configuration**: Sets macOS preferences for productivity 
- **🐚 Shell Environment**: Configures Zsh with Oh My Zsh + Powerlevel10k theme
- **📝 Editor Setup**: Installs Neovim with modern plugin configuration
- **🎯 Dock Management**: Organizes applications in your Dock
- **🔧 Terminal Config**: Sets up iTerm2 and Ghostty with fonts
- **📦 Node.js Management**: Uses fnm instead of Homebrew for Node.js

## How It Works
- **Ansible Playbook**: Uses Infrastructure as Code approach
- **Idempotent**: Safe to run multiple times - only makes needed changes
- **Modular**: Each component can be run independently via tags
- **Portable**: Works on any Mac, no hardcoded user paths

## Files Structure
```
├── playbook.yml          # Main Ansible orchestration
├── run.sh               # Convenience script with prerequisites  
├── check-diff.sh        # Preview changes before applying
├── tasks/               # Modular task files
│   ├── homebrew.yml     # Package installation
│   ├── system_preferences.yml  # macOS settings
│   ├── shell_environment.yml   # Zsh + Neovim setup
│   ├── dock.yml         # Dock configuration
│   └── ...
└── .claude/commands/    # Claude Code slash commands
```

## Available Commands
- `/check-diff` - Preview what changes would be made
- `/run-all` - Complete setup (recommended)  
- `/run-homebrew` - Install packages only
- `/run-shell` - Configure shell environment only
- `/run-system` - Set system preferences only
- And more selective options...

💡 **Getting Started**: Run `/check-diff` first to see what would change on your system!