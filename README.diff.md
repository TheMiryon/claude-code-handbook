# README diff — update for V2

Replace the version mention and the "Features delivered" section with this:

```markdown
# Claude Code Handbook

A bilingual step-by-step guide and copy-paste templates to configure Claude Code like a pro.

**Latest version**: V2 (May 2026) — 52 pages, 14 chapters in 5 parts.
**V1** (May 2026, 33 pages) is preserved for download.

## What's new in V2

- Full chapter on **skills** — the third primitive of Claude Code, alongside hooks and sub-agents (Chapter 06)
- **Plan-first development** with a `plan-reviewer` sub-agent acting as staff engineer (Chapter 07)
- **The audit loop** — capture lessons in Git-versioned files instead of local-only memory (Chapter 08)
- **Parallel worktrees** for running multiple Claude sessions side by side (Chapter 10)
- **The memory matrix** — clear rules for the 4 memory locations (Chapter 11)
- **Anonymized case study** of a 6-month real-world application (Annex H)
- **Glossary** for newcomers (Annex F)
- Reading paths and difficulty badges so you can read the book in the order that fits you
- Stricter print design — "1 concept = 1 page" where possible, no orphan headings

## Downloads

| | English | Français |
|---|---|---|
| **V2** (latest) | [PDF](en/claude-code-handbook-v2.pdf) · [Web](en/index.html) | [PDF](fr/le-code-du-claudeur-v2.pdf) · [Web](fr/index.html) |
| V1 | [PDF](en/claude-code-handbook-v1.pdf) | [PDF](fr/le-code-du-claudeur-v1.pdf) |

## Features delivered by the setup

After applying the templates in this book, you get:

- Permanent project context — Claude loads `CLAUDE.md` at every session, you stop re-explaining your stack
- Automatic command blocking for unsafe operations (`rm -rf`, force pushes, `.env` modifications)
- Auto-formatting after edits
- Session recaps via git state display
- Specialized audit sub-agents (code, security, design, performance, db, plan-review, …)
- Coach mode with contextual suggestions
- Versioned domain knowledge through the skill system (NEW in V2)
- Plan-first pipeline with second-opinion review (NEW in V2)
- A lesson-capture loop that survives reclones (NEW in V2)

## Scope

Applies to all six Claude Code interfaces: CLI, VS Code, JetBrains, desktop, web, iOS.

## Quick start

Read Annex G ("30-minute quick start") in the PDF. Or go straight to the [templates](templates/) directory and start copying.

## Building the PDFs yourself

See [BUILD.md](BUILD.md) for the Paged.js / Prince / Chrome-headless pipeline.

## License

MIT.
```
