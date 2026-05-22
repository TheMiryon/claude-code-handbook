const puppeteer = require('puppeteer');
const path = require('path');

async function buildPdf(htmlPath, pdfPath) {
  const absHtml = 'file:///' + path.resolve(htmlPath).replace(/\\/g, '/');
  const browser = await puppeteer.launch({ headless: 'new' });
  const page = await browser.newPage();

  await page.goto(absHtml, { waitUntil: 'networkidle0', timeout: 60000 });

  await page.waitForFunction(
    () => document.querySelectorAll('pre.mermaid svg, .mermaid svg').length >= 4,
    { timeout: 30000 }
  ).catch(() => console.log('  ⚠ Mermaid diagrams may not have all rendered'));

  await new Promise(r => setTimeout(r, 2000));

  await page.pdf({
    path: pdfPath,
    format: 'A4',
    printBackground: true,
    margin: { top: '22mm', right: '18mm', bottom: '22mm', left: '18mm' },
    displayHeaderFooter: false,
    preferCSSPageSize: true
  });

  await browser.close();
  console.log('✓ Built ' + pdfPath);
}

(async () => {
  await buildPdf('en/source-v2.html', 'en/claude-code-handbook-v2.pdf');
  await buildPdf('fr/source-v2.html', 'fr/le-code-du-claudeur-v2.pdf');
})();