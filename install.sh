#!/bin/bash
# grugbot420 Unix Installer (Linux/macOS)
# One-click install. No complexity.
#
# Usage:
#   curl -fsSL https://grug.sh/install.sh | bash

set -e

echo ""
echo "  �� grugbot420 Installer"
echo "  ========================"
echo ""

# Check if Bun is installed
if ! command -v bun &> /dev/null; then
    echo "  📦 Installing Bun..."
    curl -fsSL https://bun.sh/install | bash
    
    # Source bun
    export BUN_INSTALL="$HOME/.bun"
    export PATH="$BUN_INSTALL/bin:$PATH"
    
    echo "  ✅ Bun installed!"
else
    echo "  ✅ Bun already installed"
fi

# Create grug directory
GRUG_DIR="$HOME/.grug"
mkdir -p "$GRUG_DIR"

echo "  📥 Downloading grugbot-server..."

# Clone or update repo
REPO_DIR="$GRUG_DIR/grugbot-server"
if [ -d "$REPO_DIR" ]; then
    cd "$REPO_DIR"
    git pull --quiet
    echo "  ✅ Updated grugbot-server"
else
    git clone --quiet https://github.com/grug-group420/grugbot-server.git "$REPO_DIR"
    echo "  ✅ Downloaded grugbot-server"
fi

# Create start script
cat > "$GRUG_DIR/start-grug.sh" << 'SCRIPT'
#!/bin/bash
cd "$HOME/.grug/grugbot-server"
echo ""
echo "  🤖 Starting grugbot420..."
echo "  Open http://localhost:3420 in your browser"
echo ""
bun run serve
SCRIPT
chmod +x "$GRUG_DIR/start-grug.sh"

# Create alias
SHELL_RC=""
if [ -f "$HOME/.zshrc" ]; then
    SHELL_RC="$HOME/.zshrc"
elif [ -f "$HOME/.bashrc" ]; then
    SHELL_RC="$HOME/.bashrc"
fi

if [ -n "$SHELL_RC" ]; then
    if ! grep -q "alias grug=" "$SHELL_RC"; then
        echo "" >> "$SHELL_RC"
        echo "# grugbot420" >> "$SHELL_RC"
        echo "alias grug='~/.grug/start-grug.sh'" >> "$SHELL_RC"
        echo "  ✅ Added 'grug' alias"
    fi
fi

echo ""
echo "  ========================================"
echo "  🎉 grugbot420 installed!"
echo "  ========================================"
echo ""
echo "  To start:"
echo "    • Run: grug"
echo "    • Or: ~/.grug/start-grug.sh"
echo "    • Or: cd ~/.grug/grugbot-server && bun run serve"
echo ""
echo "  Then open: http://localhost:3420"
echo ""
echo "  🦴 Complexity is the enemy. Ship code."
echo ""

# Ask to start now
read -p "  Start grugbot420 now? (Y/n) " response
if [ "$response" != "n" ] && [ "$response" != "N" ]; then
    cd "$REPO_DIR"
    # Try to open browser
    if command -v xdg-open &> /dev/null; then
        xdg-open "http://localhost:3420" &
    elif command -v open &> /dev/null; then
        open "http://localhost:3420" &
    fi
    bun run serve
fi
