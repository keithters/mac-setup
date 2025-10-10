# backup-config

Creates a manual backup of your current Mac configuration before running any setup changes.

## What this does:
- Creates a timestamped backup in ~/.config-backups/
- Backs up shell configuration (.zshrc, .zprofile, .p10k.zsh)  
- Backs up Neovim configuration
- Backs up terminal preferences (iTerm2, Ghostty)
- Backs up system preferences (Finder, Dock, etc.)
- Backs up current Dock layout as reference
- Creates detailed restoration instructions

## Usage:
Simply run `/backup-config` to create a backup of your current configuration.

This is useful before:
- Running the main setup for the first time
- Making manual configuration changes
- Testing new settings

The backup can later be restored using `/restore-config`.