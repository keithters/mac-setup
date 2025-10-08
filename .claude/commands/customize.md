---
description: Learn how to customize the Mac setup for your preferences
---

**🎨 Customization Guide**

Want to tailor this Mac setup to your preferences? Here's how to modify each component:

## 🍺 Adding/Removing Homebrew Packages

Edit `tasks/homebrew.yml`:

```yaml
# Add CLI tools to formulae section (around line 30)
loop:
  - your-new-tool
  - another-cli-tool

# Add GUI apps to casks section (around line 84)  
loop:
  - your-new-app
  - another-application
```

## ⚙️ Customizing System Preferences

Edit `tasks/system_preferences.yml`:

```yaml
- name: Your custom preference
  community.general.osx_defaults:
    domain: com.apple.example    # App domain
    key: YourPreferenceKey       # Setting key
    type: bool                   # bool, int, float, string
    value: true                  # Your desired value
```

## 🎯 Modifying Dock Layout

Edit `tasks/dock.yml` and change the `dock_items` list:

```yaml
dock_items:
  - "Your Preferred App"
  - "Another App"
  - "Third App"
  # Apps will appear in this order
```

## 🐚 Shell Environment Changes

Edit `tasks/shell_environment.yml` around line 29 for aliases:

```yaml
# Custom aliases  
alias your-alias='your-command'
alias shortcut='long-command-here'

# Environment variables
export YOUR_VAR='your-value'
```

## 📝 Neovim Configuration

The Neovim config is in `tasks/shell_environment.yml` (lines 157-272). Modify the Lua configuration:

```lua
-- Add your preferred plugins to the lazy.nvim setup
{
  "your/preferred-plugin",
  config = function()
    -- Plugin configuration
  end,
},
```

## 🔧 Testing Your Changes

After making changes:

1. **Check syntax**: `ansible-playbook --syntax-check playbook.yml`
2. **Preview changes**: `/check-diff`  
3. **Test specific component**: `./run.sh --shell` (for shell changes)
4. **Apply changes**: `/run-all`

## 💡 Pro Tips

- **Always test first**: Use `/check-diff` before applying changes
- **Backup important settings**: The automation backs up `.p10k.zsh` automatically
- **Run selectively**: Use flags like `--homebrew`, `--shell`, `--system` to test individual changes
- **Keep it idempotent**: Ensure changes can be run multiple times safely

Need inspiration? Check the existing task files to see how different components are configured!