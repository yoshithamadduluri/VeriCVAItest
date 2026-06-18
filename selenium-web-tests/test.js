const { runSeleniumTests } = require('./runner');

console.log('🚀 Running Selenium Web Testing Suite via runner.js...');
runSeleniumTests().catch((err) => {
  console.error('Fatal error running tests:', err);
  process.exit(1);
});
