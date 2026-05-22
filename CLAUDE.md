# The Claude Code Handbook

Bilingual (EN / FR) Claude Code guide published as a static site (GitHub Pages) plus PDF and EPUB downloads.

## Tech stack
- Sources: HTML5 + CSS (Paged.js print styling) in `en/source-v2.html` and `fr/source-v2.html`
- Landing page: `index.html` (root)
- PDF build: Node.js + Puppeteer (`build-pdf.js`)
- EPUB build: Pandoc + a Mermaid-to-SVG pre-pass (`prepare-for-epub.js`, then `build-epub.ps1`)
- Distribution: GitHub Pages (root + `en/`, `fr/`) — auto-deploys from `main` / root
- No backend, no DB, no test harness

## Useful commands
- `node build-pdf.js` — rebuild both PDFs from `source-v2.html`
- `node prepare-for-epub.js` — pre-render Mermaid diagrams to inline SVG (required before EPUB)
- `powershell .\build-epub.ps1` — rebuild both EPUBs (Pandoc must be in PATH)
- Preview: open `en/source-v2.html` or `fr/source-v2.html` in a browser

## Conventions
- **Bilingual lock-step**: every content change in `en/` must have its counterpart in `fr/`. No EN-only or FR-only commits.
- Canonical source per language is `source-v2.html`. `index.html` (per language) is the Pages entry and mirrors `source-v2.html`.
- Layout: "1 concept = 1 page" where possible. Avoid orphan headings at page breaks.
- Mermaid diagrams live inline in the HTML.
- Annexes are lettered (A, B, C, …) and listed in the foreword's table of contents.

## Gotchas
- `en/source-v2-rendered.html` and `fr/source-v2-rendered.html` are EPUB build artifacts — gitignored, never commit.
- `build-epub.ps1` has a known bug: PowerShell 5.1 backtick line-continuation breaks the FR `pandoc` invocation. Workaround: run the FR pandoc command as a one-liner manually.
- V1 PDFs (`en/claude-code-handbook-v1.pdf`, `fr/le-code-du-claudeur-v1.pdf`) are archived. Do not regenerate or overwrite them.

## Git workflow
- Target branch: `main`
- New versions land via short-lived `vX-draft` branches → PR → merge to `main` → tag `vX.Y.Z` → GitHub Release with EPUBs attached
- Commit format: Conventional Commits (`feat:`, `fix:`, `docs:`, `chore:`, …)
- Pages auto-deploys from `main` / root (no manual deploy step)

## Hard rules
- **Never** modify or delete `en/claude-code-handbook-v1.pdf` or `fr/le-code-du-claudeur-v1.pdf` — they are the archived V1 distribution
- **Never** commit `*-rendered.html` — they are build artifacts
- **Always** keep `en/` and `fr/` in sync — bilingual parity is the product
- After source-v2 edits → rebuild PDFs + EPUBs before tagging a release

## When to use which agent
- Before tagging a new release → `code-auditor` on the changed chapter HTML (cross-link integrity, dead anchors, table-of-contents drift)
- If a Mermaid diagram or callout is added → check it renders both in browser preview AND in the EPUB (EPUB uses inline SVG produced by `prepare-for-epub.js`; browser uses Mermaid.js live)

## Slash commands
- `/ship "<msg>"` — verify + commit + push
- `/extract-lesson` — capture a recurring mistake into this file (the audit loop)
- `/standup` — what changed since last session

## Pre-release checklist
1. Both PDFs rebuild without errors (`node build-pdf.js`)
2. Both EPUBs rebuild without errors (Pandoc validates, Mermaid renders)
3. EN / FR content is in sync (no untranslated section)
4. `CHANGELOG.md` has the version section with date
5. Release tag matches version in `CHANGELOG.md` and `README.md`
6. GitHub Release has both EPUBs attached and is marked "Latest"
