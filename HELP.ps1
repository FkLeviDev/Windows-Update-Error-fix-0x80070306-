# ================================================================
#  WUFIX - Windows Update Manager by Predox | FKLEVI Dev
#  Revised version: Pure ASCII/English Script with Auto-Reboot
# ================================================================

# --- Administrator Privilege Check (PowerShell) ---
function Test-Administrator {
    $current = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($current)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

if (-not (Test-Administrator)) {
    Write-Host "[ERROR] This script must be run with Administrator privileges!" -ForegroundColor Red
    Write-Host "Attempting to relaunch with Administrator rights..."

    # Relaunches the script in Administrator mode
    Start-Process powershell.exe -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$($MyInvocation.MyCommand.Path)`"" -Verb RunAs
    exit
}

# --- Colors and Title Setup ---
$Host.UI.RawUI.WindowTitle = "WUFIX - Windows Update Manager by Predox | FKLEVI Dev"
# Sets the color to Green (0A in Batch)
$Host.PrivateData.WarningForegroundColor = "Green"
Clear-Host

# --- Script Header (ASCII art) ---
Write-Host ""
Write-Host " #####################################################################" -ForegroundColor Green
Write-Host " #                                                                   #" -ForegroundColor Green
Write-Host " #        __     __ _ _  __ _____  _  _  _____ __  __              #" -ForegroundColor Green
Write-Host " #        \ \   / /| | |/ /|  __ \| | | ||  ___|\ \/ /              #" -ForegroundColor Green
Write-Host " #         \ \ / / | | ' / | |__) | |_| || |__    \  /               #" -ForegroundColor Green
Write-Host " #          \ \/ /  | |  <  |  ___/|  _  ||  __|  / /                #" -ForegroundColor Green
Write-Host " #           \  /   | | . \ | |    | | | || |____/ /                 #" -ForegroundColor Green
Write-Host " #            \/    |_|_|\_\|_|    |_| |_||______/_/                 #" -ForegroundColor Green
Write-Host " #                                                                   #" -ForegroundColor Green
Write-Host " #              Windows Update Fix Utility (0x80070306)              #" -ForegroundColor Green
Write-Host " #                  ** by Predox | FKLEVI Dev ** #" -ForegroundColor Green
Write-Host " #                                                                   #" -ForegroundColor Green
Write-Host " #####################################################################" -ForegroundColor Green
Write-Host ""
Write-Host "Welcome to the WUFIX Manager!"
Write-Host "This script will attempt to repair corrupted system files and reset"
Write-Host "Windows Update components to resolve error 0x80070306."
Write-Host ""
Pause

# -------------------------------------------------------------------

Write-Host ""
Write-Host "[1/6] Stopping essential Windows Update services..." -ForegroundColor Yellow
Stop-Service -Name wuauserv -ErrorAction SilentlyContinue
Stop-Service -Name cryptSvc -ErrorAction SilentlyContinue
Stop-Service -Name bits -ErrorAction SilentlyContinue
Stop-Service -Name msiserver -ErrorAction SilentlyContinue
Write-Host ""

Write-Host ""
Write-Host "[2/6] Renaming corrupted Update cache folders..." -ForegroundColor Yellow
# Rename SoftwareDistribution and catroot2 folders
if (Test-Path "C:\Windows\SoftwareDistribution") {
    Rename-Item -Path "C:\Windows\SoftwareDistribution" -NewName "SoftwareDistribution.old" -ErrorAction SilentlyContinue
    Write-Host "  -> SoftwareDistribution folder renamed."
}
if (Test-Path "C:\Windows\System32\catroot2") {
    Rename-Item -Path "C:\Windows\System32\catroot2" -NewName "Catroot2.old" -ErrorAction SilentlyContinue
    Write-Host "  -> catroot2 folder renamed."
}
Write-Host ""

Write-Host ""
Write-Host "[3/6] Running DISM /RestoreHealth to repair the Windows Image Store (This may take a few minutes)..." -ForegroundColor Yellow
& dism /Online /Cleanup-Image /RestoreHealth
Write-Host ""

Write-Host ""
Write-Host "[4/6] Running SFC /SCANNOW to check and repair critical system files..." -ForegroundColor Yellow
& sfc /scannow
Write-Host ""

Write-Host ""
Write-Host "[5/6] Starting essential Windows Update services..." -ForegroundColor Yellow
Start-Service -Name wuauserv -ErrorAction SilentlyContinue
Start-Service -Name cryptSvc -ErrorAction SilentlyContinue
Start-Service -Name bits -ErrorAction SilentlyContinue
Start-Service -Name msiserver -ErrorAction SilentlyContinue
Write-Host ""

# -------------------------------------------------------------------

Write-Host ""
Write-Host "[6/6] Scheduling post-reboot Windows Update scan and initiating reboot..." -ForegroundColor Yellow

# 1. SCHEDULE POST-REBOOT UPDATE SCAN (UsoClient is the modern tool)
# Creates a task to run the update scan on system startup (runs once, then deletes itself)
$TaskName = "WUFIX_PostReboot_Update"
$TaskAction = "C:\Windows\System32\cmd.exe /c UsoClient StartScan"

# Create a scheduled task to run UsoClient StartScan once at system startup
& schtasks /create /tn $TaskName /tr $TaskAction /sc ONSTART /rl HIGHEST /f | Out-Null
if ($LASTEXITCODE -eq 0) {
    Write-Host "  -> Scheduled task created to run Windows Update Scan on next startup."
} else {
    Write-Host "  -> WARNING: Failed to create scheduled task for update scan." -ForegroundColor Yellow
}

# 2. FINAL MESSAGE AND REBOOT
# Final screen color: White (07 in Batch)
$Host.PrivateData.WarningForegroundColor = "White"

Write-Host " #####################################################################" -ForegroundColor White
Write-Host " #                                                                   #" -ForegroundColor White
Write-Host " #                    ** PROCESS COMPLETE! ** #" -ForegroundColor White
Write-Host " #                                                                   #" -ForegroundColor White
Write-Host " #  ** Action Required: REBOOTING NOW. Windows Update will start ** #" -ForegroundColor White
Write-Host " #  ** automatically after restart.** #" -ForegroundColor White
Write-Host " #                                                                   #" -ForegroundColor White
Write-Host " #####################################################################" -ForegroundColor White
Write-Host ""

# Reboot the computer immediately and forcefully
Write-Host "Restarting computer in 5 seconds..."
Start-Sleep -Seconds 5
Restart-Computer -Force

exit