#!/bin/bash

##################################################
#  CCTP Valid — Step 4: Open in Browser       #
##################################################

clear
echo "============================================"
echo "  CCTP Valid — Opening Browser"
echo "============================================"
echo ""

# Check if the server is running
echo "Checking if the frontend is running..."
echo ""

if curl -s -o /dev/null -w "%{http_code}" http://localhost:3000 | grep -q "200\|302\|304"; then
    echo "✅ Frontend is running!"
    echo ""
    echo "Opening http://localhost:3000 in your browser..."
    open http://localhost:3000
    echo ""
    echo "============================================"
    echo "  ✅ Done! Check your browser."
    echo "============================================"
else
    echo "⚠️  The frontend doesn't seem to be running yet."
    echo ""
    echo "Make sure you:"
    echo "  1. Double-clicked 3-START-FRONTEND.command first"
    echo "  2. Left that window open (it runs the server)"
    echo "  3. Waited for it to say 'Ready' or 'started'"
    echo ""
    echo "Trying to open the browser anyway..."
    open http://localhost:3000
    echo ""
    echo "If you see an error in the browser, go back and"
    echo "make sure Step 3 is running first."
fi

echo ""
read -p "Press Enter to close..."
