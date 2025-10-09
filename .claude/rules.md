# Project Rules

## Output Display
- Always show complete shell output without truncation
- Do not collapse output regardless of length
- Display all lines of command results
- Show full error messages and stack traces

## When executing shell commands or scripts:
- Display all output lines without truncation
- Never collapse output with "+N more lines"
- Show complete results for all commands
- Prefer verbose output over summaries
- Show all stdout and stderr without collapsing

## Ansible Automation Output
- When running Ansible playbooks (./run.sh or ansible-playbook commands):
  - Run in FOREGROUND (not background) to show all output directly
  - Display complete, untruncated Ansible output in the Claude window
  - Show all task details, status messages, and verbose information
  - Never summarize or collapse Ansible output - show everything
  - Display full stdout and stderr from the automation process
  - Let the full Ansible execution complete and show all results
  - Provide commentary after completion on what was accomplished