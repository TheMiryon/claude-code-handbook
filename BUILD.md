# Building Claude Code Handbook V2: EPUB + HTML

How to take `en/source-v2.html` and `fr/source-v2.html` and produce both EPUB and web HTML outputs. The PDF distribution was dropped in favor of HTML on Pages and EPUB downloads.

## Web HTML (for GitHub Pages)

The source HTML files already include print CSS. For the live site, copy the source files as `index.html` so the language folders render directly on Pages:

```bash
cp en/source-v2.html en/index.html
cp fr/source-v2.html fr/index.html
```

GitHub Pages auto-deploys from `main` / root.

## EPUB build

EPUBs are produced from the same `source-v2.html` files via Pandoc, with a Mermaid-to-SVG pre-pass (Pandoc doesn't execute JavaScript so the live `mermaid.js` rendering wouldn't run).

### Prerequisites

- Node.js (for the pre-pass)
- [Pandoc](https://pandoc.org/installing.html) (~50 MB MSI on Windows)

### Build

```powershell
# Step 1: render Mermaid diagrams to inline SVG
node prepare-for-epub.js

# Step 2: build both EPUBs (calls Pandoc under the hood)
.\build-epub.ps1
```

Output: `en/claude-code-handbook-v2.epub`, `fr/le-code-du-claudeur-v2.epub`. The intermediate `en/source-v2-rendered.html` and `fr/source-v2-rendered.html` are gitignored build artifacts. Leave them on disk.

### Known issue: PowerShell 5.1 silently skips the FR EPUB

> Tracked in [#2](https://github.com/TheMiryon/claude-code-handbook/issues/2).

On **Windows PowerShell 5.1**, the backtick line-continuations in `build-epub.ps1` are mis-parsed for the FR `pandoc` invocation. Result: the EN EPUB is built, the FR EPUB silently fails with no error and no output file.

**Workaround until the script is fixed**: run the FR pandoc as a one-liner after `build-epub.ps1`:

```powershell
pandoc fr/source-v2-rendered.html -o fr/le-code-du-claudeur-v2.epub --metadata title="Le Code du Claudeur V2" --metadata subtitle="Le manuel que tu finis vraiment." --metadata author="TheMiryon" --metadata lang=fr --metadata date="2026-05" --toc --toc-depth=2 --split-level=1
```

PowerShell 7+ (`pwsh`) parses the backticks correctly; the script should work as-is on `pwsh`.

## Pre-flight checklist before publishing

- [ ] Both EN and FR EPUBs build without errors
- [ ] EPUBs open in a reader (Apple Books, Calibre, Edge) without rendering issues
- [ ] EN / FR `source-v2.html` preview correctly in the browser
- [ ] Section anchors (`#chap-06`, etc.) work in the web HTML
- [ ] Fonts load correctly (Inter + JetBrains Mono via Google Fonts)
- [ ] Spellcheck FR + EN once more

## Troubleshooting

**Problem**: a heading is at the bottom of a page with its content on the next (browser print preview).

**Cause**: the heading's `page-break-after: avoid` isn't being honored by the renderer.

**Fix**: in `assets/css/print.css`, add `margin-top: 0` reset on the first child after a heading, and wrap heading + first paragraph in a `<section class="block">` div with `page-break-inside: avoid`.

---

**Problem**: French text shows "□" or missing characters.

**Cause**: the renderer is using a font without full Latin Extended-A coverage.

**Fix**: ensure Inter is fully loaded. Add `font-display: swap` to the Google Fonts link.

## File structure of this repo

```
claude-code-handbook/
├── README.md
├── CHANGELOG.md
├── ROADMAP.md
├── BUILD.md                        ← this file
├── LICENSE
├── prepare-for-epub.js             ← Mermaid pre-pass
├── build-epub.ps1                  ← EPUB builder
├── index.html                      ← root landing page
├── assets/
│   └── css/
│       └── print.css               ← shared by EN + FR
├── en/
│   ├── source-v2.html              ← canonical V2 source
│   ├── index.html                  ← Pages entry (mirror of source-v2)
│   ├── source.html                 ← V1 kept for reference
│   └── claude-code-handbook-v2.epub
├── fr/
│   ├── source-v2.html
│   ├── index.html
│   ├── source.html
│   └── le-code-du-claudeur-v2.epub
└── templates/                      ← copy-paste setup for your projects
    ├── CLAUDE.md
    ├── .gitignore.sample
    ├── .claude/
    │   ├── settings.json
    │   ├── hooks/
    │   ├── agents/
    │   ├── commands/
    │   └── agent-memory/
    └── .agents/
        └── skills/
            └── conventional-commits/
```
