#!/bin/bash

# Mac Setup Automation Script
# This script provides a convenient way to run the Ansible playbook

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🍎 Mac Setup Automation${NC}"
echo "=========================="

# Install prerequisites automatically
echo -e "${BLUE}🔍 Checking prerequisites...${NC}"

# Check if Homebrew is installed
if ! command -v brew &> /dev/null; then
    echo -e "${YELLOW}📦 Installing Homebrew...${NC}"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add Homebrew to PATH
    if [[ $(uname -m) == "arm64" ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
    else
        eval "$(/usr/local/bin/brew shellenv)"
        echo 'eval "$(/usr/local/bin/brew shellenv)"' >> ~/.zprofile
    fi
    
    echo -e "${GREEN}✅ Homebrew installed successfully${NC}"
else
    echo -e "${GREEN}✅ Homebrew already installed${NC}"
fi

# Update Homebrew
echo -e "${BLUE}🔄 Updating Homebrew...${NC}"
brew update

# Check if Python is installed (should come with macOS, but ensure it's available)
if ! command -v python3 &> /dev/null; then
    echo -e "${YELLOW}🐍 Installing Python via Homebrew...${NC}"
    brew install python
    echo -e "${GREEN}✅ Python installed successfully${NC}"
else
    echo -e "${GREEN}✅ Python already available${NC}"
fi

# Check if Ansible is installed
if ! command -v ansible-playbook &> /dev/null; then
    echo -e "${YELLOW}🔧 Installing Ansible via Homebrew...${NC}"
    brew install ansible
    echo -e "${GREEN}✅ Ansible installed successfully${NC}"
else
    echo -e "${GREEN}✅ Ansible already installed${NC}"
fi

# Check if community.general collection is installed
echo -e "${BLUE}📦 Checking Ansible collections...${NC}"
if ! ansible-galaxy collection list 2>/dev/null | grep -q community.general; then
    echo -e "${YELLOW}⚠️  Installing community.general collection...${NC}"
    ansible-galaxy collection install community.general
    echo -e "${GREEN}✅ Ansible collection installed successfully${NC}"
else
    echo -e "${GREEN}✅ Ansible collections already installed${NC}"
fi

echo -e "${GREEN}🎉 All prerequisites ready!${NC}"
echo ""

# Function to show usage
show_usage() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  --full, -f          Run complete setup (default)"
    echo "  --homebrew, -h      Install only Homebrew packages and apps"
    echo "  --system, -s        Configure only system preferences"
    echo "  --dock, -d          Set up only Dock configuration"
    echo "  --shell, -sh        Configure only shell environment"
    echo "  --cli, -c           Install additional CLI tools"
    echo "  --fonts, -ft        Install fonts and configure terminals (iTerm2 & Ghostty)"
    echo "  --diff, -d          Show what changes would be made (dry-run)"
    echo "  --help              Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0                  # Full setup"
    echo "  $0 --diff           # See what changes would be made"
    echo "  $0 --homebrew       # Install apps only"
    echo "  $0 --system --dock  # System preferences and Dock only"
}

# Parse command line arguments
TAGS=""
FULL_SETUP=true

while [[ $# -gt 0 ]]; do
    case $1 in
        --full|-f)
            FULL_SETUP=true
            shift
            ;;
        --homebrew|-h)
            TAGS="${TAGS}homebrew,apps,"
            FULL_SETUP=false
            shift
            ;;
        --system|-s)
            TAGS="${TAGS}system,preferences,"
            FULL_SETUP=false
            shift
            ;;
        --dock|-d)
            TAGS="${TAGS}dock,"
            FULL_SETUP=false
            shift
            ;;
        --shell|-sh)
            TAGS="${TAGS}shell,environment,"
            FULL_SETUP=false
            shift
            ;;
        --cli|-c)
            TAGS="${TAGS}cli,tools,additional,"
            FULL_SETUP=false
            shift
            ;;
        --fonts|-ft)
            TAGS="${TAGS}fonts,terminals,iterm,ghostty,"
            FULL_SETUP=false
            shift
            ;;
        --diff|-d)
            echo -e "${GREEN}🔍 Running diff check...${NC}"
            ./check-diff.sh
            exit 0
            ;;
        --help)
            show_usage
            exit 0
            ;;
        *)
            echo -e "${RED}Unknown option: $1${NC}"
            show_usage
            exit 1
            ;;
    esac
done

# Remove trailing comma from tags
TAGS=$(echo "$TAGS" | sed 's/,$//')

# Run the playbook
if [[ "$FULL_SETUP" == true ]]; then
    echo -e "${GREEN}🚀 Running full Mac setup...${NC}"
    ansible-playbook playbook.yml -v
elif [[ -n "$TAGS" ]]; then
    echo -e "${GREEN}🚀 Running selective setup with tags: $TAGS${NC}"
    ansible-playbook playbook.yml --tags "$TAGS" -v
else
    echo -e "${RED}❌ No valid options provided${NC}"
    show_usage
    exit 1
fi

echo -e "${GREEN}✅ Setup completed successfully!${NC}"
echo ""
echo -e "${YELLOW}📝 Next steps:${NC}"
echo "1. Restart your terminal or run: source ~/.zshrc"
echo "2. Configure application-specific settings manually"
echo "3. Log into your applications (1Password, Slack, etc.)"
echo "4. Run 'p10k configure' to customize your terminal prompt"