# CHANGELOG diff — add the V2 section at the top

Insert this block at the top of `CHANGELOG.md`, just under the introduction:

```markdown
## [V2.0] — 2026-MM-DD

Major restructure. 14 chapters in 5 parts, ~52 pages, redesigned for "1 concept = 1 page".

### Added
- **Chapter 06 — Skills (the right way)**: full chapter on the Anthropic-style skill folder (`.agents/skills/<name>/SKILL.md` + `references/`), wiring to agents, and anti-patterns (orphan skills, agent-prompt duplication). With a Mermaid diagram of the wiring.
- **Chapter 07 — Plan-first development**: the `/new-feature` pipeline with a `plan-reviewer` sub-agent acting as staff engineer at step 1.5, inspired by Boris Cherny. With a Mermaid diagram of the full pipeline.
- **Chapter 08 — The audit loop**: the `extract-lesson` hook + slash command that pin lessons to `CLAUDE.md` (versioned) instead of relying on local-only memory. With a Mermaid diagram of the loop.
- **Chapter 10 — Parallel worktrees**: the Boris Cherny pattern for running multiple Claude sessions in parallel via `git worktree`.
- **Chapter 11 — The memory matrix**: explicit decision rules for the 4 memory locations (CLAUDE.md / skills / agent-memory / ~/.claude/projects). With a Mermaid decision tree.
- **"For who / not for who" page** right after the foreword — explicitly extends the audience to knowledge workers, not just developers.
- **TL;DR callouts** at the start of each new chapter (06, 07, 08, 10, 11) — 3 bullet points so the impatient reader can decide whether to read on.
- **Annex F — Glossary**: definitions for hook, MCP, sub-agent, skill, frontmatter, `$ARGUMENTS`, least privilege, page-break, plan-first, worktree, etc.
- **Annex H — Two case studies (anonymized)**: a 6-month solo developer story + a 3-month knowledge worker story (independent researcher / writer).
- **Annex I — Cheat sheet (2 pages)**: foldout reference of all hooks, slash commands, agent templates, memory locations, decision rule, golden rules. Designed for A3 print or laminated reference.
- "How to read this book" page with three reading paths and difficulty badges (Beginner / Intermediate / Advanced).
- 5 part covers separating the book into logical sections.
- New template files:
  - `templates/.claude/agents/plan-reviewer.md`
  - `templates/.claude/agents/doc-writer.md`
  - `templates/.claude/commands/new-feature.md`
  - `templates/.claude/commands/extract-lesson.md`
  - `templates/.claude/hooks/extract-lesson.sh`
  - `templates/.agents/skills/conventional-commits/` (complete example skill with 4 rules)
- `BUILD.md` documenting the PDF generation pipeline (Paged.js, Prince, Chrome headless)

### Changed
- **New positioning** — cover tagline changed from "A pro setup, step by step" to **"The handbook you actually finish."** Subtitle now explicit: "52 pages. Free. Works for developers and knowledge workers."
- TOC restructured into 5 parts: Foundations / Baseline setup / Specialized configuration / Advanced workflow / Going further.
- `description` field guidance for sub-agents expanded with calibrated examples (Chapter 05).
- "When to create a slash command vs sub-agent vs skill" decision matrix added to Chapter 04.
- MCP chapter (now 12) extends the read-only lock pattern (double-layer guard in `.mcp.json` + `settings.local.json`).
- `/audit-claude-setup` checklist extended with two checks: orphan skills, skill ↔ agent prompt duplication.
- All project-specific references removed; examples are now stack-agnostic (generic Express todo-api as recurring fil rouge, with parallel knowledge-worker examples).
- Print CSS rewritten for stricter page-break discipline (page-break-inside: avoid on all logical blocks, sections, tables, code, callouts, figures).
- Cover and chapter title page design refreshed (chapter-number eyebrow, larger chapter title).
- Mermaid diagrams (4 total) integrated; CDN-loaded for web, pre-renderable via `mmdc` for offline PDF builds (see BUILD.md).

### Fixed
- "33 pages" / "37 pages" version drift between README and CHANGELOG aligned
- Inconsistent code formatting in V1 sample hooks normalized

### Verified against
- Anthropic Claude Code documentation (May 2026)
- Boris Cherny's public talks and posts on his Claude Code workflow
- Real-world usage in a TypeScript SaaS production project (see Annex H, anonymized)
```
