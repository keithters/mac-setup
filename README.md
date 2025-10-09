# Mac Setup with Ansible + Claude Code

This Ansible playbook automates the setup of a Mac (fresh or existing) with a development environment, including applications, system preferences, Dock layout, and command-line tools. It will not uninstall anything, but will change your Dock layout and system preferences unless customized. See [what gets installed](#what-gets-installedconfigured) for the complete list, or [learn how to customize](#manual-clone-and-customization) with Claude Code.

## Quick Installation

Get started in seconds with these one-line commands. No need to clone the repository first.

### See What Would Change First (Recommended)
```bash
# Just see what would change (dry run)
curl -fsSL https://raw.githubusercontent.com/keithters/mac-setup/main/install.sh | bash -s -- --check-diff
```

### One-Line Setup Options
```bash
# Install prerequisites only
curl -fsSL https://raw.githubusercontent.com/keithters/mac-setup/main/install.sh | bash -s -- --prerequisites

# Full automated setup (clone + install everything)
curl -fsSL https://raw.githubusercontent.com/keithters/mac-setup/main/install.sh | bash -s -- --full
```

## Manual Clone and Customization

### Clone the Repository
```bash
git clone https://github.com/keithters/mac-setup.git
cd mac-setup
```

### Claude Code Slash Commands (For Customization)

If you're using **Claude Code**, this project includes convenient slash commands for easy workflow management. Simply type these commands in Claude to execute different parts of the setup:

#### Essential Commands
- `/setup-prerequisites` - Install only prerequisites (Homebrew, Ansible, collections)
- `/check-diff` - Analyze system state and show what changes would be made 
- `/customize` - Learn how to ask Claude to customize your Mac setup
- `/run-all` - Run the complete Mac setup with all components
- `/security-review` - Review recent changes for security issues

#### Selective Setup Commands
- `/run-homebrew` - Install Homebrew packages only
- `/run-system` - Configure macOS system preferences only  
- `/run-shell` - Configure shell environment only
- `/run-fonts` - Install fonts and configure terminals
- `/run-cli` - Install additional CLI tools
- `/run-dock` - Configure Dock layout only

These slash commands provide a streamlined way to manage your Mac setup directly through Claude Code, with progress tracking and detailed output.


## What Gets Installed/Configured

### Applications (via Homebrew)
- **Browsers**: Brave, Firefox, Google Chrome
- **Development**: Visual Studio Code, Cursor, iTerm2, Ghostty, Docker Desktop, TablePlus, Tower
- **Communication**: Slack, WhatsApp, Zoom, Microsoft Teams
- **Productivity**: 1Password, 1Password CLI, Obsidian, Linear, ChatGPT, Claude, Figma
- **Media**: Spotify, Google Drive

### Command Line Tools
- **Cloud & Infrastructure**: AWS CLI, Terraform, Pulumi, kubectl
- **Development**: GitHub CLI, Node.js (via fnm), Python, UV, Pipenv, Pipx
- **Package Management**: pnpm (with `pn` alias for quick access)
- **Code Quality**: Ruff (Python linter/formatter)
- **Container Support**: Colima, Lima
- **AI/ML Tools**: Ollama, LLM
- **System Utilities**: coreutils, tree-sitter, emacs, nnn file manager, bpytop (system monitor), glow (markdown renderer), autoenv (directory-based environments)
- **Editor Integration**: CLI tools for VS Code and Cursor

### System Preferences
- **Finder**: Show hidden files, path bar, status bar, list view, home folder as default, disable extension warnings, show POSIX path in title
- **Desktop**: Show external drives, hide internal drives, show servers and removable media, require password immediately after screensaver
- **Dock**: Auto-hide disabled, 48px tiles, minimize to app, hide recent apps, no magnification, genie minimize effect, positioned at bottom
- **Trackpad**: Tap to click, three-finger drag enabled
- **Keyboard**: Fast key repeat, disable auto-correct/capitalization/period substitution
- **UI/Performance**: Faster animations, expanded save/print dialogs, scroll bars when scrolling
- **Menu Bar**: Show battery percentage, detailed clock format
- **Screenshots**: PNG format, saved to Desktop
- **Activity Monitor**: CPU usage sorting, Dock icon shows CPU usage

### Shell Environment
- **Oh My Zsh**: Framework for managing zsh configuration
- **Powerlevel10k**: Fast, feature-rich zsh theme with customizable prompt
- **Zsh Plugins**:
  - `git` - Git aliases and status integration
  - `aws` - AWS CLI completion and shortcuts
  - `fnm` - Fast Node Manager integration and completions
  - `gh` - GitHub CLI completion and shortcuts
  - `zsh-autosuggestions` - Fish-like command suggestions based on history
  - `zsh-syntax-highlighting` - Real-time syntax highlighting for commands
  - `autoenv` - Automatic environment variable loading per directory
  - `1password` - 1Password CLI integration and `opswd` command for copying passwords
- **Custom aliases**: `python` → `python3`, `pn` → `pnpm`, `pnx` → `pnpm dlx`
- **Custom functions**: `n()` for nnn file manager with cd-on-quit
- **Package managers**: fnm for Node.js versions, pnpm for packages

### Terminal & Fonts
- **iTerm2 Configuration**: Font, colors, and behavior settings
- **Ghostty Configuration**: Modern terminal with same MesloLGS Nerd Font, optimized settings
- **MesloLGS Nerd Font**: Powerline-compatible font (size 13) for both terminals
- **Neovim**: Configuration with modern plugins, aliased as `vim`
- **nnn File Manager**: Configured with plugins and custom settings

### Dock Configuration
Recreates a clean Dock layout with all your essential applications in a logical order, plus Downloads folder with list view, using `dockutil` for reliable configuration.

## Customization

### Easy Customization with Claude (Recommended)
If you're using **Claude Code**, simply run `/customize` to see examples of how to ask Claude to modify your setup in plain English. No need to edit YAML files manually!

Examples:
- *"Can you add Discord to the dock?"*
- *"I want all browsers at the top of the dock"*
- *"Can you remove Spotify from the setup?"*

### Manual Customization

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

## Files Structure

```
ansible-mac/
|-- .claude/
|   `-- commands/                 # Claude Code slash commands
|-- ansible.cfg                   # Ansible configuration
|-- check-diff.sh                 # Analysis tool (show changes)  
|-- files/
|   `-- p10k.zsh                  # Powerlevel10k configuration
|-- inventory.yml                 # Host inventory (localhost)
|-- playbook.yml                  # Main playbook
|-- README.md                     # This file
|-- run.sh                        # Convenient execution script
`-- tasks/
    |-- additional_cli_tools.yml  # Additional CLI tools
    |-- applications.yml          # Application verification
    |-- dock.yml                  # Dock configuration (using dockutil)
    |-- fonts_and_terminals.yml   # Font and terminal setup (iTerm2 & Ghostty)
    |-- homebrew.yml              # Package installation
    |-- shell_environment.yml     # Shell and terminal setup
    `-- system_preferences.yml    # macOS system settings
```

## Development & Testing

### Validation
```bash
# Validate playbook syntax
ansible-playbook --syntax-check playbook.yml

# Debug with verbose output
ansible-playbook playbook.yml -v

# Check current vs target package state
comm -23 <(grep -A 50 "Install Homebrew formulae" tasks/homebrew.yml | grep "    - " | sed 's/.*- //' | sort) <(brew list --formula | sort)
```

## Troubleshooting

### Permission Issues
Some system preferences changes may require elevated permissions. The playbook uses `community.general.osx_defaults` which should handle most cases correctly.

### Homebrew Installation
If Homebrew isn't installed, the playbook will install it automatically.

### Application Not Installing
Check if the cask name is correct by searching:
```bash
brew search app-name
```

### Dock Changes Not Applied
The setup uses `dockutil` for reliable Dock management. If issues persist:
```bash
brew install dockutil
dockutil --remove all
# Then re-run /run-dock or ./run.sh --dock
```

## Security Notes

- Safari preferences are disabled due to macOS sandboxing restrictions
- API keys and sensitive information in shell configuration files are excluded from this automation
- You'll need to manually configure application-specific settings and login credentials
- The `/security-review` command helps identify potential security issues in recent changes

## Manual Execution

For users who prefer command-line execution over Claude Code slash commands:

### Check What Would Change (Recommended First Step)
Before running the playbook, see what changes would be made:
```bash
./check-diff.sh
```

### Install Prerequisites Only
Install just the tools needed to run the automation (Homebrew, Ansible, collections):
```bash
./run.sh --prerequisites
```

### Full Setup
Run the complete setup with all configurations:
```bash
./run.sh
```

### Selective Installation
Use the run script with specific options:

- Install only Homebrew packages and applications:
  ```bash
  ./run.sh --homebrew
  ```

- Configure only system preferences:
  ```bash
  ./run.sh --system
  ```

- Set up only Dock configuration:
  ```bash
  ./run.sh --dock
  ```

- Configure only shell environment:
  ```bash
  ./run.sh --shell
  ```

- Install only additional CLI tools:
  ```bash
  ./run.sh --cli
  ```

- Install fonts and configure terminals:
  ```bash
  ./run.sh --fonts
  ```

### Direct Ansible Execution
You can also run Ansible directly with tags:

```bash
# Run specific components
ansible-playbook playbook.yml --tags "homebrew,apps"
ansible-playbook playbook.yml --tags "system,preferences" 
ansible-playbook playbook.yml --tags "shell,environment"

# Check syntax
ansible-playbook --syntax-check playbook.yml

# Dry run to see changes
ansible-playbook playbook.yml --check --diff
```

## License

This configuration is provided as-is for personal use.