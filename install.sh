#!/bin/bash

# Mac Setup Automation - One-line installer
# Usage: curl -fsSL https://raw.githubusercontent.com/keithters/mac-setup/main/install.sh | bash

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
BOLD='\033[1m'
NC='\033[0m' # No Color

echo -e "${BOLD}${MAGENTA}🍎 Mac Setup Automation - One-Line Installer${NC}"
echo -e "${BOLD}===============================================${NC}"
echo ""

# Configuration
REPO_URL="https://github.com/keithters/mac-setup"
CLONE_DIR="$HOME/mac-setup"
BRANCH="main"

# Parse command line arguments for advanced usage
PREREQUISITES_ONLY=false
RUN_FULL_SETUP=false
CHECK_DIFF_ONLY=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --prerequisites)
            PREREQUISITES_ONLY=true
            shift
            ;;
        --full)
            RUN_FULL_SETUP=true
            shift
            ;;
        --check-diff)
            CHECK_DIFF_ONLY=true
            shift
            ;;
        --help)
            echo "Mac Setup Automation Installer"
            echo ""
            echo "Usage:"
            echo "  curl -fsSL https://raw.githubusercontent.com/keithters/mac-setup/main/install.sh | bash"
            echo ""
            echo "Advanced usage:"
            echo "  curl -fsSL https://raw.githubusercontent.com/keithters/mac-setup/main/install.sh | bash -s -- [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  --prerequisites  Install prerequisites only"
            echo "  --full           Run complete Mac setup after cloning"
            echo "  --check-diff     Show what would change (dry run)"
            echo "  --help           Show this help message"
            echo ""
            echo "Examples:"
            echo "  # Just clone the repository (default)"
            echo "  curl -fsSL https://raw.githubusercontent.com/keithters/mac-setup/main/install.sh | bash"
            echo ""
            echo "  # Install prerequisites only"
            echo "  curl -fsSL https://raw.githubusercontent.com/keithters/mac-setup/main/install.sh | bash -s -- --prerequisites"
            echo ""
            echo "  # Full automated setup"
            echo "  curl -fsSL https://raw.githubusercontent.com/keithters/mac-setup/main/install.sh | bash -s -- --full"
            exit 0
            ;;
        *)
            echo -e "${RED}Unknown option: $1${NC}"
            exit 1
            ;;
    esac
done

# Check if git is available
if ! command -v git &> /dev/null; then
    echo -e "${YELLOW}📦 Git not found. Installing Xcode Command Line Tools...${NC}"
    xcode-select --install
    echo -e "${YELLOW}⏳ Please complete the Xcode Command Line Tools installation and run this script again.${NC}"
    exit 1
fi

# Clone or update the repository
if [[ -d "$CLONE_DIR" ]]; then
    echo -e "${BLUE}📂 Found existing repository at $CLONE_DIR${NC}"
    echo -e "${BLUE}🔄 Updating repository...${NC}"
    cd "$CLONE_DIR"
    git pull origin "$BRANCH"
else
    echo -e "${BLUE}📥 Cloning Mac Setup repository...${NC}"
    git clone "$REPO_URL" "$CLONE_DIR"
    cd "$CLONE_DIR"
fi

echo -e "${GREEN}✅ Repository ready at: $CLONE_DIR${NC}"
echo ""

# Handle different execution modes
if [[ "$PREREQUISITES_ONLY" == true ]]; then
    echo -e "${YELLOW}🔧 Installing prerequisites only...${NC}"
    ./run.sh --prerequisites
elif [[ "$CHECK_DIFF_ONLY" == true ]]; then
    echo -e "${YELLOW}🔍 Running system analysis...${NC}"
    ./check-diff.sh
elif [[ "$RUN_FULL_SETUP" == true ]]; then
    echo -e "${YELLOW}🚀 Running full Mac setup...${NC}"
    ./run.sh
else
    # Default: Just clone and show next steps
    echo -e "${BOLD}${GREEN}🎉 Mac Setup Automation is ready!${NC}"
    echo ""
    echo -e "${YELLOW}📍 Location:${NC} $CLONE_DIR"
    echo ""
    echo -e "${BOLD}${BLUE}🚀 Quick Start:${NC}"
    echo "  cd $CLONE_DIR"
    echo ""
    echo -e "${BOLD}${CYAN}📋 Recommended workflow:${NC}"
    echo "  1. ./run.sh --prerequisites     # Install foundation tools"
    echo "  2. ./check-diff.sh              # See what would change"  
    echo "  3. ./run.sh                     # Run complete setup"
    echo ""
    echo -e "${BOLD}${MAGENTA}🎨 With Claude Code:${NC}"
    echo "  Use slash commands: /setup-prerequisites, /check-diff, /run-all"
    echo ""
    echo -e "${BLUE}💡 Run './run.sh --help' for all options${NC}"
fi

echo ""
echo -e "${GREEN}✨ Happy Mac automation! ✨${NC}"