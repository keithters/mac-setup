#!/bin/bash

# Mac Setup Diff Tool
# Compares current system state vs. what the Ansible playbook would install

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

echo -e "${BOLD}${MAGENTA}🍎 Mac Setup Playbook Diff Report${NC}"
echo -e "${BOLD}=================================================${NC}"

# Check if we're in the right directory
if [[ ! -f "playbook.yml" ]]; then
    echo -e "${RED}Error: Must be run from the ansible-mac directory${NC}"
    exit 1
fi

echo -e "${BLUE}🔍 Analyzing current system state...${NC}"

# Function to compare lists
compare_packages() {
    local title="$1"
    local current_file="$2"
    local target_file="$3"
    
    echo -e "\n${BOLD}${CYAN}=== $title ===${NC}"
    
    if [[ ! -f "$target_file" ]]; then
        echo -e "${YELLOW}⚠️  Target configuration not found${NC}"
        return
    fi
    
    # Create temp files for comparison
    local current_sorted=$(mktemp)
    local target_sorted=$(mktemp)
    local to_install=$(mktemp)
    local already_installed=$(mktemp)
    local extra_installed=$(mktemp)
    
    # Sort current packages
    sort "$current_file" > "$current_sorted" 2>/dev/null || touch "$current_sorted"
    
    # Sort target packages  
    sort "$target_file" > "$target_sorted" 2>/dev/null || touch "$target_sorted"
    
    # Find differences
    comm -23 "$target_sorted" "$current_sorted" > "$to_install"
    comm -12 "$target_sorted" "$current_sorted" > "$already_installed"
    comm -13 "$target_sorted" "$current_sorted" > "$extra_installed"
    
    # Display results
    if [[ -s "$to_install" ]]; then
        local count=$(wc -l < "$to_install")
        echo -e "\n${GREEN}📦 Will be INSTALLED ($count items):${NC}"
        while IFS= read -r package; do
            echo -e "  ${GREEN}+ $package${NC}"
        done < "$to_install"
    fi
    
    if [[ -s "$extra_installed" ]]; then
        local count=$(wc -l < "$extra_installed")
        echo -e "\n${YELLOW}🗑️  Currently installed but NOT in playbook ($count items):${NC}"
        head -10 "$extra_installed" | while IFS= read -r package; do
            echo -e "  ${YELLOW}? $package${NC}"
        done
        local total=$(wc -l < "$extra_installed")
        if [[ $total -gt 10 ]]; then
            echo -e "  ${YELLOW}... and $((total - 10)) more${NC}"
        fi
    fi
    
    if [[ -s "$already_installed" ]]; then
        local count=$(wc -l < "$already_installed")
        echo -e "\n${BLUE}✅ Already installed ($count items):${NC}"
        head -5 "$already_installed" | while IFS= read -r package; do
            echo -e "  ${BLUE}= $package${NC}"
        done
        local total=$(wc -l < "$already_installed")
        if [[ $total -gt 5 ]]; then
            echo -e "  ${BLUE}... and $((total - 5)) more${NC}"
        fi
    fi
    
    if [[ ! -s "$to_install" && ! -s "$extra_installed" ]]; then
        echo -e "${GREEN}✅ No changes needed - everything matches!${NC}"
    fi
    
    # Cleanup
    rm -f "$current_sorted" "$target_sorted" "$to_install" "$already_installed" "$extra_installed"
}

# Get current Homebrew packages
echo "Getting current Homebrew packages..."
current_formulae=$(mktemp)
current_casks=$(mktemp)
target_formulae=$(mktemp)
target_casks=$(mktemp)

# Current packages
brew list --formula 2>/dev/null > "$current_formulae" || touch "$current_formulae"
brew list --cask 2>/dev/null > "$current_casks" || touch "$current_casks"

# Target packages from YAML files
if [[ -f "tasks/homebrew.yml" ]]; then
    # Extract formulae from homebrew.yml
    grep -A 50 "Install Homebrew formulae" tasks/homebrew.yml | \
    grep "    - " | \
    sed 's/.*- //' | \
    sed 's/ *#.*//' | \
    grep -v "^$" > "$target_formulae" || touch "$target_formulae"
    
    # Extract casks from homebrew.yml  
    grep -A 50 "Install Homebrew casks" tasks/homebrew.yml | \
    grep "    - " | \
    sed 's/.*- //' | \
    sed 's/ *#.*//' | \
    grep -v "^$" > "$target_casks" || touch "$target_casks"
fi

# Compare packages
compare_packages "Homebrew Formulae" "$current_formulae" "$target_formulae"
compare_packages "Homebrew Casks" "$current_casks" "$target_casks"

# Check fonts
echo -e "\n${BOLD}${CYAN}=== Fonts ===${NC}"
fonts_dir="$HOME/Library/Fonts"
target_fonts=("MesloLGS NF Regular.ttf" "MesloLGS NF Bold.ttf" "MesloLGS NF Italic.ttf" "MesloLGS NF Bold Italic.ttf")
missing_fonts=()

for font in "${target_fonts[@]}"; do
    if [[ ! -f "$fonts_dir/$font" ]]; then
        missing_fonts+=("$font")
    fi
done

if [[ ${#missing_fonts[@]} -gt 0 ]]; then
    echo -e "\n${GREEN}📦 Fonts to be INSTALLED (${#missing_fonts[@]} items):${NC}"
    for font in "${missing_fonts[@]}"; do
        echo -e "  ${GREEN}+ $font${NC}"
    done
else
    echo -e "${GREEN}✅ All target fonts already installed${NC}"
fi

# Check Dock configuration
echo -e "\n${BOLD}${CYAN}=== Dock Configuration ===${NC}"

# Get current dock apps (simplified)
echo -e "${MAGENTA}📋 Current Dock apps:${NC}"
current_count=$(defaults read com.apple.dock persistent-apps 2>/dev/null | grep -c '"file-label"' || echo "0")
echo "  Currently has $current_count applications in Dock"

# Show a few example current apps
echo "  Examples from current Dock:"
defaults read com.apple.dock persistent-apps 2>/dev/null | \
grep '"file-label"' | \
head -5 | \
sed 's/.*"file-label" = \(.*\);/    • \1/' | \
sed 's/"//g' || echo "    Could not read current apps"

# Show target dock apps  
echo -e "\n${GREEN}📋 Target Dock apps (from playbook):${NC}"
if [[ -f "tasks/dock.yml" ]]; then
    echo "  Will be configured with these apps in order:"
    grep -A 50 "Add applications to Dock" tasks/dock.yml | \
    grep '{ name:' | \
    sed 's/.*{ name: "\([^"]*\)".*/    • \1/' | \
    head -10
    
    target_count=$(grep -A 50 "Add applications to Dock" tasks/dock.yml | \
    grep -c '{ name:')
    echo "  Total: $target_count applications will be in Dock"
else
    echo "  No dock.yml found"
fi

echo -e "\n${YELLOW}🔄 Dock will be COMPLETELY RECONFIGURED${NC}"
echo -e "    • All current apps will be removed"
echo -e "    • Target apps will be added in specified order"
echo -e "    • This ensures consistent Dock layout across machines"

# Check shell configuration
echo -e "\n${BOLD}${CYAN}=== Shell Configuration ===${NC}"

check_shell_item() {
    local name="$1"
    local check_cmd="$2"
    
    if eval "$check_cmd" >/dev/null 2>&1; then
        echo -e "  ${GREEN}✅ $name${NC}"
    else
        echo -e "  ${RED}❌ $name - WILL BE CONFIGURED${NC}"
    fi
}

check_shell_item "Oh My Zsh" "[[ -d ~/.oh-my-zsh ]]"
check_shell_item "Powerlevel10k theme" "[[ -d ~/.oh-my-zsh/custom/themes/powerlevel10k ]]"
check_shell_item "P10k configuration" "[[ -f ~/.p10k.zsh ]]"
check_shell_item "Python alias" "grep -q 'alias python=python3' ~/.zshrc 2>/dev/null"
check_shell_item "nnn function" "grep -q 'n ()' ~/.zshrc 2>/dev/null"
check_shell_item "pnpm configuration" "grep -q 'PNPM_HOME' ~/.zshrc 2>/dev/null"

# Check system preferences
echo -e "\n${BOLD}${CYAN}=== System Preferences ===${NC}"

check_pref() {
    local name="$1"
    local current="$2"
    local target="$3"
    
    if [[ "$current" == "$target" ]]; then
        echo -e "  ${GREEN}✅ $name: $current${NC}"
    else
        echo -e "  ${RED}🔄 $name: $current → $target${NC}"
    fi
}

echo -e "${BLUE}📁 Finder Preferences:${NC}"
finder_hidden=$(defaults read com.apple.finder AppleShowAllFiles 2>/dev/null || echo "0")
finder_pathbar=$(defaults read com.apple.finder ShowPathbar 2>/dev/null || echo "0")
finder_statusbar=$(defaults read com.apple.finder ShowStatusBar 2>/dev/null || echo "0")
finder_viewstyle=$(defaults read com.apple.finder FXPreferredViewStyle 2>/dev/null || echo "icnv")
finder_newtarget=$(defaults read com.apple.finder NewWindowTarget 2>/dev/null || echo "PfDe")
finder_extensions=$(defaults read com.apple.finder FXEnableExtensionChangeWarning 2>/dev/null || echo "1")

check_pref "Show hidden files" "$finder_hidden" "1"
check_pref "Show path bar" "$finder_pathbar" "1"  
check_pref "Show status bar" "$finder_statusbar" "1"
check_pref "Default view style" "$finder_viewstyle" "Nlsv"
check_pref "New window target" "$finder_newtarget" "PfHm"
check_pref "Extension change warning" "$finder_extensions" "0"

echo -e "\n${BLUE}🖥️  Desktop Preferences:${NC}"
desktop_external=$(defaults read com.apple.finder ShowExternalHardDrivesOnDesktop 2>/dev/null || echo "0")
desktop_internal=$(defaults read com.apple.finder ShowHardDrivesOnDesktop 2>/dev/null || echo "1")
screensaver_password=$(defaults read com.apple.screensaver askForPassword 2>/dev/null || echo "0")
screensaver_delay=$(defaults read com.apple.screensaver askForPasswordDelay 2>/dev/null || echo "300")

check_pref "Show external drives" "$desktop_external" "1"
check_pref "Show internal drives" "$desktop_internal" "0"
check_pref "Screensaver password" "$screensaver_password" "1"
check_pref "Password delay" "$screensaver_delay" "0"

echo -e "\n${BLUE}🚢 Dock Preferences:${NC}"
dock_autohide=$(defaults read com.apple.dock autohide 2>/dev/null || echo "0")
dock_recents=$(defaults read com.apple.dock show-recents 2>/dev/null || echo "1")
dock_magnification=$(defaults read com.apple.dock magnification 2>/dev/null || echo "0")
dock_mineffect=$(defaults read com.apple.dock mineffect 2>/dev/null || echo "genie")

check_pref "Auto-hide" "$dock_autohide" "0"
check_pref "Show recent apps" "$dock_recents" "0"
check_pref "Magnification" "$dock_magnification" "0"
check_pref "Minimize effect" "$dock_mineffect" "genie"

echo -e "\n${BLUE}👆 Trackpad Preferences:${NC}"
trackpad_click=$(defaults read com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking 2>/dev/null || echo "0")
trackpad_drag=$(defaults read com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag 2>/dev/null || echo "0")

check_pref "Tap to click" "$trackpad_click" "1"
check_pref "Three finger drag" "$trackpad_drag" "1"

echo -e "\n${BLUE}⌨️  Keyboard & UI:${NC}"
autocorrect=$(defaults read NSGlobalDomain NSAutomaticSpellingCorrectionEnabled 2>/dev/null || echo "1")
autocaps=$(defaults read NSGlobalDomain NSAutomaticCapitalizationEnabled 2>/dev/null || echo "1")
autoperiod=$(defaults read NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled 2>/dev/null || echo "1")
scrollbars=$(defaults read NSGlobalDomain AppleShowScrollBars 2>/dev/null || echo "Automatic")

check_pref "Auto-correct" "$autocorrect" "0"
check_pref "Auto-capitalization" "$autocaps" "0"
check_pref "Auto-period" "$autoperiod" "0"
check_pref "Scroll bars" "$scrollbars" "WhenScrolling"

# Run Ansible check mode for comprehensive comparison
echo -e "\n${BOLD}${CYAN}=== Ansible Dry Run Analysis ===${NC}"
echo -e "${BLUE}🔍 Running Ansible in check mode to identify all changes...${NC}"

# Run ansible in check mode to see what would actually change
echo -e "\n${MAGENTA}📋 Detailed Ansible Analysis:${NC}"
if command -v ansible-playbook >/dev/null 2>&1; then
    echo -e "Running: ${CYAN}ansible-playbook playbook.yml --check --diff${NC}"
    echo -e "${YELLOW}(This shows exactly what Ansible would change)${NC}\n"
    
    # Run ansible check but limit output for readability
    ansible-playbook playbook.yml --check --diff 2>/dev/null | \
    grep -E "(PLAY|TASK|\-\-\-|\+\+\+|changed:|ok:|skipping:)" | \
    head -20 || echo -e "${YELLOW}⚠️  Ansible not available or playbook has syntax issues${NC}"
    
    echo -e "\n${BLUE}💡 For full Ansible analysis, run:${NC}"
    echo -e "   ${CYAN}ansible-playbook playbook.yml --check --diff${NC}"
else
    echo -e "${YELLOW}⚠️  Ansible not installed - run ${GREEN}./run.sh${NC} to install prerequisites${NC}"
fi

# Summary and tips
echo -e "\n${BOLD}${CYAN}💡 Tips:${NC}"
echo -e "  • Run ${GREEN}./run.sh${NC} to apply all changes"
echo -e "  • Use ${GREEN}./run.sh --homebrew${NC} to install packages only"
echo -e "  • Use ${GREEN}./run.sh --fonts${NC} to install fonts only"
echo -e "  • Use ${GREEN}./run.sh --system${NC} to configure system preferences only"
echo -e "\n${BOLD}=================================================${NC}"

# Cleanup temp files
rm -f "$current_formulae" "$current_casks" "$target_formulae" "$target_casks"