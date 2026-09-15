# build-epub.ps1
# One-click EPUB generation for Windows.
# Pre-requisites:
#   1. Node + Puppeteer installed (npm install)
#   2. Pandoc installed: https://pandoc.org/installing.html (~50 MB MSI)
#
# Note: pandoc arguments are passed as arrays and splatted rather than using
# backtick line-continuations, which PowerShell 5.1 mis-parses when a trailing
# space follows the backtick. That bug silently truncated the FR invocation.

$ErrorActionPreference = 'Stop'

$Version = '4.0'
$Date    = '2026-09'

Write-Host "-> Step 1/2 : Rendering Mermaid diagrams inline..." -ForegroundColor Cyan
node prepare-for-epub.js
if ($LASTEXITCODE -ne 0) { Write-Error "prepare-for-epub failed"; exit 1 }

Write-Host "`n-> Step 2/2 : Building EPUBs via Pandoc..." -ForegroundColor Cyan

$builds = @(
  @{
    Source   = 'en/source-v2-rendered.html'
    Output   = 'en/claude-code-handbook-v4.epub'
    Title    = "The Claude Code Handbook V$Version"
    Subtitle = 'The handbook you actually finish.'
    Lang     = 'en'
  },
  @{
    Source   = 'fr/source-v2-rendered.html'
    Output   = 'fr/le-code-du-claudeur-v4.epub'
    Title    = "Le Code du Claudeur V$Version"
    Subtitle = 'Le manuel que tu finis vraiment.'
    Lang     = 'fr'
  }
)

foreach ($b in $builds) {
  if (-not (Test-Path $b.Source)) {
    Write-Error "Missing $($b.Source). Did prepare-for-epub.js run?"
    exit 1
  }

  $pandocArgs = @(
    $b.Source
    '-o', $b.Output
    '--metadata', "title=$($b.Title)"
    '--metadata', "subtitle=$($b.Subtitle)"
    '--metadata', 'author=TheMiryon'
    '--metadata', "lang=$($b.Lang)"
    '--metadata', "date=$Date"
    '--toc', '--toc-depth=2'
    '--split-level=1'
  )

  pandoc @pandocArgs
  if ($LASTEXITCODE -ne 0) { Write-Error "$($b.Lang.ToUpper()) EPUB build failed"; exit 1 }
  Write-Host "  [ok] $($b.Output)" -ForegroundColor Green
}

Write-Host "`nDone. Both EPUBs ready." -ForegroundColor Green
Get-ChildItem en/*.epub, fr/*.epub |
  Select-Object Name, @{N='Size';E={[math]::Round($_.Length/1024, 0).ToString() + ' KB'}}
