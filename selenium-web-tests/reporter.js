const ExcelJS = require('exceljs');
const path = require('path');

const CATEGORY_COLORS = {
  'Functional Testing':         { fill: 'FFE3F2FD', font: 'FF0D47A1' },
  'UI/UX Testing':              { fill: 'FFE8F5E9', font: 'FF1B5E20' },
  'Validation Testing':         { fill: 'FFFFF3E0', font: 'FFE65100' },
  'Unit Testing Integration':   { fill: 'FFF3E5F5', font: 'FF4A148C' },
  'Compatibility Testing':      { fill: 'FFE0F7FA', font: 'FF006064' },
  'Accessibility Testing':      { fill: 'FFFFF8E1', font: 'FFF57F17' },
  'Performance Testing':        { fill: 'FFEDE7F6', font: 'FF4A148C' },
  'End-to-End (E2E) Testing':   { fill: 'FFE1F5FE', font: 'FF01579B' },
};

async function generateReport(results) {
  const workbook = new ExcelJS.Workbook();
  workbook.creator = 'VeriCV AI Testing Pipeline';
  workbook.created = new Date();

  const sheet = workbook.addWorksheet('Web Test Report', {
    properties: { tabColor: { argb: 'FF4CAF50' } },
  });

  sheet.columns = [
    { header: '#',                key: 'num',       width: 6  },
    { header: 'Category',        key: 'category',  width: 28 },
    { header: 'Test Case ID',    key: 'id',        width: 14 },
    { header: 'Test Case Description', key: 'description', width: 55 },
    { header: 'Status',          key: 'status',    width: 12 },
    { header: 'Timestamp',       key: 'timestamp', width: 22 },
    { header: 'Error Details',   key: 'error',     width: 40 },
  ];

  const headerRow = sheet.getRow(1);
  headerRow.font = { bold: true, color: { argb: 'FFFFFFFF' }, size: 11 };
  headerRow.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: 'FF1565C0' } };
  headerRow.alignment = { vertical: 'middle', horizontal: 'center' };
  headerRow.height = 28;

  results.forEach((r, i) => {
    const row = sheet.addRow({
      num: i + 1,
      category: r.category,
      id: r.id,
      description: r.description,
      status: r.status,
      timestamp: r.timestamp,
      error: r.error || 'N/A'
    });

    const colors = CATEGORY_COLORS[r.category];
    if (colors) {
      row.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: colors.fill } };
    }

    const statusCell = row.getCell('status');
    if (r.status === 'PASS') {
      statusCell.font = { bold: true, color: { argb: 'FF1B5E20' } };
      statusCell.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: 'FFC8E6C9' } };
    } else {
      statusCell.font = { bold: true, color: { argb: 'FFB71C1C' } };
      statusCell.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: 'FFFFCDD2' } };
    }
    statusCell.alignment = { horizontal: 'center' };

    row.getCell('num').alignment = { horizontal: 'center' };
    row.getCell('id').alignment = { horizontal: 'center' };
    row.getCell('timestamp').alignment = { horizontal: 'center' };
  });

  sheet.eachRow((row) => {
    row.eachCell((cell) => {
      cell.border = {
        top: { style: 'thin' }, bottom: { style: 'thin' },
        left: { style: 'thin' }, right: { style: 'thin' },
      };
    });
  });

  sheet.autoFilter = { from: 'A1', to: 'G1' };

  const reportPath = path.join(__dirname, 'selenium_report.xlsx');
  await workbook.xlsx.writeFile(reportPath);
  console.log(`\n✅ Selenium Excel report generated: ${reportPath} (105 test cases)`);
}

module.exports = { generateReport };
