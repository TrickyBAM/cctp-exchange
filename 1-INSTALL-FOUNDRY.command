#!/bin/bash

#############################################
#  CCTP Valid — Step 1: Install Foundry  #
#############################################

clear
echo "============================================"
echo "  CCTP Valid — Installing Foundry"
echo "============================================"
echo ""
echo "This will install Foundry (the Solidity toolkit)"
echo "on your Mac. You only need to run this ONCE."
echo ""
echo "Starting in 3 seconds..."
sleep 3

# Check if Foundry is already installed
if command -v forge &> /dev/null; then
    echo ""
    echo "✅ Foundry is already installed!"
    forge --version
    echo ""
    echo "Updating to latest version..."
    foundryup
    echo ""
    echo "============================================"
    echo "  ✅ Foundry is up to date!"
    echo "============================================"
    echo ""
    echo "You can close this window."
    echo "Next step: Double-click 2-BUILD-CONTRACTS.command"
    echo ""
    read -p "Press Enter to close..."
    exit 0
fi

# Check if curl is available
if ! command -v curl &> /dev/null; then
    echo "❌ ERROR: curl is not installed."
    echo "Please install Xcode Command Line Tools first by running:"
    echo "  xcode-select --install"
    echo ""
    read -p "Press Enter to close..."
    exit 1
fi

echo ""
echo "📦 Downloading Foundry installer..."
echo ""

# Download and run the Foundry installer
curl -L https://foundry.paradigm.xyz | bash

# Source the updated profile so foundryup is available
export PATH="$HOME/.foundry/bin:$PATH"

echo ""
echo "📦 Running foundryup to install forge, cast, anvil..."
echo ""

foundryup

# Verify installation
echo ""
if command -v forge &> /dev/null; then
    echo "============================================"
    echo "  ✅ Foundry installed successfully!"
    echo "============================================"
    echo ""
    forge --version
    echo ""
    echo "You can close this window."
    echo "Next step: Double-click 2-BUILD-CONTRACTS.command"
else
    echo "============================================"
    echo "  ❌ Something went wrong."
    echo "============================================"
    echo ""
    echo "Foundry might not be on your PATH yet."
    echo "Try closing ALL Terminal windows, then"
    echo "double-click this script again."
    echo ""
    echo "If it still fails, open Terminal and run:"
    echo "  curl -L https://foundry.paradigm.xyz | bash"
    echo "  foundryup"
fi

echo ""
read -p "Press Enter to close..."
