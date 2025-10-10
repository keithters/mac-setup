#!/bin/bash

# Ansible Mac Setup - Manual Configuration Backup Script
# This script creates a backup of your current configuration

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

# Create backup directory
BACKUP_DIR="$HOME/.config-backups/manual-backup-$(date +%s)"
mkdir -p "$BACKUP_DIR"

print_status "Creating manual backup at: $BACKUP_DIR"

# Backup shell configuration files
print_status "Backing up shell configuration files..."

if [ -f "$HOME/.zshrc" ]; then
    cp "$HOME/.zshrc" "$BACKUP_DIR/.zshrc.original"
    print_success "Backed up .zshrc"
fi

if [ -f "$HOME/.zprofile" ]; then
    cp "$HOME/.zprofile" "$BACKUP_DIR/.zprofile.original"
    print_success "Backed up .zprofile"
fi

if [ -f "$HOME/.p10k.zsh" ]; then
    cp "$HOME/.p10k.zsh" "$BACKUP_DIR/.p10k.zsh.original"
    print_success "Backed up .p10k.zsh"
fi

# Backup Neovim configuration
if [ -d "$HOME/.config/nvim" ]; then
    print_status "Backing up Neovim configuration..."
    cp -r "$HOME/.config/nvim" "$BACKUP_DIR/nvim.original"
    print_success "Backed up Neovim configuration"
fi

# Backup iTerm2 preferences
print_status "Backing up iTerm2 preferences..."
defaults export com.googlecode.iterm2 "$BACKUP_DIR/iterm2-defaults.plist" 2>/dev/null || print_status "iTerm2 not configured or not installed"

# Backup Ghostty configuration
if [ -d "$HOME/.config/ghostty" ]; then
    print_status "Backing up Ghostty configuration..."
    cp -r "$HOME/.config/ghostty" "$BACKUP_DIR/ghostty.original"
    print_success "Backed up Ghostty configuration"
fi

# Create backup info file
cat > "$BACKUP_DIR/backup-info.txt" << EOF
Ansible Mac Setup - Manual Configuration Backup
================================================
Created: $(date -Iseconds)
Backup Directory: $BACKUP_DIR

Original files backed up:
- .zshrc.original
- .zprofile.original  
- .p10k.zsh.original
- nvim.original/
- iterm2-defaults.plist
- ghostty.original/

To restore this backup, run:
./restore-config.sh

Or restore manually:
1. Copy backup files back to home directory:
   cp $BACKUP_DIR/.zshrc.original ~/.zshrc
   cp $BACKUP_DIR/.zprofile.original ~/.zprofile
   cp $BACKUP_DIR/.p10k.zsh.original ~/.p10k.zsh
   rm -rf ~/.config/nvim && cp -r $BACKUP_DIR/nvim.original ~/.config/nvim

2. Restore iTerm2 preferences:
   defaults import com.googlecode.iterm2 $BACKUP_DIR/iterm2-defaults.plist

3. Restore Ghostty configuration:
   rm -rf ~/.config/ghostty && cp -r $BACKUP_DIR/ghostty.original ~/.config/ghostty

4. Remove Oh My Zsh installation (if needed):
   rm -rf ~/.oh-my-zsh

5. Restart terminal applications
EOF

print_success "Manual backup completed successfully!"
print_status "Backup location: $BACKUP_DIR"
print_status "Use ./restore-config.sh to restore from this backup"