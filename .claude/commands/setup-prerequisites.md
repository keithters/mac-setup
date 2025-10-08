---
description: Install only setup prerequisites (Homebrew, Ansible, collections)
---

**⚙️ Prerequisites Installation** - Install only the tools needed to run the Mac automation:

!timeout:300000 ./run.sh --prerequisites

This will install:
- **🍺 Homebrew**: Package manager for macOS
- **🐍 Python**: Required for Ansible (if not already available)
- **🔧 Ansible**: Automation engine for configuration management
- **📦 Collections**: community.general collection for macOS defaults

## **What This Does:**
- ✅ **Safe Setup**: Only installs essential tools, no system changes
- ✅ **Quick Installation**: Usually completes in 1-2 minutes
- ✅ **Foundation Ready**: Prepares your Mac for the full automation

## **After Prerequisites:**
- Run `/check-diff` to see what the full setup would change
- Run `/run-all` to apply the complete Mac configuration
- Run any selective commands like `/run-homebrew`, `/run-dock`, etc.

⏱️ **Time**: 1-2 minutes  
🛡️ **Safe**: No system or application changes, just installs tools
💡 **Perfect for**: New Macs or systems that need the automation tools first