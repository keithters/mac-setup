# Portable Zsh Plugins Installer

A standalone shell script for installing popular zsh plugins with or without Oh My Zsh. No Ansible or other dependencies required - just bash, git, curl, and zsh.

**All plugins work in both modes!** You can choose to install with Oh My Zsh (recommended for beginners) or standalone (for advanced users who prefer minimal setup).

## What It Installs

### Oh My Zsh (Optional)
A delightful framework for managing your zsh configuration. Provides hundreds of plugins, themes, and helpful functions. **Optional** - all plugins work with or without it. Recommended for beginners.

### Powerlevel10k (Optional)
A fast and flexible zsh theme with rich customization options. Provides a beautiful, informative prompt with git status, command duration, and much more. Includes an interactive configuration wizard.

### zsh-autosuggestions (Optional)
Suggests commands as you type based on your command history. Press → (right arrow) to accept a suggestion. Makes command line navigation faster and more efficient.

### zsh-syntax-highlighting (Optional)
Provides Fish-like syntax highlighting for your zsh commands. Highlights valid commands in green, invalid in red, and colorizes strings, paths, and other syntax elements as you type.

### you-should-use (Optional)
Reminds you to use existing aliases when you type the full command. Helps you learn and remember your configured aliases and save time. Example: Typing 'git status' reminds you about your 'gst' alias.

### MesloLGS Nerd Font (Optional)
The official Nerd Font recommended for Powerlevel10k. Includes all glyphs and icons needed for the best prompt experience. Highly recommended if you installed Powerlevel10k. Automatically installs to:
- **macOS**: `~/Library/Fonts/`
- **Linux**: `~/.local/share/fonts/`

## Usage

```bash
# Make executable (first time only)
chmod +x install-zsh-plugins.sh

# Run the installer
./install-zsh-plugins.sh
```

The script will:
1. Check that prerequisites (zsh, git, curl) are installed
2. Prompt you for each component with a description
3. Install only the components you select
4. Automatically configure your `.zshrc` file
5. Create backups of existing configurations

## Interactive Prompts

For each component, you'll see:
- A clear description of what it does
- A yes/no prompt (default is yes)
- Progress messages during installation

Example:
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Powerlevel10k
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
A fast and flexible zsh theme with rich customization options.
Provides a beautiful, informative prompt with git status, command duration,
and much more. Includes an interactive configuration wizard.

Install Powerlevel10k? (Y/n):
```

## Installation Modes

### Oh My Zsh Mode (Recommended for beginners)
When you choose to install Oh My Zsh:
- Plugins install to `~/.oh-my-zsh/custom/plugins/`
- Theme installs to `~/.oh-my-zsh/custom/themes/`
- Configuration uses Oh My Zsh's plugin system
- Easy to manage hundreds of community plugins

### Standalone Mode (Minimal setup)
When you skip Oh My Zsh:
- Plugins install to `~/.zsh/`
- Theme installs to `~/.powerlevel10k/`
- Configuration uses direct `source` commands
- Lightweight and fast with no extra framework

**Both modes work identically from the user's perspective!**

## Safety Features

- **Backups**: Automatically backs up `.zshrc` before making changes
- **Update handling**: If plugins already exist, offers to update them
- **Merge logic** (Oh My Zsh mode): Merges new plugins with existing ones (doesn't replace)
- **Block replacement** (Standalone mode): Updates configuration block cleanly
- **Non-destructive**: Safe to run multiple times

## After Installation

1. Restart your terminal or run: `source ~/.zshrc`
2. If you installed Powerlevel10k, it will prompt you to configure on first launch
3. If you installed MesloLGS Nerd Font, configure your terminal to use it:
   - **Terminal.app**: Preferences → Profiles → Font → MesloLGS NF
   - **iTerm2**: Preferences → Profiles → Text → Font → MesloLGS NF
   - **VS Code**: Settings → Terminal Font Family → `'MesloLGS NF'`
   - **Ghostty**: Add to config: `font-family = MesloLGS Nerd Font`

## Portability

This script is completely portable! You can:
- Copy it to any Unix-like system (macOS, Linux)
- Run it without root/sudo
- Use it on fresh systems or existing setups
- Share it with others without dependencies
- Choose Oh My Zsh or standalone mode on any system

The only requirements are:
- zsh (must be installed)
- git (for cloning repos)
- curl (for downloading Oh My Zsh, if you choose that mode)

## Customization

After installation, you can further customize your setup by:
- Running `p10k configure` to reconfigure Powerlevel10k
- Editing `~/.zshrc` to add more plugins or aliases
- Exploring Oh My Zsh plugins: https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins
