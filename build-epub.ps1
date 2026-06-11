# build-epub.ps1
# One-click EPUB generation for Windows.
# Pre-requisites:
#   1. Node + Puppeteer installed (npm install)
#   2. Pandoc installed: https://pandoc.org/installing.html (~50 MB MSI)

Write-Host "→ Step 1/2 : Rendering Mermaid diagrams inline..." -ForegroundColor Cyan
node prepare-for-epub.js
if ($LASTEXITCODE -ne 0) { Write-Error "prepare-for-epub failed"; exit 1 }

Write-Host "`n→ Step 2/2 : Building EPUBs via Pandoc..." -ForegroundColor Cyan

pandoc en/source-v2-rendered.html `
  -o en/claude-code-handbook-v3.epub `
  --metadata title="The Claude Code Handbook V3" `
  --metadata subtitle="The handbook you actually finish." `
  --metadata author="TheMiryon" `
  --metadata lang=en `
  --metadata date="2026-06" `
  --toc --toc-depth=2 `
  --split-level=1

if ($LASTEXITCODE -ne 0) { Write-Error "EN EPUB build failed"; exit 1 }
Write-Host "  ✓ en/claude-code-handbook-v3.epub" -ForegroundColor Green

pandoc fr/source-v2-rendered.html `
  -o fr/le-code-du-claudeur-v3.epub `
  --metadata title="Le Code du Claudeur V3" `
  --metadata subtitle="Le manuel que tu finis vraiment." `
  --metadata author="TheMiryon" `
  --metadata lang=fr `
  --metadata date="2026-06" `
  --toc --toc-depth=2 `
  --split-level=1

if ($LASTEXITCODE -ne 0) { Write-Error "FR EPUB build failed"; exit 1 }
Write-Host "  ✓ fr/le-code-du-claudeur-v3.epub" -ForegroundColor Green

Write-Host "`n✅ Done. Both EPUBs ready." -ForegroundColor Green
Get-ChildItem en/*.epub, fr/*.epub | Select-Object Name, @{N='Size';E={[math]::Round($_.Length/1024, 0).ToString() + ' KB'}}
