# grugbot420 Windows Installer
# One-click install. No complexity.
# 
# Usage: 
#   irm https://grug.sh/install | iex
#   or
#   .\install.ps1

$ErrorActionPreference = "Stop"

Write-Host ""
Write-Host "  🦴 grugbot420 Installer" -ForegroundColor Green
Write-Host "  ========================" -ForegroundColor Green
Write-Host ""

# Check if Bun is installed
$bunPath = Get-Command bun -ErrorAction SilentlyContinue

if (-not $bunPath) {
    Write-Host "  📦 Installing Bun..." -ForegroundColor Yellow
    
    # Install Bun
    try {
        powershell -c "irm bun.sh/install.ps1 | iex"
        
        # Refresh PATH
        $env:BUN_INSTALL = "$env:USERPROFILE\.bun"
        $env:PATH = "$env:BUN_INSTALL\bin;$env:PATH"
        
        Write-Host "  ✅ Bun installed!" -ForegroundColor Green
    } catch {
        Write-Host "  ❌ Failed to install Bun. Try manually: irm bun.sh/install.ps1 | iex" -ForegroundColor Red
        exit 1
    }
} else {
    Write-Host "  ✅ Bun already installed" -ForegroundColor Green
}

# Create grug directory
$grugDir = "$env:USERPROFILE\.grug"
if (-not (Test-Path $grugDir)) {
    New-Item -ItemType Directory -Path $grugDir | Out-Null
}

Write-Host "  📥 Downloading grugbot-server..." -ForegroundColor Yellow

# Clone or update repo
$repoDir = "$grugDir\grugbot-server"
if (Test-Path $repoDir) {
    Set-Location $repoDir
    git pull --quiet
    Write-Host "  ✅ Updated grugbot-server" -ForegroundColor Green
} else {
    git clone --quiet https://github.com/grug-group420/grugbot-server.git $repoDir
    Write-Host "  ✅ Downloaded grugbot-server" -ForegroundColor Green
}

# Create desktop shortcut
$shortcutPath = "$env:USERPROFILE\Desktop\grugbot420.lnk"
$WshShell = New-Object -ComObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut($shortcutPath)
$Shortcut.TargetPath = "cmd.exe"
$Shortcut.Arguments = "/c cd /d `"$repoDir`" && bun run serve && pause"
$Shortcut.WorkingDirectory = $repoDir
$Shortcut.Description = "Start grugbot420 server"
$Shortcut.Save()

Write-Host "  ✅ Created desktop shortcut" -ForegroundColor Green

# Create start script
$startScript = @"
@echo off
cd /d "$repoDir"
echo.
echo   🤖 Starting grugbot420...
echo   Open http://localhost:3420 in your browser
echo.
bun run serve
pause
"@
$startScript | Out-File -FilePath "$grugDir\start-grug.bat" -Encoding ASCII

Write-Host ""
Write-Host "  ========================================" -ForegroundColor Green
Write-Host "  🎉 grugbot420 installed!" -ForegroundColor Green
Write-Host "  ========================================" -ForegroundColor Green
Write-Host ""
Write-Host "  To start:" -ForegroundColor Cyan
Write-Host "    • Double-click 'grugbot420' on your desktop" -ForegroundColor White
Write-Host "    • Or run: cd ~/.grug/grugbot-server && bun run serve" -ForegroundColor White
Write-Host ""
Write-Host "  Then open: http://localhost:3420" -ForegroundColor Cyan
Write-Host ""
Write-Host "  🦴 Complexity is the enemy. Ship code." -ForegroundColor DarkGray
Write-Host ""

# Ask to start now
$response = Read-Host "  Start grugbot420 now? (Y/n)"
if ($response -ne "n" -and $response -ne "N") {
    Set-Location $repoDir
    Start-Process "http://localhost:3420"
    bun run serve
}
