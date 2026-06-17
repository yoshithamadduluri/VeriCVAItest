const { Builder, By, until } = require('selenium-webdriver');
const ExcelJS = require('exceljs');
const fs = require('fs');

async function generateReport(results) {
  const workbook = new ExcelJS.Workbook();
  const sheet = workbook.addWorksheet('Selenium Test Report');

  sheet.columns = [
    { header: 'Test Step', key: 'step', width: 30 },
    { header: 'Status', key: 'status', width: 15 },
    { header: 'Error/Details', key: 'details', width: 50 },
  ];

  results.forEach(res => {
    sheet.addRow(res);
  });

  // Apply basic styling
  sheet.getRow(1).font = { bold: true };
  
  await workbook.xlsx.writeFile('web_test_report.xlsx');
  console.log('✅ Excel report generated: web_test_report.xlsx');
}

const chrome = require('selenium-webdriver/chrome');

async function runSeleniumTests() {
  const results = [];
  
  // Configure Chrome options for headless environment (CI)
  let options = new chrome.Options();
  options.addArguments('--headless=new');
  options.addArguments('--no-sandbox');
  options.addArguments('--disable-dev-shm-usage');

  let driver = await new Builder()
    .forBrowser('chrome')
    .setChromeOptions(options)
    .build();

  try {
    results.push({ step: 'Launch Browser', status: 'Passed', details: 'Chrome launched successfully.' });

    // 1. Navigate to the local Flutter Web App
    // Note: Change this URL to your actual local or hosted web URL
    const appUrl = 'http://localhost:8080/'; 
    console.log(`Navigating to ${appUrl}`);
    await driver.get(appUrl);
    results.push({ step: 'Navigate to App', status: 'Passed', details: `Opened ${appUrl}` });

    // Wait for Flutter to load (Canvas or Semantic elements to appear)
    // We are waiting for a generic element here. Adjust the selector to match your actual app!
    await driver.sleep(5000); // Wait 5 seconds for Flutter to initialize
    
    // 2. Perform Login Test
    // For Flutter, you need to use semantic labels if testing Canvas, or standard IDs if using HTML renderer.
    // Example using standard CSS selectors (update based on your app's DOM):
    try {
      console.log('Attempting to find Login inputs...');
      
      // Look for inputs (these selectors depend on how Flutter renders your app, Semantic labels might render as aria-labels)
      let emailInput = await driver.findElement(By.css('input[type="email"], input[aria-label="Email"]'));
      await emailInput.sendKeys('test@example.com');
      
      let passwordInput = await driver.findElement(By.css('input[type="password"], input[aria-label="Password"]'));
      await passwordInput.sendKeys('password123');

      // Look for the Login button
      let loginBtn = await driver.findElement(By.xpath('//flt-semantics[@aria-label="Login"] | //button[contains(text(),"Login")]'));
      await loginBtn.click();
      
      results.push({ step: 'Login Action', status: 'Passed', details: 'Entered credentials and clicked Login.' });
      
      // Wait for navigation
      await driver.sleep(3000);
      
    } catch (e) {
      console.error('Error finding elements. Note: Flutter apps might require specific semantic labels for Selenium to find them.', e.message);
      results.push({ step: 'Login Action', status: 'Failed', details: e.message.substring(0, 100) });
    }

  } catch (error) {
    console.error('Test Failed:', error);
    results.push({ step: 'Overall Test', status: 'Failed', details: error.message });
  } finally {
    // 3. Generate Report
    await generateReport(results);
    
    // Quit browser
    await driver.quit();
  }
}

runSeleniumTests();
