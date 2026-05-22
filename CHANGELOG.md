# Changelog

All notable changes to this guide and the templates.

Format inspired by [Keep a Changelog](https://keepachangelog.com/).
Versioned with [Semantic Versioning](https://semver.org/).

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
