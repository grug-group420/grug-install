# 🦴 grugbot420 One-Click Installer

Install grugbot420 with a single command. No complexity.

## Windows

Open PowerShell and run:

```powershell
irm https://raw.githubusercontent.com/grug-group420/grug-install/main/install.ps1 | iex
```

**What it does:**
1. Installs Bun (if needed)
2. Downloads grugbot-server
3. Creates desktop shortcut
4. Starts the server

## Linux/macOS

Open terminal and run:

```bash
curl -fsSL https://raw.githubusercontent.com/grug-group420/grug-install/main/install.sh | bash
```

**What it does:**
1. Installs Bun (if needed)
2. Downloads grugbot-server
3. Adds `grug` command alias
4. Starts the server

## After Install

Just run:
- **Windows**: Double-click "grugbot420" on desktop
- **Linux/macOS**: Type `grug` in terminal

Then open http://localhost:3420

## Manual Install

If you prefer:

```bash
# 1. Install Bun
curl -fsSL https://bun.sh/install | bash

# 2. Clone repo
git clone https://github.com/grug-group420/grugbot-server.git
cd grugbot-server

# 3. Run
bun run serve
```

## Uninstall

```bash
# Remove grug directory
rm -rf ~/.grug

# Remove desktop shortcut (Windows)
# Delete grugbot420.lnk from Desktop
```

---

🦴 **grug-group420** | Complexity is the enemy
