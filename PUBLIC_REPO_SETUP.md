# Setting Up a Public Repository

This guide will help you create a public repository from your current private course repository.

## Prerequisites

- GitHub account
- Git installed and configured
- Access to the current repository

## Important Notes

⚠️ **Data Files**: Your `.gitignore` is already configured to exclude data files (CSV, JSON, images, etc.) from version control. This is perfect for a public repo as it:
- Keeps the repository size small
- Protects potentially sensitive data
- Follows best practices for data science projects

✅ **What will be included**:
- All Jupyter notebooks
- Python modules
- R markdown files
- README and documentation
- Project structure
- Git history (if you choose to preserve it)

❌ **What will be excluded** (via .gitignore):
- All CSV files in `data/` directories
- JSON files
- Image files in `data/`
- Python cache files
- Environment files

## Option 1: Preserve Git History (Recommended)

This keeps all your commit history, which is great for showcasing your project development.

### Step 1: Create a New Public Repository on GitHub

1. Go to https://github.com/new
2. Choose a repository name (e.g., `startup-outcomes-analysis`)
3. **Make it PUBLIC** ⚠️
4. **DO NOT** initialize with README, .gitignore, or license
5. Click "Create repository"
6. Copy the repository URL (e.g., `https://github.com/yourusername/repo-name.git`)

### Step 2: Run the Setup Script

```bash
# Make the script executable
chmod +x setup_public_repo.sh

# Run the script
./setup_public_repo.sh
```

The script will:
- Add your new repo as a `public` remote
- Push all branches and tags
- Keep your original `origin` remote intact

### Step 3: Verify

1. Visit your new public repository on GitHub
2. Verify all files are present (except data files, which should be excluded)
3. Check that commit history is preserved

## Option 2: Fresh Start (No History)

If you prefer to start fresh without commit history:

### Step 1: Create a New Public Repository on GitHub

Same as Option 1, Step 1.

### Step 2: Initialize and Push

```bash
# Remove the old git history (creates a backup first)
cp -r .git .git.backup  # Backup just in case

# Remove old remote
git remote remove origin

# Add new remote
git remote add origin https://github.com/yourusername/repo-name.git

# Create a fresh initial commit
rm -rf .git
git init
git add .
git commit -m "Initial commit: Startup outcomes analysis project"

# Push to new repo
git branch -M main  # or master, depending on your preference
git push -u origin main
```

## Option 3: Manual Setup

If you prefer to do it manually:

```bash
# 1. Add new remote (keep old one)
git remote add public https://github.com/yourusername/repo-name.git

# 2. Commit any uncommitted changes (optional)
git add .
git commit -m "Update: prepare for public release"

# 3. Push to new remote
git push public master

# 4. Push all branches (if you have multiple)
git push public --all

# 5. Push tags (if you have any)
git push public --tags
```

## Post-Setup Checklist

After setting up your public repository:

- [ ] Verify all code files are present
- [ ] Verify data files are excluded (check `.gitignore`)
- [ ] Update README.md if needed (remove course-specific instructions)
- [ ] Add a LICENSE file (MIT, Apache 2.0, etc.)
- [ ] Add topics/tags to your GitHub repo
- [ ] Consider adding a CONTRIBUTING.md if you want contributions
- [ ] Update any hardcoded paths or references in your code
- [ ] Test that someone else can clone and understand the repo

## Making the Public Repo Your Default

If you want to make the public repo your default remote:

```bash
# Rename remotes
git remote rename origin private
git remote rename public origin

# Now 'origin' points to your public repo
# 'private' points to the course repo
```

## Troubleshooting

### "Remote 'public' already exists"
```bash
# Update the existing remote
git remote set-url public https://github.com/yourusername/new-repo.git
```

### "Permission denied"
- Make sure you're authenticated with GitHub
- Check that you have write access to the new repository
- Try using SSH instead of HTTPS: `git@github.com:username/repo.git`

### "Large files detected"
- Your `.gitignore` should prevent this, but if you see warnings about large files:
- Check that `.gitignore` is working: `git check-ignore -v data/**/*.csv`
- If files were previously committed, you may need to remove them from history (use `git filter-branch` or BFG Repo-Cleaner)

### Data files are being tracked
- If data files are already in git history, they'll be pushed even if in `.gitignore`
- To remove them: `git rm --cached data/**/*.csv` then commit

## Security Reminder

Before making the repo public, double-check for:
- API keys or secrets in code
- Personal information
- Credentials or passwords
- Private data that shouldn't be public

You can search for common patterns:
```bash
# Search for potential secrets (run from project root)
grep -r "api_key\|secret\|password\|token" --include="*.py" --include="*.ipynb" .
```

## Next Steps

1. **Add a license**: Choose an appropriate open-source license
2. **Improve documentation**: Update README with clear instructions
3. **Add badges**: Consider adding badges for build status, license, etc.
4. **Create releases**: Tag important milestones
5. **Share**: Add to your portfolio, LinkedIn, or resume!

