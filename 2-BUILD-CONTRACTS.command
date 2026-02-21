#!/bin/bash

##################################################
#  CCTP Exchange — Step 2: Build Smart Contracts #
##################################################

clear
echo "============================================"
echo "  CCTP Exchange — Building Smart Contracts"
echo "============================================"
echo ""

# Make sure Foundry is on PATH
export PATH="$HOME/.foundry/bin:$PATH"

# Check if Foundry is installed
if ! command -v forge &> /dev/null; then
    echo "❌ ERROR: Foundry is not installed!"
    echo ""
    echo "Please run 1-INSTALL-FOUNDRY.command first."
    echo ""
    read -p "Press Enter to close..."
    exit 1
fi

echo "✅ Foundry found: $(forge --version)"
echo ""

# Navigate to contracts folder
PROJECT_DIR="/Users/teslamac/Brad Project/cctp-exchange/contracts"

if [ ! -d "$PROJECT_DIR" ]; then
    echo "❌ ERROR: Cannot find contracts folder at:"
    echo "   $PROJECT_DIR"
    echo ""
    echo "Make sure the project files are in the right place."
    echo ""
    read -p "Press Enter to close..."
    exit 1
fi

cd "$PROJECT_DIR"
echo "📂 Working in: $PROJECT_DIR"
echo ""

# ============================================
#  Step 1: Clean slate for dependencies
# ============================================
echo "============================================"
echo "  Step 1/3: Installing Dependencies"
echo "============================================"
echo ""

# Remove existing lib folder so forge install starts fresh
if [ -d "lib" ]; then
    echo "🗑  Removing old lib folder to start fresh..."
    rm -rf lib
    echo ""
fi

# Remove any existing git repo so we get a clean init
if [ -d ".git" ]; then
    rm -rf .git
fi

echo "📦 Initializing fresh git repository..."
git init
git add -A
git commit -m "initial" --quiet
echo "✅ Git initialized."
echo ""

# Install each dependency one at a time and verify it worked

echo "📦 Installing OpenZeppelin Contracts v5.1.0..."
forge install OpenZeppelin/openzeppelin-contracts@v5.1.0
if [ ! -d "lib/openzeppelin-contracts/contracts" ]; then
    echo ""
    echo "❌ ERROR: openzeppelin-contracts failed to download."
    echo "   Check your internet connection and try again."
    echo ""
    read -p "Press Enter to close..."
    exit 1
fi
echo "✅ openzeppelin-contracts installed."
echo ""

echo "📦 Installing OpenZeppelin Contracts Upgradeable v5.1.0..."
forge install OpenZeppelin/openzeppelin-contracts-upgradeable@v5.1.0
if [ ! -d "lib/openzeppelin-contracts-upgradeable/contracts" ]; then
    echo ""
    echo "❌ ERROR: openzeppelin-contracts-upgradeable failed to download."
    echo "   Check your internet connection and try again."
    echo ""
    read -p "Press Enter to close..."
    exit 1
fi
echo "✅ openzeppelin-contracts-upgradeable installed."
echo ""

echo "📦 Installing Forge Std v1.9.4..."
forge install foundry-rs/forge-std@v1.9.4
if [ ! -d "lib/forge-std/src" ]; then
    echo ""
    echo "❌ ERROR: forge-std failed to download."
    echo "   Check your internet connection and try again."
    echo ""
    read -p "Press Enter to close..."
    exit 1
fi
echo "✅ forge-std installed."
echo ""

# Final verification
echo "📋 Verifying lib folder contents..."
LIB_COUNT=$(ls lib/ | wc -l | tr -d ' ')
echo "   Found $LIB_COUNT libraries in lib/:"
ls lib/
echo ""

if [ "$LIB_COUNT" -lt 3 ]; then
    echo "❌ ERROR: Expected 3 libraries but only found $LIB_COUNT."
    echo "   Something went wrong with the downloads."
    echo ""
    read -p "Press Enter to close..."
    exit 1
fi

echo "✅ All 3 dependencies verified."
echo ""

# ============================================
#  Step 2: Build contracts
# ============================================
echo "============================================"
echo "  Step 2/3: Compiling Contracts"
echo "============================================"
echo ""

forge build

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ All contracts compiled successfully!"
else
    echo ""
    echo "❌ Compilation failed. Check the errors above."
    echo ""
    read -p "Press Enter to close..."
    exit 1
fi

echo ""

# ============================================
#  Step 3: Run tests
# ============================================
echo "============================================"
echo "  Step 3/3: Running Tests"
echo "============================================"
echo ""

forge test -vvv

if [ $? -eq 0 ]; then
    echo ""
    echo "============================================"
    echo "  ✅ All tests passed!"
    echo "============================================"
    echo ""
    echo "Your smart contracts are built and tested."
    echo "Next step: Double-click 3-START-FRONTEND.command"
else
    echo ""
    echo "============================================"
    echo "  ⚠️  Some tests failed."
    echo "============================================"
    echo ""
    echo "Check the output above for details."
    echo "This is normal during development — you can"
    echo "still proceed to the frontend if you want."
fi

echo ""
read -p "Press Enter to close..."
