# Building Claude Code Handbook V2 — PDF + HTML

How to take `en/source-v2.html` and `fr/source-v2.html` and produce both PDF and web HTML outputs.

## Quick path (recommended: Paged.js)

[Paged.js](https://pagedjs.org/) is open-source, browser-based, and respects 99% of CSS print rules including `page-break-inside: avoid` on tables and code blocks. Best balance of quality vs cost.

### Install

```bash
npm install -g pagedjs-cli
```

### Generate PDFs

```bash
# English
pagedjs-cli en/source-v2.html -o en/claude-code-handbook-v2.pdf

# French
pagedjs-cli fr/source-v2.html -o fr/le-code-du-claudeur-v2.pdf
```

Paged.js runs the page in a headless browser, so the embedded `mermaid.js` script renders the diagrams to SVG before paging. **No pre-render needed** for this path.

## Mermaid diagrams — pre-rendering (optional, for offline/PDF-only renderers)

The V2 sources include 4 Mermaid diagrams (chapters 06, 07, 08, 11). The HTML loads `mermaid.js` from a CDN and renders them client-side. This works for:
- Web viewing (`en/index.html`, `fr/index.html`)
- Paged.js PDF generation (the browser engine runs JS)

For renderers that **don't run JavaScript** (e.g., WeasyPrint, some Prince configurations), pre-render the diagrams to SVG first:

```bash
# Install the mermaid CLI
npm install -g @mermaid-js/mermaid-cli

# Extract each <pre class="mermaid"> block to its own .mmd file,
# render with mmdc, then replace the block with <img src="...">
# in the HTML before passing it to the renderer.

mmdc -i diagrams/chap06-skill-wiring.mmd -o diagrams/chap06-skill-wiring.svg
mmdc -i diagrams/chap07-plan-first-pipeline.mmd -o diagrams/chap07-plan-first-pipeline.svg
mmdc -i diagrams/chap08-extract-lesson-loop.mmd -o diagrams/chap08-extract-lesson-loop.svg
mmdc -i diagrams/chap11-memory-matrix.mmd -o diagrams/chap11-memory-matrix.svg
```

The 4 `.mmd` source files can be extracted from the HTML with:

```bash
grep -oP '(?<=<pre class="mermaid">)[\s\S]*?(?=</pre>)' en/source-v2.html
```

### Generate web HTML (for GitHub Pages)

The source HTML files already include print CSS. For a polished web version, add a screen-only stylesheet:

```bash
# Just copy the source as index.html; the CSS handles both screen and print
cp en/source-v2.html en/index.html
cp fr/source-v2.html fr/index.html
```

If you want a richer web experience (dark mode, sticky nav, search), wrap the source HTML with Paged.js preview or use a static-site generator.

## Alternative: Prince XML (best quality)

[Prince](https://www.princexml.com/) is the gold standard for HTML-to-PDF. Free for non-commercial use (with watermark). Commercial license required for paid distribution.

```bash
prince en/source-v2.html -o en/claude-code-handbook-v2.pdf
prince fr/source-v2.html -o fr/le-code-du-claudeur-v2.pdf
```

## Alternative: Chrome headless (free, lower quality)

Works but ignores some `page-break-inside: avoid` on long content. Do a manual sweep after.

```bash
chromium --headless \
  --print-to-pdf=en/claude-code-handbook-v2.pdf \
  --print-to-pdf-no-header \
  --no-margins \
  en/source-v2.html
```

Add `--virtual-time-budget=10000` if you have webfonts.

## Pre-flight checklist before publishing

- [ ] Both EN and FR source files compile to PDF without errors
- [ ] Page count is within 5 pages of the TOC estimate (52)
- [ ] No widow lines (a single line of a paragraph alone at the top of a page)
- [ ] All code blocks fit on one page each (no splits)
- [ ] All tables fit on one page each (or break at a sensible row)
- [ ] No chapter title alone at the bottom of a page
- [ ] Pagination is correct (page X / Y in the footer)
- [ ] Section anchors (`#chap-06`, etc.) work in the web HTML
- [ ] Fonts load correctly (Inter + JetBrains Mono via Google Fonts)
- [ ] Spellcheck FR + EN once more

## Troubleshooting

**Problem**: code block splits across pages despite `page-break-inside: avoid`.

**Cause**: the code block is taller than one page minus headers. CSS can't split a "do not break" rule on a block that's physically too big.

**Fix**: shorten the example, or split into two code blocks with a sentence between.

---

**Problem**: a heading is at the bottom of a page with its content on the next.

**Cause**: the heading's `page-break-after: avoid` isn't being honored by the renderer.

**Fix**: in `assets/css/print.css`, add `margin-top: 0` reset on the first child after a heading, and wrap heading + first paragraph in a `<section class="block">` div with `page-break-inside: avoid`.

---

**Problem**: French text shows "□" or missing characters.

**Cause**: the renderer is using a font without full Latin Extended-A coverage.

**Fix**: ensure Inter is fully loaded. Add `font-display: swap` to the Google Fonts link.

## File structure of this repo (proposed)

```
claude-code-handbook/
├── README.md                       ← updated for V2
├── CHANGELOG.md                    ← [V2.0] section added
├── LICENSE
├── BUILD.md                        ← this file
├── assets/
│   └── css/
│       └── print.css               ← shared by EN + FR
├── en/
│   ├── source-v2.html
│   ├── claude-code-handbook-v2.pdf
│   ├── source.html                 ← V1 kept for reference
│   └── claude-code-handbook-v1.pdf ← V1 kept for download
├── fr/
│   ├── source-v2.html
│   ├── le-code-du-claudeur-v2.pdf
│   ├── source.html                 ← V1 kept for reference
│   └── le-code-du-claudeur-v1.pdf  ← V1 kept for download
└── templates/                       ← UPDATED with new files
    ├── CLAUDE.md
    ├── .gitignore.sample
    ├── .claude/
    │   ├── settings.json
    │   ├── COMMANDS.md
    │   ├── PATTERNS.md
    │   ├── hooks/
    │   │   ├── pre-tool-guard.sh
    │   │   ├── post-edit-format.sh
    │   │   ├── session-start.sh
    │   │   ├── activity-log.sh
    │   │   ├── coach-suggest.sh
    │   │   └── extract-lesson.sh        ← NEW V2
    │   ├── agents/
    │   │   ├── code-auditor.md
    │   │   ├── security-auditor.md
    │   │   ├── plan-reviewer.md         ← NEW V2
    │   │   └── doc-writer.md            ← NEW V2
    │   ├── commands/
    │   │   ├── ship.md
    │   │   ├── audit-quick.md
    │   │   ├── standup.md
    │   │   ├── coach.md
    │   │   ├── coach-mute.md
    │   │   ├── coach-on.md
    │   │   ├── new-feature.md           ← NEW V2
    │   │   └── extract-lesson.md        ← NEW V2
    │   └── agent-memory/
    │       └── README.md
    └── .agents/
        └── skills/
            └── conventional-commits/    ← NEW V2 — example skill
                ├── SKILL.md
                └── references/
                    ├── _sections.md
                    ├── _template.md
                    ├── _contributing.md
                    ├── format-type-required.md
                    ├── format-scope-optional.md
                    ├── format-description-imperative.md
                    └── breaking-change-marker.md
```
