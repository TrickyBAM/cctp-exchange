#!/bin/bash
# ============================================
# CCTP.Valid — Push to GitHub
# Double-click this file on your Mac to run
# ============================================

# Move to the project folder (same folder as this script)
cd "$(dirname "$0")"

echo ""
echo "============================================"
echo "  CCTP.Valid — Push to GitHub"
echo "============================================"
echo ""

# ---- Step 1: Check that gh (GitHub CLI) is installed ----
if ! command -v gh &> /dev/null; then
    echo "❌ GitHub CLI (gh) is not installed."
    echo ""
    echo "Install it by running this in Terminal:"
    echo "   brew install gh"
    echo ""
    echo "Then run this script again."
    echo ""
    read -p "Press Enter to close..."
    exit 1
fi

# ---- Step 2: Check that gh is authenticated ----
if ! gh auth status &> /dev/null; then
    echo "❌ GitHub CLI is not logged in."
    echo ""
    echo "Run this in Terminal to log in:"
    echo "   gh auth login"
    echo ""
    echo "Then run this script again."
    echo ""
    read -p "Press Enter to close..."
    exit 1
fi

echo "✅ GitHub CLI is installed and logged in"
echo ""

# ---- Step 3: Get GitHub username ----
GH_USER=$(gh api user --jq '.login' 2>/dev/null)
if [ -z "$GH_USER" ]; then
    echo "❌ Could not determine your GitHub username."
    read -p "Press Enter to close..."
    exit 1
fi
echo "📦 GitHub user: $GH_USER"
echo ""

# ---- Step 4: Remove old .git folders (from Foundry build) ----
echo "🧹 Cleaning up old git data..."
rm -rf contracts/.git
rm -rf contracts/lib/*/.git
# Also clean nested .git dirs inside dependencies
find contracts/lib -name ".git" -type d -exec rm -rf {} + 2>/dev/null
echo "   Done"
echo ""

# ---- Step 5: Initialize fresh git repo at project root ----
echo "📂 Initializing fresh git repository..."
git init
git add -A
git commit -m "Initial commit — CCTP.Valid Phase 1 MVP

Smart contracts (Foundry/Solidity), Next.js frontend,
tiered fee system, CCTP V2 bridge from ETH/Base/Arb to XDC."
echo ""
echo "✅ Local git repo created with all files"
echo ""

# ---- Step 6: Create the GitHub repo ----
echo "🌐 Creating public GitHub repo: cctp-exchange..."
echo ""

# Check if repo already exists
if gh repo view "$GH_USER/cctp-exchange" &> /dev/null; then
    echo "⚠️  Repo $GH_USER/cctp-exchange already exists!"
    echo "   Setting it as the remote..."
    git remote remove origin 2>/dev/null
    git remote add origin "https://github.com/$GH_USER/cctp-exchange.git"
else
    gh repo create cctp-exchange --public --source=. --remote=origin --description "CCTP.Valid — USDC Bridge from Ethereum, Base & Arbitrum to XDC Network using Circle CCTP V2"
fi

echo ""

# ---- Step 7: Push to GitHub ----
echo "🚀 Pushing code to GitHub..."
git branch -M main
git push -u origin main

echo ""
echo "============================================"
echo "  ✅ SUCCESS! Your code is on GitHub!"
echo "============================================"
echo ""
echo "  🔗 https://github.com/$GH_USER/cctp-exchange"
echo ""
echo "  Open that link in your browser to see it."
echo ""
read -p "Press Enter to close..."
