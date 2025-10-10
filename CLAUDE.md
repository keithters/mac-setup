# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Architecture

This is an Ansible-based Mac setup automation tool that configures a new Mac with applications, system preferences, shell environment, and Dock layout. The playbook is structured around modular task files that can be run independently using tags.

### Core Structure
- `playbook.yml` - Main Ansible playbook that orchestrates all tasks
- `run.sh` - Convenience script that handles prerequisites and provides selective execution options
- `check-diff.sh` - Analysis tool that compares current system state with target configuration
- `tasks/` - Modular task files organized by functionality:
  - `homebrew.yml` - Package installation (formulae and casks)
  - `system_preferences.yml` - macOS defaults and system settings
  - `dock.yml` - Dock application configuration
  - `shell_environment.yml` - Oh My Zsh, Powerlevel10k, aliases, and shell setup
  - `fonts_and_terminals.yml` - Font installation and terminal configuration (iTerm2, Ghostty)
  - `additional_cli_tools.yml` - Additional CLI tools (Docker, kubectl, Python tools)
  - `applications.yml` - Application verification tasks

### Execution Flow
1. `run.sh` automatically installs prerequisites (Homebrew, Python, Ansible, collections)
2. Ansible playbook executes task files based on selected tags
3. Each task file is idempotent and can be run independently
4. System services (Dock, Finder) are restarted as needed

## Common Commands

### Core Operations
```bash
# See what changes would be made (recommended first step)
./check-diff.sh

# Run complete setup
./run.sh

# Run with specific components only
./run.sh --homebrew    # Install packages only
./run.sh --system      # Configure system preferences only  
./run.sh --shell       # Configure shell environment only
./run.sh --fonts       # Install fonts and configure terminals
./run.sh --cli         # Install additional CLI tools
./run.sh --dock        # Configure Dock only
```

### Direct Ansible Execution
```bash
# Run specific tags directly
ansible-playbook playbook.yml --tags "homebrew,apps"
ansible-playbook playbook.yml --tags "system,preferences" 
ansible-playbook playbook.yml --tags "shell,environment"

# Check syntax
ansible-playbook --syntax-check playbook.yml

# Dry run to see changes
ansible-playbook playbook.yml --check --diff
```

### Backup and Restore
```bash
# Create manual backup of current configuration
./backup-config.sh

# Restore from a previous backup (interactive)
./restore-config.sh
```

### Development & Testing
```bash
# Validate playbook syntax
ansible-playbook --syntax-check playbook.yml

# Debug with verbose output
ansible-playbook playbook.yml -v

# Check current vs target package state
comm -23 <(grep -A 50 "Install Homebrew formulae" tasks/homebrew.yml | grep "    - " | sed 's/.*- //' | sort) <(brew list --formula | sort)
```

## Customization

### Adding Applications
Edit `tasks/homebrew.yml` and add to the appropriate loop section (formulae for CLI tools, casks for GUI apps).

### Modifying System Preferences  
Edit `tasks/system_preferences.yml` following the pattern:
```yaml
- name: Description
  community.general.osx_defaults:
    domain: com.apple.example
    key: PreferenceKey
    type: bool
    value: true
```

### Customizing Dock Layout
Edit `tasks/dock.yml` and modify the dock_items list with applications in desired order.

### Shell Configuration
Edit `tasks/shell_environment.yml` to modify aliases, environment variables, or zsh configuration.