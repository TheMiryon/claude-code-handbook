// prepare-for-epub.js
// Renders Mermaid diagrams to inline SVG inside the source HTML so that
// Pandoc (which can't run JS) can convert the resulting HTML to a clean EPUB.
// Output: en/source-v2-rendered.html and fr/source-v2-rendered.html

const puppeteer = require('puppeteer');
const path = require('path');
const fs = require('fs');

async function renderForEpub(sourceHtml, outputHtml) {
  console.log(`\n→ ${sourceHtml}`);

  const absHtml = 'file:///' + path.resolve(sourceHtml).replace(/\\/g, '/');
  const browser = await puppeteer.launch({ headless: 'new' });
  const page = await browser.newPage();

  await page.goto(absHtml, { waitUntil: 'networkidle0', timeout: 60000 });

  // Wait for Mermaid to render all diagrams
  console.log('  · rendering Mermaid diagrams to inline SVG...');
  await page.waitForFunction(
    () => document.querySelectorAll('pre.mermaid svg, .mermaid svg').length >= 4,
    { timeout: 30000 }
  ).catch(() => console.log('  · Mermaid may not have all rendered'));
  await new Promise(r => setTimeout(r, 1500));

  // Extract the rendered HTML (with Mermaid as SVG now)
  const renderedHtml = await page.evaluate(() => document.documentElement.outerHTML);

  // Remove the Mermaid script tag (no JS in EPUB) and any cdn refs to it
  const cleaned = renderedHtml
    .replace(/<script[^>]*mermaid[^>]*>[\s\S]*?<\/script>/g, '')
    .replace(/<script>[\s\S]*?mermaid\.initialize[\s\S]*?<\/script>/g, '');

  fs.writeFileSync(outputHtml, cleaned, 'utf8');
  const sizeKB = Math.round(fs.statSync(outputHtml).size / 1024);
  console.log(`  ✓ Wrote ${outputHtml} (${sizeKB} KB)`);

  await browser.close();
}

(async () => {
  try {
    await renderForEpub('en/source-v2.html', 'en/source-v2-rendered.html');
    await renderForEpub('fr/source-v2.html', 'fr/source-v2-rendered.html');
    console.log('\n✅ HTML files prepared for EPUB.');
    console.log('   Now run:');
    console.log('   pandoc en/source-v2-rendered.html -o en/claude-code-handbook-v2.epub --metadata title="The Claude Code Handbook V2" --metadata author="TheMiryon" --metadata lang=en --toc --toc-depth=2');
    console.log('   pandoc fr/source-v2-rendered.html -o fr/le-code-du-claudeur-v2.epub --metadata title="Le Code du Claudeur V2" --metadata author="TheMiryon" --metadata lang=fr --toc --toc-depth=2');
  } catch (e) {
    console.error('\n❌ Failed:', e.message);
    process.exit(1);
  }
})();
