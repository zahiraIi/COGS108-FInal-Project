#!/bin/bash
# Script to set up a new public repository from the current private repo
# This preserves git history but changes the remote to a new public repo

set -e  # Exit on error

echo "=========================================="
echo "Setting up Public Repository"
echo "=========================================="
echo ""

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Check if we're in a git repo
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo -e "${RED}Error: Not in a git repository${NC}"
    exit 1
fi

# Show current status
echo -e "${YELLOW}Current git status:${NC}"
git status --short
echo ""

# Show current remote
echo -e "${YELLOW}Current remote:${NC}"
git remote -v
echo ""

# Prompt for new repo URL
echo -e "${GREEN}Please create a new public repository on GitHub first.${NC}"
echo "Steps:"
echo "  1. Go to https://github.com/new"
echo "  2. Create a new repository (e.g., 'startup-outcomes-analysis')"
echo "  3. Make it PUBLIC"
echo "  4. DO NOT initialize with README, .gitignore, or license"
echo "  5. Copy the repository URL"
echo ""

read -p "Enter the new public repository URL (e.g., https://github.com/yourusername/repo-name.git): " NEW_REPO_URL

if [ -z "$NEW_REPO_URL" ]; then
    echo -e "${RED}Error: Repository URL cannot be empty${NC}"
    exit 1
fi

# Validate URL format
if [[ ! "$NEW_REPO_URL" =~ ^https://github.com/ ]]; then
    echo -e "${RED}Error: URL must be a GitHub HTTPS URL${NC}"
    exit 1
fi

echo ""
echo -e "${YELLOW}This will:${NC}"
echo "  1. Add the new repo as 'public' remote"
echo "  2. Push all branches and tags to the new public repo"
echo "  3. Keep the original 'origin' remote intact"
echo ""

read -p "Continue? (y/n): " -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Aborted."
    exit 0
fi

# Add new remote
echo ""
echo -e "${GREEN}Adding new remote 'public'...${NC}"
git remote add public "$NEW_REPO_URL" || {
    echo -e "${YELLOW}Remote 'public' already exists. Updating...${NC}"
    git remote set-url public "$NEW_REPO_URL"
}

# Verify remote was added
echo -e "${GREEN}Remotes configured:${NC}"
git remote -v
echo ""

# Check for uncommitted changes
if ! git diff-index --quiet HEAD --; then
    echo -e "${YELLOW}Warning: You have uncommitted changes.${NC}"
    echo "Options:"
    echo "  1. Commit them now"
    echo "  2. Stash them"
    echo "  3. Continue anyway (they won't be pushed)"
    read -p "Choose (1/2/3): " -n 1 -r
    echo ""
    
    case $REPLY in
        1)
            echo -e "${GREEN}Committing changes...${NC}"
            git add -A
            git commit -m "Update: prepare for public release"
            ;;
        2)
            echo -e "${GREEN}Stashing changes...${NC}"
            git stash push -m "Stashed before public repo setup"
            ;;
        3)
            echo -e "${YELLOW}Continuing without committing changes...${NC}"
            ;;
    esac
fi

# Push to new remote
echo ""
echo -e "${GREEN}Pushing to new public repository...${NC}"
echo "This may take a moment..."

# Push all branches
git push public --all || {
    echo -e "${RED}Error pushing branches. You may need to push manually.${NC}"
    echo "Try: git push public master"
}

# Push all tags
git push public --tags || {
    echo -e "${YELLOW}Warning: Could not push tags (this is okay if you don't have any)${NC}"
}

echo ""
echo -e "${GREEN}=========================================="
echo "Setup Complete!"
echo "==========================================${NC}"
echo ""
echo "Your code is now in the public repository:"
echo "  $NEW_REPO_URL"
echo ""
echo "To make 'public' your default remote, run:"
echo "  git remote rename origin private"
echo "  git remote rename public origin"
echo ""
echo "Or keep both remotes and push to 'public' when needed:"
echo "  git push public master"
echo ""

