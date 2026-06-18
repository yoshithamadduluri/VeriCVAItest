const ExcelJS = require('exceljs');
const path = require('path');
const fs = require('fs');

const { CATEGORY_COLORS } = require('./test-cases');

async function generateExcelReport(results, outputPath) {
  const workbook = new ExcelJS.Workbook();
  workbook.creator = 'VeriCV AI Selenium Pipeline';
  workbook.created = new Date();

  // ── Sheet 1: Summary Dashboard ──────────────────────────────────
  const summary = workbook.addWorksheet('📊 Summary', {
    properties: { tabColor: { argb: 'FF6200EE' } },
  });

  const total  = results.length;
  const passed = results.filter(r => r.status === 'PASS').length;
  const failed = results.filter(r => r.status === 'FAIL').length;
  const skipped = results.filter(r => r.status === 'SKIP').length;
  const passRate = total > 0 ? ((passed / total) * 100).toFixed(1) : 0;

  summary.columns = [
    { key: 'label', width: 32 },
    { key: 'value', width: 20 },
  ];

  const titleRow = summary.addRow(['VeriCV AI – Selenium E2E Test Report', '']);
  titleRow.font = { bold: true, size: 16, color: { argb: 'FFFFFFFF' } };
  titleRow.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: 'FF6200EE' } };
  titleRow.height = 36;
  summary.mergeCells('A1:B1');
  titleRow.alignment = { horizontal: 'center', vertical: 'middle' };

  summary.addRow([]);

  const metaRows = [
    ['Run Date', new Date().toLocaleString('en-IN', { timeZone: 'Asia/Kolkata' })],
    ['Total Test Cases', total],
    ['✅ Passed', passed],
    ['❌ Failed', failed],
    ['⏭ Skipped', skipped],
    ['Pass Rate', `${passRate}%`],
  ];

  metaRows.forEach(([label, value]) => {
    const r = summary.addRow({ label, value });
    r.getCell('label').font = { bold: true, color: { argb: 'FF37474F' } };
    r.getCell('value').alignment = { horizontal: 'center' };
    const argb = label.includes('✅') ? 'FFC8E6C9'
               : label.includes('❌') ? 'FFFFCDD2'
               : label.includes('Pass Rate') ? 'FFE1F5FE'
               : 'FFF5F5F5';
    r.eachCell(c => {
      c.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb } };
      c.border = {
        top: { style: 'thin' }, bottom: { style: 'thin' },
        left: { style: 'thin' }, right: { style: 'thin' },
      };
    });
  });

  summary.addRow([]);

  // Category breakdown
  const catHeader = summary.addRow(['Category', 'Total | Pass | Fail']);
  catHeader.font = { bold: true, color: { argb: 'FFFFFFFF' } };
  catHeader.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: 'FF37474F' } };
  catHeader.eachCell(c => c.alignment = { horizontal: 'center' });

  const cats = {};
  results.forEach(r => {
    if (!cats[r.category]) cats[r.category] = { total: 0, pass: 0, fail: 0 };
    cats[r.category].total++;
    if (r.status === 'PASS') cats[r.category].pass++;
    if (r.status === 'FAIL') cats[r.category].fail++;
  });

  Object.entries(cats).forEach(([cat, c]) => {
    const cr = summary.addRow([cat, `${c.total} | ${c.pass} | ${c.fail}`]);
    const colors = CATEGORY_COLORS[cat];
    if (colors) {
      cr.eachCell(cell => {
        cell.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: colors.fill } };
        cell.font = { color: { argb: colors.font } };
        cell.border = {
          top: { style: 'thin' }, bottom: { style: 'thin' },
          left: { style: 'thin' }, right: { style: 'thin' },
        };
      });
    }
    cr.getCell('B').alignment = { horizontal: 'center' };
  });

  // ── Sheet 2: All Test Results ────────────────────────────────────
  const sheet = workbook.addWorksheet('🧪 Test Results', {
    properties: { tabColor: { argb: 'FF4CAF50' } },
    views: [{ state: 'frozen', ySplit: 1 }],
  });

  sheet.columns = [
    { header: '#',           key: 'num',         width: 6  },
    { header: 'Category',   key: 'category',    width: 30 },
    { header: 'Test ID',    key: 'id',           width: 12 },
    { header: 'Description',key: 'description', width: 70 },
    { header: 'Status',     key: 'status',      width: 10 },
    { header: 'Duration',   key: 'duration',    width: 12 },
    { header: 'Timestamp',  key: 'timestamp',   width: 26 },
    { header: 'Error',      key: 'error',       width: 50 },
  ];

  const hdr = sheet.getRow(1);
  hdr.font   = { bold: true, color: { argb: 'FFFFFFFF' }, size: 11 };
  hdr.fill   = { type: 'pattern', pattern: 'solid', fgColor: { argb: 'FF6200EE' } };
  hdr.height = 28;
  hdr.alignment = { vertical: 'middle', horizontal: 'center' };

  results.forEach((r, i) => {
    const row = sheet.addRow({
      num: i + 1, category: r.category, id: r.id,
      description: r.description, status: r.status,
      duration: r.duration ? `${r.duration}ms` : 'N/A',
      timestamp: r.timestamp, error: r.error || '',
    });

    const colors = CATEGORY_COLORS[r.category];
    if (colors) row.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: colors.fill } };

    const sc = row.getCell('status');
    const isPass = r.status === 'PASS';
    const isFail = r.status === 'FAIL';
    sc.font = { bold: true, color: { argb: isPass ? 'FF1B5E20' : isFail ? 'FFB71C1C' : 'FF37474F' } };
    sc.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: isPass ? 'FFC8E6C9' : isFail ? 'FFFFCDD2' : 'FFFFF3E0' } };
    sc.alignment = { horizontal: 'center' };

    row.getCell('num').alignment      = { horizontal: 'center' };
    row.getCell('id').alignment       = { horizontal: 'center' };
    row.getCell('duration').alignment = { horizontal: 'center' };
    row.getCell('timestamp').alignment = { horizontal: 'center' };
    row.getCell('description').alignment = { wrapText: true };
    if (r.error) row.getCell('error').font = { color: { argb: 'FFB71C1C' } };

    row.eachCell(c => {
      c.border = {
        top: { style: 'thin' }, bottom: { style: 'thin' },
        left: { style: 'thin' }, right: { style: 'thin' },
      };
    });
  });

  sheet.autoFilter = { from: 'A1', to: 'H1' };

  // ── Sheet 3: Failed Tests ────────────────────────────────────────
  const failedResults = results.filter(r => r.status === 'FAIL');
  if (failedResults.length > 0) {
    const failSheet = workbook.addWorksheet('❌ Failed Tests', {
      properties: { tabColor: { argb: 'FFF44336' } },
      views: [{ state: 'frozen', ySplit: 1 }],
    });
    failSheet.columns = [
      { header: 'Test ID',    key: 'id',          width: 12 },
      { header: 'Category',  key: 'category',    width: 28 },
      { header: 'Description', key: 'description', width: 60 },
      { header: 'Error',     key: 'error',       width: 60 },
      { header: 'Timestamp', key: 'timestamp',   width: 26 },
    ];
    const fh = failSheet.getRow(1);
    fh.font = { bold: true, color: { argb: 'FFFFFFFF' } };
    fh.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: 'FFC62828' } };
    fh.height = 28;

    failedResults.forEach(r => {
      const row = failSheet.addRow({ id: r.id, category: r.category, description: r.description, error: r.error || '', timestamp: r.timestamp });
      row.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: 'FFFFCDD2' } };
      row.getCell('error').font = { color: { argb: 'FFB71C1C' }, italic: true };
      row.eachCell(c => {
        c.border = { top: { style: 'thin' }, bottom: { style: 'thin' }, left: { style: 'thin' }, right: { style: 'thin' } };
        c.alignment = { wrapText: true };
      });
    });
  }

  // ── Write File ───────────────────────────────────────────────────
  const dir = path.dirname(outputPath);
  if (!fs.existsSync(dir)) fs.mkdirSync(dir, { recursive: true });
  await workbook.xlsx.writeFile(outputPath);
  console.log(`✅ Excel report saved: ${outputPath}`);
}

module.exports = { generateExcelReport };
