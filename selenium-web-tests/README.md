# VeriCV AI – Selenium E2E Web Tests

> **Node.js · selenium-webdriver · ExcelJS**  
> 120 test cases across 12 categories with automated Excel report generation.

## 📁 Folder Structure

```
selenium-web-tests/
├── test.js              # Main test runner (entry point)
├── test-cases.js        # All 120 test case definitions
├── report-generator.js  # Excel report builder (3-sheet workbook)
├── package.json         # Node.js dependencies
├── README.md            # This file
└── reports/
    └── screenshots/     # Auto-captured screenshots (on failure)
```

## 🧪 Test Categories (120 Total)

| # | Category | Cases |
|---|----------|-------|
| 1 | Page Load & Rendering | 10 |
| 2 | Authentication – Login | 10 |
| 3 | Authentication – Signup | 10 |
| 4 | Dashboard Screen | 10 |
| 5 | Resume Upload Screen | 10 |
| 6 | Mock Interview Screen | 10 |
| 7 | Profile Screen | 10 |
| 8 | UI & Visual Regression | 10 |
| 9 | Navigation & Routing | 10 |
| 10 | Performance Testing | 10 |
| 11 | Accessibility Testing | 10 |
| 12 | End-to-End Flow Testing | 10 |

## 🚀 Running Locally (Windows)

### ✅ Option 1 — One-Click Launcher (Easiest)
Right-click `run-tests.ps1` → **Run with PowerShell**

Or from PowerShell terminal:
```powershell
cd selenium-web-tests

# Live browser preview (headed) — DEFAULT
.\run-tests.ps1

# Headless (no browser window) — for CI
.\run-tests.ps1 -Headless

# Run a single test by ID
.\run-tests.ps1 -Id STC001

# Run all tests in one category
.\run-tests.ps1 -Category "End-to-End Flow Testing"
```

### ✅ Option 2 — Using Full Node Path (if npm not in PATH)
```powershell
cd selenium-web-tests

# Install dependencies (first time only)
& "C:\Program Files\nodejs\npm.cmd" install

# Run tests with live browser
& "C:\Program Files\nodejs\node.exe" test.js

# Run headless
& "C:\Program Files\nodejs\node.exe" test.js --headless

# Run single test
& "C:\Program Files\nodejs\node.exe" test.js --id STC001
```

### ✅ Option 3 — After Restarting Terminal (PATH is now fixed)
```powershell
cd selenium-web-tests
npm install        # first time only
npm test           # headed (live browser)
npm run test:headed
```

## 📊 Excel Report

The report is saved as `selenium_report.xlsx` with **3 worksheets**:

- **📊 Summary** – Pass rate, totals, per-category breakdown
- **🧪 Test Results** – All 120 rows, color-coded by category & status
- **❌ Failed Tests** – Only failed cases with error details

## ⚙️ CI/CD (GitHub Actions)

Triggered automatically on every push/PR to `main`. The workflow:
1. Builds Flutter web app
2. Serves it on `localhost:8080`
3. Runs `npm test` inside this folder
4. Uploads `selenium_report.xlsx` as an artifact

## Requirements

- Node.js ≥ 18
- Google Chrome (latest stable)
- ChromeDriver (auto-managed via `chromedriver` npm package)
