#!/bin/bash
#
# Portable Zsh Plugins Installer
# Installs Oh My Zsh, Powerlevel10k theme, and essential zsh plugins
# No dependencies required - works on any Unix-like system with zsh, git, and curl
#
# Usage: ./install-zsh-plugins.sh

set -e

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check prerequisites
check_prerequisites() {
    log_info "Checking prerequisites..."

    if ! command -v zsh &> /dev/null; then
        log_error "zsh is not installed. Please install zsh first."
        exit 1
    fi

    if ! command -v git &> /dev/null; then
        log_error "git is not installed. Please install git first."
        exit 1
    fi

    if ! command -v curl &> /dev/null; then
        log_error "curl is not installed. Please install curl first."
        exit 1
    fi

    log_success "All prerequisites met"
}

# Prompt for user confirmation
prompt_install() {
    local component="$1"
    local description="$2"

    echo ""
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${GREEN}${component}${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${description}"
    echo ""
    read -p "Install ${component}? (Y/n): " -n 1 -r
    echo

    # Default to yes if user just presses enter
    if [[ -z $REPLY ]] || [[ $REPLY =~ ^[Yy]$ ]]; then
        return 0
    else
        log_info "Skipping ${component}"
        return 1
    fi
}

# Install Oh My Zsh
install_oh_my_zsh() {
    if ! prompt_install "Oh My Zsh" "A delightful framework for managing your zsh configuration.\nProvides hundreds of plugins, themes, and helpful functions.\n${YELLOW}Optional:${NC} Plugins can be installed with or without Oh My Zsh.\n${BLUE}Recommended for beginners.${NC}"; then
        USE_OMZ=false
        log_info "Will install plugins in standalone mode (without Oh My Zsh)"
        return
    fi

    USE_OMZ=true

    if [ -d "$HOME/.oh-my-zsh" ]; then
        log_warning "Oh My Zsh is already installed at ~/.oh-my-zsh"
        read -p "Reinstall? This will backup existing installation. (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            log_info "Backing up existing Oh My Zsh installation..."
            mv "$HOME/.oh-my-zsh" "$HOME/.oh-my-zsh.backup.$(date +%s)"
        else
            log_info "Using existing Oh My Zsh installation"
            return
        fi
    fi

    log_info "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    log_success "Oh My Zsh installed"
}

# Install Powerlevel10k theme
install_powerlevel10k() {
    if ! prompt_install "Powerlevel10k" "A fast and flexible zsh theme with rich customization options.\nProvides a beautiful, informative prompt with git status, command duration,\nand much more. Includes an interactive configuration wizard."; then
        INSTALL_P10K=false
        return
    fi

    INSTALL_P10K=true

    if [ "$USE_OMZ" = true ]; then
        # Install to Oh My Zsh custom themes directory
        local theme_dir="$HOME/.oh-my-zsh/custom/themes/powerlevel10k"
        P10K_PATH="$theme_dir"
    else
        # Install to standalone directory
        local theme_dir="$HOME/.powerlevel10k"
        P10K_PATH="$theme_dir/powerlevel10k.zsh-theme"
    fi

    if [ -d "$theme_dir" ]; then
        log_warning "Powerlevel10k already exists"
        log_info "Updating Powerlevel10k..."
        cd "$theme_dir" && git pull
    else
        log_info "Installing Powerlevel10k theme..."
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$theme_dir"
    fi

    log_success "Powerlevel10k installed"
}

# Install zsh-autosuggestions
install_autosuggestions() {
    if ! prompt_install "zsh-autosuggestions" "Suggests commands as you type based on your command history.\nPress ${YELLOW}→${NC} (right arrow) to accept a suggestion.\nMakes command line navigation faster and more efficient."; then
        INSTALL_AUTOSUGGESTIONS=false
        return
    fi

    INSTALL_AUTOSUGGESTIONS=true

    if [ "$USE_OMZ" = true ]; then
        local plugin_dir="$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions"
        AUTOSUGGESTIONS_PATH="$plugin_dir/zsh-autosuggestions.zsh"
    else
        local plugin_dir="$HOME/.zsh/zsh-autosuggestions"
        AUTOSUGGESTIONS_PATH="$plugin_dir/zsh-autosuggestions.zsh"
    fi

    if [ -d "$plugin_dir" ]; then
        log_warning "zsh-autosuggestions already exists"
        log_info "Updating zsh-autosuggestions..."
        cd "$plugin_dir" && git pull
    else
        log_info "Installing zsh-autosuggestions..."
        mkdir -p "$(dirname "$plugin_dir")"
        git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions.git "$plugin_dir"
    fi

    log_success "zsh-autosuggestions installed"
}

# Install zsh-syntax-highlighting
install_syntax_highlighting() {
    if ! prompt_install "zsh-syntax-highlighting" "Provides Fish-like syntax highlighting for your zsh commands.\nHighlights valid commands in green, invalid in red, and colorizes\nstrings, paths, and other syntax elements as you type."; then
        INSTALL_SYNTAX_HIGHLIGHTING=false
        return
    fi

    INSTALL_SYNTAX_HIGHLIGHTING=true

    if [ "$USE_OMZ" = true ]; then
        local plugin_dir="$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"
        SYNTAX_HIGHLIGHTING_PATH="$plugin_dir/zsh-syntax-highlighting.zsh"
    else
        local plugin_dir="$HOME/.zsh/zsh-syntax-highlighting"
        SYNTAX_HIGHLIGHTING_PATH="$plugin_dir/zsh-syntax-highlighting.zsh"
    fi

    if [ -d "$plugin_dir" ]; then
        log_warning "zsh-syntax-highlighting already exists"
        log_info "Updating zsh-syntax-highlighting..."
        cd "$plugin_dir" && git pull
    else
        log_info "Installing zsh-syntax-highlighting..."
        mkdir -p "$(dirname "$plugin_dir")"
        git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git "$plugin_dir"
    fi

    log_success "zsh-syntax-highlighting installed"
}

# Install you-should-use
install_you_should_use() {
    if ! prompt_install "you-should-use" "Reminds you to use existing aliases when you type the full command.\nHelps you learn and remember your configured aliases and save time.\nExample: Typing 'git status' reminds you about your 'gst' alias."; then
        INSTALL_YOU_SHOULD_USE=false
        return
    fi

    INSTALL_YOU_SHOULD_USE=true

    if [ "$USE_OMZ" = true ]; then
        local plugin_dir="$HOME/.oh-my-zsh/custom/plugins/you-should-use"
        YOU_SHOULD_USE_PATH="$plugin_dir/you-should-use.plugin.zsh"
    else
        local plugin_dir="$HOME/.zsh/you-should-use"
        YOU_SHOULD_USE_PATH="$plugin_dir/you-should-use.plugin.zsh"
    fi

    if [ -d "$plugin_dir" ]; then
        log_warning "you-should-use already exists"
        log_info "Updating you-should-use..."
        cd "$plugin_dir" && git pull
    else
        log_info "Installing you-should-use..."
        mkdir -p "$(dirname "$plugin_dir")"
        git clone --depth=1 https://github.com/MichaelAquilina/zsh-you-should-use.git "$plugin_dir"
    fi

    log_success "you-should-use installed"
}

# Install MesloLGS Nerd Font
install_nerd_font() {
    if ! prompt_install "MesloLGS Nerd Font" "The official Nerd Font recommended for Powerlevel10k.\nIncludes all glyphs and icons needed for the best prompt experience.\n${YELLOW}Highly recommended if you installed Powerlevel10k.${NC}"; then
        INSTALL_NERD_FONT=false
        return
    fi

    INSTALL_NERD_FONT=true

    # Create fonts directory if it doesn't exist
    local fonts_dir="$HOME/Library/Fonts"

    # Check platform
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        fonts_dir="$HOME/Library/Fonts"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Linux
        fonts_dir="$HOME/.local/share/fonts"
        mkdir -p "$fonts_dir"
    else
        log_warning "Unsupported OS for automatic font installation"
        log_info "Please manually install MesloLGS NF from: https://github.com/romkatv/powerlevel10k#fonts"
        return
    fi

    log_info "Installing MesloLGS Nerd Font to $fonts_dir..."

    # Download all four font variants
    local fonts=(
        "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf"
        "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf"
        "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf"
        "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf"
    )

    local download_count=0
    for font_url in "${fonts[@]}"; do
        local font_name=$(echo "$font_url" | sed 's/.*%20//' | sed 's/%20/ /g')
        local font_path="$fonts_dir/$font_name"

        if [ -f "$font_path" ]; then
            log_warning "$font_name already exists, skipping"
        else
            if curl -fsSL "$font_url" -o "$font_path"; then
                ((download_count++))
                log_info "Downloaded $font_name"
            else
                log_error "Failed to download $font_name"
            fi
        fi
    done

    if [ $download_count -gt 0 ]; then
        # Refresh font cache on Linux
        if [[ "$OSTYPE" == "linux-gnu"* ]]; then
            if command -v fc-cache &> /dev/null; then
                fc-cache -f "$fonts_dir"
                log_info "Font cache refreshed"
            fi
        fi

        log_success "MesloLGS Nerd Font installed ($download_count files)"
        log_warning "You may need to restart your terminal and select the font:"
        echo "  - Terminal app: Preferences → Profiles → Font → MesloLGS NF"
        echo "  - iTerm2: Preferences → Profiles → Text → Font → MesloLGS NF"
        echo "  - VS Code: Settings → Terminal Font Family → 'MesloLGS NF'"
    else
        log_info "All font files already present"
    fi
}

# Configure .zshrc
configure_zshrc() {
    log_info "Configuring .zshrc..."

    local zshrc="$HOME/.zshrc"

    # Backup existing .zshrc
    if [ -f "$zshrc" ]; then
        cp "$zshrc" "${zshrc}.backup.$(date +%s)"
        log_info "Backed up existing .zshrc"
    fi

    if [ "$USE_OMZ" = true ]; then
        # Configure for Oh My Zsh mode
        configure_omz_mode
    else
        # Configure for standalone mode
        configure_standalone_mode
    fi

    log_success ".zshrc configured"
}

# Configure Oh My Zsh mode
configure_omz_mode() {
    local zshrc="$HOME/.zshrc"

    # Update theme if Powerlevel10k was installed
    if [ "$INSTALL_P10K" = true ]; then
        if grep -q "ZSH_THEME=\"powerlevel10k/powerlevel10k\"" "$zshrc" 2>/dev/null; then
            log_warning "Powerlevel10k theme already configured in .zshrc"
        else
            if [ -f "$zshrc" ]; then
                sed -i.tmp 's/^ZSH_THEME=.*/ZSH_THEME="powerlevel10k\/powerlevel10k"/' "$zshrc"
                rm -f "${zshrc}.tmp"
                log_info "Updated theme to Powerlevel10k in .zshrc"
            fi
        fi
    fi

    # Build plugins list based on what was installed
    local plugins="git"

    if [ "$INSTALL_AUTOSUGGESTIONS" = true ]; then
        plugins="$plugins zsh-autosuggestions"
    fi

    if [ "$INSTALL_SYNTAX_HIGHLIGHTING" = true ]; then
        plugins="$plugins zsh-syntax-highlighting"
    fi

    if [ "$INSTALL_YOU_SHOULD_USE" = true ]; then
        plugins="$plugins you-should-use"
    fi

    # Update plugins in .zshrc
    if [ -f "$zshrc" ]; then
        if grep -q "^plugins=(" "$zshrc" 2>/dev/null; then
            # Get existing plugins and merge with new ones
            local existing_plugins=$(grep "^plugins=(" "$zshrc" | sed 's/plugins=(//' | sed 's/)//' | tr ' ' '\n' | sort -u)
            local new_plugins=$(echo "$plugins" | tr ' ' '\n' | sort -u)
            local merged_plugins=$(echo -e "${existing_plugins}\n${new_plugins}" | sort -u | tr '\n' ' ' | sed 's/ $//')

            sed -i.tmp "s/^plugins=(.*/plugins=($merged_plugins)/" "$zshrc"
            rm -f "${zshrc}.tmp"
            log_info "Updated plugins in .zshrc: $merged_plugins"
        else
            # No plugins line exists, add one
            echo "plugins=($plugins)" >> "$zshrc"
            log_info "Added plugins to .zshrc: $plugins"
        fi
    fi
}

# Configure standalone mode (without Oh My Zsh)
configure_standalone_mode() {
    local zshrc="$HOME/.zshrc"

    # Create .zshrc if it doesn't exist
    if [ ! -f "$zshrc" ]; then
        touch "$zshrc"
    fi

    # Remove existing plugin configuration block if present
    if grep -q "# BEGIN ZSH PLUGINS INSTALLER" "$zshrc" 2>/dev/null; then
        log_info "Updating existing plugin configuration..."
        sed -i.tmp '/# BEGIN ZSH PLUGINS INSTALLER/,/# END ZSH PLUGINS INSTALLER/d' "$zshrc"
        rm -f "${zshrc}.tmp"
    fi

    # Build configuration block
    local config_block="# BEGIN ZSH PLUGINS INSTALLER\n"
    config_block="${config_block}# This block was added by install-zsh-plugins.sh\n\n"

    # Add Powerlevel10k if installed
    if [ "$INSTALL_P10K" = true ]; then
        config_block="${config_block}# Powerlevel10k theme\n"
        config_block="${config_block}source $P10K_PATH\n\n"
    fi

    # Add plugins if installed
    if [ "$INSTALL_AUTOSUGGESTIONS" = true ]; then
        config_block="${config_block}# zsh-autosuggestions\n"
        config_block="${config_block}source $AUTOSUGGESTIONS_PATH\n\n"
    fi

    if [ "$INSTALL_SYNTAX_HIGHLIGHTING" = true ]; then
        config_block="${config_block}# zsh-syntax-highlighting (must be loaded last)\n"
        config_block="${config_block}source $SYNTAX_HIGHLIGHTING_PATH\n\n"
    fi

    if [ "$INSTALL_YOU_SHOULD_USE" = true ]; then
        config_block="${config_block}# you-should-use\n"
        config_block="${config_block}source $YOU_SHOULD_USE_PATH\n\n"
    fi

    config_block="${config_block}# END ZSH PLUGINS INSTALLER"

    # Append configuration block to .zshrc
    echo -e "\n$config_block" >> "$zshrc"
    log_info "Added plugin configuration to .zshrc (standalone mode)"
}

# Display summary
display_summary() {
    echo ""
    echo "=========================================="
    log_success "Zsh plugins installation complete!"
    echo "=========================================="
    echo ""

    # Show installation mode
    if [ "$USE_OMZ" = true ]; then
        log_info "Installation mode: ${GREEN}Oh My Zsh${NC}"
    else
        log_info "Installation mode: ${GREEN}Standalone${NC} (without Oh My Zsh)"
    fi
    echo ""

    local installed_count=0
    log_info "Installed components:"

    if [ "$USE_OMZ" = true ]; then
        echo "  ✓ Oh My Zsh framework"
        ((installed_count++))
    fi

    if [ "$INSTALL_P10K" = true ]; then
        echo "  ✓ Powerlevel10k theme"
        ((installed_count++))
    fi

    if [ "$INSTALL_AUTOSUGGESTIONS" = true ]; then
        echo "  ✓ zsh-autosuggestions"
        ((installed_count++))
    fi

    if [ "$INSTALL_SYNTAX_HIGHLIGHTING" = true ]; then
        echo "  ✓ zsh-syntax-highlighting"
        ((installed_count++))
    fi

    if [ "$INSTALL_YOU_SHOULD_USE" = true ]; then
        echo "  ✓ you-should-use"
        ((installed_count++))
    fi

    if [ "$INSTALL_NERD_FONT" = true ]; then
        echo "  ✓ MesloLGS Nerd Font"
        ((installed_count++))
    fi

    if [ $installed_count -eq 0 ]; then
        echo "  (No new components installed)"
    fi

    echo ""
    log_warning "Next steps:"
    echo "  1. Restart your terminal or run: source ~/.zshrc"

    if [ "$INSTALL_P10K" = true ]; then
        echo "  2. Powerlevel10k will prompt you to configure on first launch"

        if [ "$INSTALL_NERD_FONT" = true ]; then
            echo "  3. Configure your terminal to use MesloLGS NF font"
        else
            echo "  3. Install a Nerd Font for best experience: https://www.nerdfonts.com/"
        fi
    fi

    if [ "$USE_OMZ" = false ] && [ $installed_count -gt 0 ]; then
        echo ""
        log_info "Note: Plugins installed in standalone mode at ~/.zsh/"
    fi

    echo ""
}

# Main execution
main() {
    # Initialize installation flags
    USE_OMZ=false
    INSTALL_P10K=false
    INSTALL_AUTOSUGGESTIONS=false
    INSTALL_SYNTAX_HIGHLIGHTING=false
    INSTALL_YOU_SHOULD_USE=false
    INSTALL_NERD_FONT=false

    echo ""
    echo "=========================================="
    echo "  Portable Zsh Plugins Installer"
    echo "=========================================="
    echo ""
    echo "This script will guide you through installing"
    echo "zsh plugins with or without Oh My Zsh."
    echo ""
    echo "You'll be prompted for each component with a"
    echo "description of what it does. Press Y to install"
    echo "or N to skip (default is Y)."
    echo ""
    log_info "${BLUE}All plugins work both with and without Oh My Zsh!${NC}"
    echo ""
    read -p "Press Enter to continue..."
    echo ""

    check_prerequisites
    install_oh_my_zsh
    install_powerlevel10k
    install_autosuggestions
    install_syntax_highlighting
    install_you_should_use
    install_nerd_font
    configure_zshrc
    display_summary
}

# Run main function
main
