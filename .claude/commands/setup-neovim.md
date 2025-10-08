---
description: Install and configure Neovim with modern plugins
---

**📝 Modern Neovim Setup** - Install Neovim with a comprehensive plugin configuration:

!./run.sh --shell

This will set up:
- **🎨 Theme**: Catppuccin Mocha colorscheme
- **📁 File Explorer**: nvim-tree with web devicons  
- **🔍 Fuzzy Finder**: Telescope for file/text search
- **🌳 Syntax Highlighting**: Tree-sitter with multiple languages
- **📊 Status Line**: Lualine with theme integration
- **⚡ Plugin Manager**: lazy.nvim for fast startup
- **🔧 Auto-tools**: autopairs, comments, git signs

## Key Features Configured
- Leader key: `<Space>`
- File explorer: `<Space>e`
- Find files: `<Space>ff`  
- Live grep: `<Space>fg`
- Buffer search: `<Space>fb`
- Window navigation: `Ctrl+hjkl`

## Also Sets Up
- `vim` command aliased to `nvim` (overrides system vim)
- Configuration in `~/.config/nvim/init.lua`
- Automatic plugin installation on first launch

⏱️ **Time**: 1-2 minutes  
🎯 **Result**: Production-ready Neovim with modern workflows