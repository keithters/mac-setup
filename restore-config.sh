#!/bin/bash

# Ansible Mac Setup - Configuration Restore Script
# This script restores your original configuration from a backup

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored messages
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Find backup directories
BACKUP_BASE="$HOME/.config-backups"

if [ ! -d "$BACKUP_BASE" ]; then
    print_error "No backup directory found at $BACKUP_BASE"
    print_error "Make sure you've run the Ansible playbook at least once to create backups"
    exit 1
fi

# List available backups
print_status "Available backups:"
backups=($(find "$BACKUP_BASE" -name "ansible-mac-*" -type d | sort -r))

if [ ${#backups[@]} -eq 0 ]; then
    print_error "No Ansible Mac backups found in $BACKUP_BASE"
    exit 1
fi

# Show numbered list of backups
for i in "${!backups[@]}"; do
    backup_dir="${backups[$i]}"
    if [ -f "$backup_dir/backup-info.txt" ]; then
        creation_date=$(grep "Created:" "$backup_dir/backup-info.txt" | cut -d' ' -f2-)
        echo "$((i+1)). $(basename "$backup_dir") - Created: $creation_date"
    else
        echo "$((i+1)). $(basename "$backup_dir")"
    fi
done

# Get user selection
echo ""
read -p "Select backup to restore (1-${#backups[@]}): " selection

# Validate selection
if ! [[ "$selection" =~ ^[0-9]+$ ]] || [ "$selection" -lt 1 ] || [ "$selection" -gt ${#backups[@]} ]; then
    print_error "Invalid selection"
    exit 1
fi

BACKUP_DIR="${backups[$((selection-1))]}"
print_status "Selected backup: $BACKUP_DIR"

# Confirm restoration
echo ""
print_warning "This will restore your configuration from the selected backup."
print_warning "Current configuration will be OVERWRITTEN!"
echo ""
read -p "Are you sure you want to continue? (y/N): " confirm

if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    print_status "Restoration cancelled"
    exit 0
fi

print_status "Starting configuration restoration..."

# Restore shell configuration files
if [ -f "$BACKUP_DIR/.zshrc.original" ]; then
    print_status "Restoring .zshrc..."
    cp "$BACKUP_DIR/.zshrc.original" "$HOME/.zshrc"
    print_success "Restored .zshrc"
else
    print_warning ".zshrc backup not found, skipping"
fi

if [ -f "$BACKUP_DIR/.zprofile.original" ]; then
    print_status "Restoring .zprofile..."
    cp "$BACKUP_DIR/.zprofile.original" "$HOME/.zprofile"
    print_success "Restored .zprofile"
else
    print_warning ".zprofile backup not found, skipping"
fi

if [ -f "$BACKUP_DIR/.p10k.zsh.original" ]; then
    print_status "Restoring .p10k.zsh..."
    cp "$BACKUP_DIR/.p10k.zsh.original" "$HOME/.p10k.zsh"
    print_success "Restored .p10k.zsh"
else
    print_warning ".p10k.zsh backup not found, skipping"
fi

# Restore Neovim configuration
if [ -d "$BACKUP_DIR/nvim.original" ]; then
    print_status "Restoring Neovim configuration..."
    rm -rf "$HOME/.config/nvim"
    cp -r "$BACKUP_DIR/nvim.original" "$HOME/.config/nvim"
    print_success "Restored Neovim configuration"
else
    print_warning "Neovim backup not found, skipping"
fi

# Restore iTerm2 preferences
if [ -f "$BACKUP_DIR/iterm2-defaults.plist" ]; then
    print_status "Restoring iTerm2 preferences..."
    defaults import com.googlecode.iterm2 "$BACKUP_DIR/iterm2-defaults.plist"
    print_success "Restored iTerm2 preferences"
else
    print_warning "iTerm2 backup not found, skipping"
fi

# Restore Ghostty configuration
if [ -d "$BACKUP_DIR/ghostty.original" ]; then
    print_status "Restoring Ghostty configuration..."
    rm -rf "$HOME/.config/ghostty"
    cp -r "$BACKUP_DIR/ghostty.original" "$HOME/.config/ghostty"
    print_success "Restored Ghostty configuration"
else
    print_warning "Ghostty backup not found, skipping"
fi

# Restore system preferences
if [ -d "$BACKUP_DIR/system-defaults" ]; then
    print_status "Restoring system preferences..."
    
    # Restore individual preference domains
    for plist in "$BACKUP_DIR/system-defaults"/*.plist; do
        if [ -f "$plist" ]; then
            domain=$(basename "$plist" .plist)
            if [ "$domain" != "NSGlobalDomain-backup" ]; then
                print_status "Restoring $domain preferences..."
                defaults import "com.apple.$domain" "$plist" 2>/dev/null || true
            fi
        fi
    done
    
    print_success "Restored system preferences"
    print_warning "Note: Some NSGlobalDomain settings may require manual restoration"
else
    print_warning "System preferences backup not found, skipping"
fi

# Restore dock configuration (partial - shows what was there before)
if [ -f "$BACKUP_DIR/dock-layout-backup.txt" ]; then
    print_status "Dock configuration backup found at $BACKUP_DIR/dock-layout-backup.txt"
    print_warning "Dock restore requires manual intervention. Your original dock layout is saved in the backup file."
    print_status "To restore dock manually:"
    print_status "1. Clear current dock: dockutil --remove all"
    print_status "2. Review your original layout: cat $BACKUP_DIR/dock-layout-backup.txt"
    print_status "3. Add apps back manually or use dockutil --add commands"
else
    print_warning "Dock backup not found, skipping"
fi

# Optional: Remove Oh My Zsh installation
echo ""
read -p "Do you want to remove Oh My Zsh installation? (y/N): " remove_omz

if [[ "$remove_omz" =~ ^[Yy]$ ]]; then
    print_status "Removing Oh My Zsh..."
    rm -rf "$HOME/.oh-my-zsh"
    print_success "Removed Oh My Zsh"
fi

# Restart terminal applications
print_status "Restarting terminal applications..."
pkill -f iTerm2 || true
pkill -f ghostty || true

print_success "Configuration restoration completed!"
print_status "Please restart your terminal to see the changes."

# Show restore summary
echo ""
print_status "Restoration Summary:"
echo "- Backup used: $(basename "$BACKUP_DIR")"
echo "- Files restored: .zshrc, .zprofile, .p10k.zsh, nvim config"
echo "- Terminal preferences: iTerm2, Ghostty"
if [[ "$remove_omz" =~ ^[Yy]$ ]]; then
    echo "- Oh My Zsh: Removed"
else
    echo "- Oh My Zsh: Kept (you can manually remove ~/.oh-my-zsh if needed)"
fi