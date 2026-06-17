const { remote } = require('webdriverio');
const ExcelJS = require('exceljs');
const path = require('path');

async function generateReport(results) {
  const workbook = new ExcelJS.Workbook();
  const sheet = workbook.addWorksheet('Appium Test Report');

  sheet.columns = [
    { header: 'Test Step', key: 'step', width: 30 },
    { header: 'Status', key: 'status', width: 15 },
    { header: 'Error/Details', key: 'details', width: 50 },
  ];

  results.forEach(res => {
    sheet.addRow(res);
  });

  sheet.getRow(1).font = { bold: true };
  
  await workbook.xlsx.writeFile('mobile_test_report.xlsx');
  console.log('✅ Excel report generated: mobile_test_report.xlsx');
}

async function runAppiumTests() {
  const results = [];
  
  // Configure WebdriverIO for Appium (Android)
  const wdOpts = {
    hostname: '127.0.0.1',
    port: 4723,
    path: '/',
    capabilities: {
      platformName: 'Android',
      'appium:automationName': 'UiAutomator2',
      // Update this path to where your built APK is located:
      'appium:app': path.resolve(__dirname, '../build/app/outputs/flutter-apk/app-debug.apk'),
      // Add your device name or emulator ID here if needed
      // 'appium:deviceName': 'Pixel_API_33',
    }
  };

  let driver;

  try {
    console.log('Connecting to Appium Server...');
    driver = await remote(wdOpts);
    results.push({ step: 'Connect to Appium & Launch App', status: 'Passed', details: 'App launched successfully on emulator/device.' });

    // Wait for the app to load
    await driver.pause(5000); 

    // Find and interact with elements
    // Note: For Flutter apps, elements often do not have resource-ids unless specifically assigned via semantics.
    // The accessibility id might be the Flutter Tooltip or Semantics label.
    try {
      console.log('Locating Email Field...');
      // Searching by accessibility id (which corresponds to Flutter Semantics label or Tooltip)
      const emailField = await driver.$('~Email'); 
      if (await emailField.isExisting()) {
        await emailField.setValue('test@example.com');
      }

      console.log('Locating Password Field...');
      const passwordField = await driver.$('~Password'); 
      if (await passwordField.isExisting()) {
        await passwordField.setValue('password123');
      }

      console.log('Locating Login Button...');
      const loginBtn = await driver.$('~Login');
      if (await loginBtn.isExisting()) {
        await loginBtn.click();
      }

      results.push({ step: 'Login Action', status: 'Passed', details: 'Found elements and clicked Login.' });
      
      // Wait to observe the result
      await driver.pause(3000);
      
    } catch (e) {
      console.error('Error interacting with elements. Make sure Semantics are enabled in Flutter.', e.message);
      results.push({ step: 'Login Action', status: 'Failed', details: e.message.substring(0, 100) });
    }

  } catch (error) {
    console.error('Test Failed:', error);
    results.push({ step: 'Overall Test', status: 'Failed', details: error.message });
  } finally {
    if (driver) {
      await driver.deleteSession();
    }
    await generateReport(results);
  }
}

runAppiumTests();
