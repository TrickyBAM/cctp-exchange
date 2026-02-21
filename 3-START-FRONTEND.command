#!/bin/bash

##################################################
#  CCTP Exchange — Step 3: Start Frontend        #
##################################################

clear
echo "============================================"
echo "  CCTP Exchange — Starting Frontend"
echo "============================================"
echo ""

# Navigate to frontend folder
PROJECT_DIR="/Users/teslamac/Brad Project/cctp-exchange/frontend"

if [ ! -d "$PROJECT_DIR" ]; then
    echo "❌ ERROR: Cannot find frontend folder at:"
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

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo "❌ ERROR: Node.js is not installed!"
    echo ""
    echo "Please install Node.js first:"
    echo "  1. Go to https://nodejs.org"
    echo "  2. Download the LTS version"
    echo "  3. Run the installer"
    echo "  4. Then double-click this script again"
    echo ""
    read -p "Press Enter to close..."
    exit 1
fi

echo "✅ Node.js found: $(node --version)"
echo ""

# Check for WalletConnect Project ID
ENV_FILE="$PROJECT_DIR/.env.local"
if [ -f "$ENV_FILE" ]; then
    if grep -q "YOUR_WALLETCONNECT_PROJECT_ID" "$ENV_FILE"; then
        echo "⚠️  WARNING: WalletConnect Project ID not set!"
        echo ""
        echo "The app will load but wallet connections won't work"
        echo "until you add your WalletConnect Project ID."
        echo ""
        echo "See the WALLETCONNECT-SETUP.md file for instructions."
        echo ""
        echo "Continuing anyway in 5 seconds..."
        sleep 5
    fi
fi

# Install dependencies
echo "============================================"
echo "  Step 1/2: Installing Dependencies"
echo "============================================"
echo ""
echo "This may take a minute or two..."
echo ""

npm install --ignore-scripts 2>&1

if [ $? -ne 0 ]; then
    echo ""
    echo "❌ npm install failed. Check the errors above."
    echo ""
    read -p "Press Enter to close..."
    exit 1
fi

echo ""
echo "✅ Dependencies installed."
echo ""

# Start the dev server
echo "============================================"
echo "  Step 2/2: Starting Development Server"
echo "============================================"
echo ""
echo "🚀 Starting CCTP Exchange at http://localhost:3000"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  The app is running! Keep this window open."
echo "  To stop it, close this window or press Ctrl+C."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Now double-click 4-OPEN-BROWSER.command to view it."
echo ""

npm run dev
