# Changelog

All notable changes to this guide and the templates.

Format inspired by [Keep a Changelog](https://keepachangelog.com/).
Versioned with [Semantic Versioning](https://semver.org/).

---

## [V3.0] - 2026-06-11

New **Part VI, "Discipline & safety"**, plus a recovery playbook. Bilingual EN/FR.

### Added
- **Chapter 14, Testing & TDD**: test-first prompting, the test-as-spec pattern, wiring tests into the `verify` gate, what to test vs skip.
- **Chapter 15, Third-party MCP & prompt injection**: the `npx -y` arbitrary-code risk, the untrusted-content / trusted-privileges framing, the built-in safeguards, and a defenses-in-order checklist.
- **Annex J, Recovery playbook**: `/rewind` checkpoints (and their bash-command blind spot), `git restore` / `reset` / `reflog`, and a revert-or-repair decision table.
- Annex I (cheat sheet) added to the table of contents in both languages (it was missing).

### Changed
- Version bumped to V3 (title, cover, foreword note) in EN and FR.

### Verified against
- Official Claude Code documentation at `code.claude.com/docs/en/` (checkpointing, security, MCP).

---

## [V2.0] - 2026-05-22

Reconstructed entry, V2 shipped without its own changelog section.

### Added
- Chapters: 06 Skills, 07 Plan-first development (with the `plan-reviewer` sub-agent), 08 The audit loop (`/extract-lesson`), 10 Parallel worktrees, 11 The memory matrix.
- Annexes: F Glossary, G 30-minute quick start, H Case studies, I Cheat sheet.
- Templates: `plan-reviewer` agent, `new-feature` and `extract-lesson` commands, the `conventional-commits` skill, the `extract-lesson` hook.
- Reading paths, difficulty badges, stricter "1 concept = 1 page" print design.

---

## [V1.0] - 2026-05-20

Initial public release.

### Added
- French and English guides (37 pages each), HTML sources for both languages
- Copy-paste templates :
  - Universal `CLAUDE.md`
  - Complete `.claude/settings.json` with hooks
  - 5 hooks (PreToolUse defensive, PostToolUse format + activity log, SessionStart recap, Stop coach)
  - 2 sub-agent examples (`code-auditor`, `security-auditor`)
  - 6 slash commands (`ship`, `audit-quick`, `standup`, `coach`, `coach-mute`, `coach-on`)
  - Agent memory pattern documentation
  - `.gitignore.sample`
- README, LICENSE, CHANGELOG

### Verified against
- Official Claude Code documentation at `code.claude.com/docs/en/`
- Real-world usage in a Next.js 16 + Supabase production project

---

See [`ROADMAP.md`](ROADMAP.md) for the V3 scope.
