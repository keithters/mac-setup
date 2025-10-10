# restore-config

Interactively restore your Mac configuration from a previous backup.

## What this does:
- Lists all available backups with creation dates
- Allows you to select which backup to restore from
- Restores shell configuration files (.zshrc, .zprofile, .p10k.zsh)
- Restores Neovim configuration  
- Restores terminal preferences (iTerm2, Ghostty)
- Restores most system preferences (Finder, Dock settings, etc.)
- Provides dock restoration guidance (manual process)
- Optionally removes Oh My Zsh installation
- Restarts affected applications

## What gets restored:
- ✅ **Shell & Terminal Settings**: Fully restored
- ✅ **Neovim Configuration**: Fully restored  
- ✅ **System Preferences**: Mostly restored (some may need manual work)
- ⚠️ **Dock Layout**: Reference provided, manual restoration required
- ❌ **Installed Applications**: Remain installed (not removed)

## Usage:
Run `/restore-config` and follow the interactive prompts to:
1. Select which backup to restore from
2. Choose restoration options
3. Optionally remove Oh My Zsh

## Notes:
- Installed Homebrew packages and applications will NOT be removed
- Your dock will need to be manually restored using the backup reference
- Some system-wide settings may require manual restoration