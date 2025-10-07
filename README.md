# Mac Setup with Ansible

This Ansible playbook automates the setup of a new Mac with the same configuration as your current system, including applications, system preferences, Dock configuration, and command-line tools.

## Prerequisites

**None!** The `run.sh` script will automatically install everything needed:
- Homebrew (if not already installed)
- Python (if not already installed) 
- Ansible (via Homebrew)
- Required Ansible collections

Just run the script and it will handle the setup for you.

## Usage

### Claude Slash Commands (Recommended)
This project includes helpful Claude slash commands for easy workflow management. Use these commands in Claude:

**Essential Commands:**
- `/check-diff` - See what changes would be made
- `/run-setup` - Run the complete setup
- `/install-apps` - Install only Homebrew packages
- `/setup-terminals` - Configure iTerm2 & Ghostty
- `/config-system` - Configure system preferences

**Advanced Commands:**
- `/validate-playbook` - Check syntax and validate configuration
- `/monitor-changes` - Monitor system changes during execution
- `/health-check` - Comprehensive system health check after setup

See `.claude_commands` and `.claude_commands_advanced` for the complete list.

### Manual Execution

#### Check What Would Change (Recommended First Step)
Before running the playbook, see what changes would be made:
```bash
./run.sh --diff
```

### Full Setup
Run the complete setup with all configurations:
```bash
./run.sh
```

### Selective Installation
Use tags to run specific parts of the setup:

- Install only Homebrew packages and applications:
  ```bash
  ansible-playbook playbook.yml --tags "homebrew,apps"
  ```

- Configure only system preferences:
  ```bash
  ansible-playbook playbook.yml --tags "system,preferences"
  ```

- Set up only Dock configuration:
  ```bash
  ansible-playbook playbook.yml --tags "dock"
  ```

- Configure only shell environment:
  ```bash
  ansible-playbook playbook.yml --tags "shell,environment"
  ```

- Install only additional CLI tools:
  ```bash
  ansible-playbook playbook.yml --tags "cli,tools,additional"
  ```

- Install fonts and configure iTerm2:
  ```bash
  ansible-playbook playbook.yml --tags "fonts,iterm,terminal"
  ```

## What Gets Installed/Configured

### Applications (via Homebrew)
- **Browsers**: Brave, Firefox, Google Chrome
- **Development**: Visual Studio Code, Cursor, iTerm2, Ghostty, Docker Desktop, TablePlus, Tower
- **Communication**: Slack, WhatsApp, Zoom, Microsoft Teams
- **Productivity**: 1Password, Obsidian, Linear, ChatGPT, Claude, Figma
- **Media**: Spotify, Google Drive

### Command Line Tools
- **Cloud & Infrastructure**: AWS CLI, Pulumi, Docker, kubectl
- **Development**: GitHub CLI, Node.js (via fnm), Python, UV, Pipenv, Pipx
- **Code Quality**: Ruff (Python linter/formatter), Black, MyPy
- **Container Support**: Colima, Lima, Docker Compose
- **AI/ML Tools**: Ollama, LLM
- **System Utilities**: coreutils, tree-sitter, emacs
- **Editor Integration**: CLI tools for VS Code and Cursor

### System Preferences
- **Finder**: Show hidden files, path bar, status bar, list view, home folder as default, disable extension warnings, show POSIX path in title
- **Desktop**: Show external drives, hide internal drives, show servers and removable media, require password immediately after screensaver
- **Dock**: Auto-hide disabled, 48px tiles, minimize to app, hide recent apps, no magnification, genie minimize effect
- **Trackpad**: Tap to click, three-finger drag enabled
- **Keyboard**: Fast key repeat, disable auto-correct/capitalization/period substitution
- **UI/Performance**: Faster animations, expanded save/print dialogs, scroll bars when scrolling
- **Menu Bar**: Show battery percentage, detailed clock format
- **Screenshots**: PNG format, saved to Desktop
- **Safari**: Developer menu, favorites bar, web inspector enabled
- **Activity Monitor**: CPU usage sorting, Dock icon shows CPU usage

### Shell Environment
- Oh My Zsh with Powerlevel10k theme
- Custom aliases and functions (including `n()` for nnn file manager)
- Node.js version management with fnm
- pnpm package manager configuration

### Terminal & Fonts
- **iTerm2 Configuration**: Font, colors, and behavior settings
- **Ghostty Configuration**: Modern terminal with same MesloLGS Nerd Font, optimized settings
- **MesloLGS Nerd Font**: Powerline-compatible font (size 13) for both terminals
- **nnn File Manager**: Configured with plugins and custom settings

### Dock Configuration
Recreates your current Dock layout with all applications in the same order.

## Customization

### Adding Applications
Edit `tasks/homebrew.yml` to add more Homebrew formulae or casks:
```yaml
- name: Install additional cask
  homebrew_cask:
    name: your-app-name
    state: present
```

### Modifying System Preferences
Edit `tasks/system_preferences.yml` to add or modify macOS defaults:
```yaml
- { domain: "com.example.app", key: "PreferenceName", type: "bool", value: true }
```

### Customizing Dock
Edit `tasks/dock.yml` to change the applications or their order in the Dock.

### Shell Customization
Edit `tasks/shell_environment.yml` to modify zsh configuration, aliases, or environment variables.

## Files Structure

```
ansible-mac/
|-- .claude_commands             # Claude slash commands for easy workflow
|-- .claude_commands_advanced    # Advanced Claude commands for power users
|-- ansible.cfg                  # Ansible configuration
|-- check-diff.sh                # Diff tool (show changes)
|-- inventory.yml                # Host inventory (localhost)
|-- playbook.yml                 # Main playbook
|-- README.md                    # This file
|-- run.sh                       # Convenient execution script
`-- tasks/
    |-- additional_cli_tools.yml  # Additional CLI tools
    |-- applications.yml          # Application verification
    |-- dock.yml                  # Dock configuration
    |-- fonts_and_terminals.yml   # Font and terminal setup (iTerm2 & Ghostty)
    |-- homebrew.yml              # Package installation
    |-- shell_environment.yml     # Shell and terminal setup
    `-- system_preferences.yml    # macOS system settings
```

## Troubleshooting

### Permission Issues
Some system preferences changes may require elevated permissions. Run with sudo if needed:
```bash
sudo ansible-playbook playbook.yml
```

### Homebrew Installation
If Homebrew isn't installed, the playbook will install it automatically.

### Application Not Installing
Check if the cask name is correct by searching:
```bash
brew search app-name
```

### Dock Changes Not Applied
The Dock is automatically restarted, but you may need to manually restart it:
```bash
killall Dock
```

## Security Notes

- API keys and sensitive information in shell configuration files are excluded from this automation
- You'll need to manually configure application-specific settings and login credentials
- Consider creating a separate private repository for sensitive configurations

## License

This configuration is provided as-is for personal use.