---
description: Analyze system state and show what changes would be made
---

**🔍 Safe Preview Mode** - Run this first to see exactly what would change on your system without making any actual modifications:

!./check-diff.sh

This command will show you:
- ✅ Missing Homebrew packages that would be installed
- ⚙️ System preferences that would be changed  
- 🐚 Shell configuration updates that would be applied
- 🔧 Applications that would be configured

💡 **Tip**: Always run this before `/run-all` to understand what changes will be made to your Mac.