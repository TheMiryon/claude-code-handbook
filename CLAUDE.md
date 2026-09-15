# The Claude Code Handbook

Bilingual (EN / FR) Claude Code guide published as a static site (GitHub Pages) plus EPUB downloads. Currently V4.0: 24 chapters in 9 parts, annexes A-L.

## Tech stack
- Sources: HTML5 + CSS in `en/source-v2.html` and `fr/source-v2.html`
- Landing page: `index.html` (root)
- EPUB build: Pandoc + a Mermaid-to-SVG pre-pass (`prepare-for-epub.js`, then `build-epub.ps1`)
- Distribution: GitHub Pages (root + `en/`, `fr/`), auto-deploys from `main` / root
- No backend, no DB, no test harness

## Useful commands
- `node prepare-for-epub.js`: pre-render Mermaid diagrams to inline SVG (required before EPUB)
- `powershell .\build-epub.ps1`: rebuild both EPUBs (Pandoc must be in PATH)
- Preview: open `en/source-v2.html` or `fr/source-v2.html` in a browser

## Conventions
- **Bilingual lock-step**: every content change in `en/` must have its counterpart in `fr/`. No EN-only or FR-only commits.
- Canonical source per language is `source-v2.html`. `index.html` (per language) is the Pages entry and mirrors `source-v2.html`.
- Layout: "1 concept = 1 page" where possible. Avoid orphan headings at page breaks.
- Mermaid diagrams live inline in the HTML.
- Annexes are lettered (A, B, C, …) and listed in the foreword's table of contents.

## Gotchas
- `en/source-v2-rendered.html` and `fr/source-v2-rendered.html` are EPUB build artifacts: gitignored, never commit.
- `en/index.html` and `fr/index.html` drift silently. They are plain copies of `source-v2.html` and nothing regenerates them, so a release that forgets the copy ships an outdated site while the EPUBs are current. This happened in V3 and V3.1. Copy them as part of every release.
- `build-epub.ps1` passes pandoc arguments as splatted arrays, not backtick line-continuations. Do not reintroduce backticks: PowerShell 5.1 mis-parses a backtick followed by a trailing space and silently truncated the FR invocation.

## Git workflow
- Target branch: `main`
- New versions land via short-lived `vX-draft` branches → PR → merge to `main` → tag `vX.Y.Z` → GitHub Release with EPUBs attached
- Commit format: Conventional Commits (`feat:`, `fix:`, `docs:`, `chore:`, …)
- Pages auto-deploys from `main` / root (no manual deploy step)

## Hard rules
- **Never** commit `*-rendered.html`. They are build artifacts.
- **Always** keep `en/` and `fr/` in sync. Bilingual parity is the product.
- After source-v2 edits → rebuild EPUBs before tagging a release

## When to use which agent
- Before tagging a new release → `code-auditor` on the changed chapter HTML (cross-link integrity, dead anchors, table-of-contents drift)
- If a Mermaid diagram or callout is added → check it renders both in browser preview AND in the EPUB (EPUB uses inline SVG produced by `prepare-for-epub.js`; browser uses Mermaid.js live)

## Slash commands
- `/ship "<msg>"`: verify + commit + push
- `/extract-lesson`: capture a recurring mistake into this file (the audit loop)
- `/standup`: what changed since last session

## Pre-release checklist
1. Both EPUBs rebuild without errors (Pandoc validates, Mermaid renders)
2. EN / FR content is in sync (no untranslated section)
3. `CHANGELOG.md` has the version section with date
4. `en/index.html` and `fr/index.html` re-copied from `source-v2.html` (they do not regenerate themselves)
5. Release tag matches version in `CHANGELOG.md` and `README.md`
6. GitHub Release has both EPUBs attached and is marked "Latest"
