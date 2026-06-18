# ─────────────────────────────────────────────────────────────────
#  VeriCV AI – Selenium E2E Test Launcher
#  Double-click this file OR run from PowerShell:
#    .\run-tests.ps1              → headed (live browser)
#    .\run-tests.ps1 -Headless    → headless (no browser window)
#    .\run-tests.ps1 -Id STC001   → single test
# ─────────────────────────────────────────────────────────────────
param(
    [switch]$Headless,
    [string]$Id = "",
    [string]$Category = ""
)

# Always use full Node.js path to avoid PATH issues
$NODE = "C:\Program Files\nodejs\node.exe"
$NPM  = "C:\Program Files\nodejs\npm.cmd"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $ScriptDir

Write-Host ""
Write-Host "╔══════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║   VeriCV AI – Selenium E2E Test Launcher             ║" -ForegroundColor Cyan
Write-Host "╚══════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

# Install dependencies if node_modules is missing
if (-not (Test-Path "$ScriptDir\node_modules")) {
    Write-Host "📦 Installing dependencies..." -ForegroundColor Yellow
    & $NPM install
    Write-Host ""
}

# Build argument list
$args = @()
if ($Headless)  { $args += "--headless" }
if ($Id)        { $args += "--id"; $args += $Id }
if ($Category)  { $args += "--category"; $args += $Category }

Write-Host "🚀 Starting tests..." -ForegroundColor Green
Write-Host ""

& $NODE test.js @args

Write-Host ""
Write-Host "✅ Tests complete. Opening report..." -ForegroundColor Green

# Open the Excel report if it was generated
$report = "$ScriptDir\selenium_report.xlsx"
if (Test-Path $report) {
    Start-Process $report
    Write-Host "📊 Report opened: $report" -ForegroundColor Green
} else {
    Write-Host "⚠️  No report found at: $report" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Press any key to exit..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
