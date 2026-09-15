# Changelog

All notable changes to this guide and the templates.

Format inspired by [Keep a Changelog](https://keepachangelog.com/).
Versioned with [Semantic Versioning](https://semver.org/).

---

## [V4.0.1] - 2026-09-15

Patch. Tightens the `rm` guard so it stops blocking ordinary absolute paths, and extends it to system directories it never covered.

### Fixed
- **The guard hook blocked every absolute path, not just dangerous ones.** The pattern `rm\s+-[rf]\s+(/|~|../|$HOME)` matched the leading `/` of *any* absolute path, so `rm -f /tmp/build.log` was refused. A guard that blocks routine commands is a guard people learn to work around, which is worse than no guard. The regex now matches only the filesystem root itself, a system directory, a home directory, or a `../` traversal.
- **System directories were never guarded.** `rm -rf /etc` and `rm -rf /usr/local` passed, because neither is the bare root. Both are now blocked.
- **Quoted forms slipped through.** `rm -rf "$HOME"` didn't match while `rm -rf $HOME` did. Quotes are now stripped before matching.
- The `--no-verify` and `--force-with-lease` checks now read the de-quoted command too, so they can't be bypassed with quoting.

Applied to all six copies: `.claude/hooks/pre-tool-guard.sh`, `plugins/kit-methode/scripts/pre-tool-guard.sh`, both template hooks (bash and Python), and the three listings in the book (bash in Chapter 03, Python and PowerShell in Annex L), EN and FR.

### Changed
- The book's guard listings were a single 300-character regex line. They now build the pattern in named, commented pieces, which fits the printed page and is what the shipped script files contain.

### Verified
- 33 cases against the three shell scripts, 28 against the Python template.
- 106 cases against the code **as printed in the book**: the bash, Python and PowerShell listings are extracted from the HTML, unescaped, and executed. `rm -rf /`, `/etc`, `/usr/local/bin`, `~`, `$HOME`, `"$HOME"`, `${HOME}/x`, `../../src` block; `/tmp/build.log`, `/var/folders/...`, `./build`, `node_modules`, `dist` pass.

---

## [V4.0] - 2026-09-15

The largest revision since V1. Claude Code changed underneath the book during 2026: **auto mode became the default permission mode**, Claude started writing its own memory, and dynamic workflows landed as a new orchestration primitive above sub-agents. V4 rewrites the chapters those changes made obsolete and adds two parts. Bilingual EN/FR.

### Changed (content that had become factually wrong)
- **Chapter 00, surfaces**: the "6 official surfaces" table is replaced. Adds mobile (iOS *and* Android), Slack, and Chrome, plus a new **mobility layer** section covering Remote Control, `claude --teleport`, `/desktop` and Channels, with the Remote-Control-vs-cloud-session distinction spelled out.
- **Chapter 11, the memory matrix**: grows from four locations to **six**. Adds `.claude/rules/` with `paths:` frontmatter (the CLAUDE.md pressure valve) and **auto memory** (`~/.claude/projects/<project>/memory/`, written by Claude, machine-local, `MEMORY.md` capped at 200 lines / 25 KB). New section positioning auto memory against the Chapter 08 audit loop.
- **Chapter 05, sub-agents**: new section on **effort levels** (`/effort`, `xhigh`, `ultracode`) and fast mode, plus the "model for capability, effort for difficulty" rule and a caution that 1M context is a ceiling, not a target.
- **Chapter 17** (was 16, plugins): adds the two official catalogs (`claude-plugins-official`, `claude-plugins-community`) and `claude plugin eval`.
- Chapters renumbered: old 15 → 16, old 16 → 17.

### Added
- **Chapter 15, Permissions, auto mode & the sandbox** (Part VI): the six permission modes, which actions no mode ever auto-approves, auto mode vs `--dangerously-skip-permissions`, the Bash sandbox as an independent axis (and its absence on native Windows), a posture-selection table, and why `PreToolUse` hooks and deny rules now matter more, not less.
- **Part VIII, Orchestration & scale**
  - **Chapter 18, Working in parallel**: sub-agents vs agent view vs agent teams vs dynamic workflows, the three questions that decide, cross-session messaging, `/subtask`, `/fork`, `/batch`.
  - **Chapter 19, Dynamic workflows**: the script model, `/deep-research`, the `ultracode` keyword and why it only fires from human input, the `agent()`/`pipeline()`/`parallel()`/`phase()` vocabulary, adversarial verification, runtime limits, and cost control.
  - **Chapter 20, The context window**: `/context`, `/compact` vs `/clear`, what survives compaction, prompt-cache misses, and sub-agents as a context strategy.
- **Part IX, Automation & quality gates**
  - **Chapter 21, Headless & CI**: `claude -p`, why headless starts in Manual mode, `dontAsk` + `--allowedTools` as the correct CI posture, GitHub Actions / GitLab CI / Routines, and the propose-don't-merge rule.
  - **Chapter 22, Auditing your own setup**: `/doctor`, `/skill-doctor`, `claude plugin eval` against a no-plugin baseline, and a monthly pass table.
  - **Chapter 23, Artifacts**: publishing session output as a live page, when it beats a file in the repo, the comment loop, and two cautions.
- **Annex K, Onboarding an existing codebase**: why not to write CLAUDE.md first, `/init` multi-phase mode, `/import`, `AGENTS.md` interop, `claudeMdExcludes`, and what belongs in a first version.
- **Annex L, Cross-platform hooks**: the guard hook in Python and PowerShell, the CRLF shebang trap, and a per-platform feature table.
- **Annex I (cheat sheet)**: new permission-modes table and a 2026 command reference.
- **Annex F (glossary)**: 10 new terms (auto mode, auto memory, classifier, agent view, artifact, context window, effort level, path-scoped rule, sandbox, dynamic workflow).

### Fixed
- **`en/index.html` and `fr/index.html` were still V2.** The GitHub Pages site had not been regenerated for V3 or V3.1, so online readers were two versions behind the EPUBs. Both now mirror `source-v2.html` as the conventions require.
- **Root `index.html`** landing page still advertised V2 and linked to the V2 EPUBs.
- **`build-epub.ps1`**: the FR `pandoc` invocation was silently truncated by PowerShell 5.1 backtick line-continuation. Arguments are now built as arrays and splatted, which removes the documented manual workaround.
- **Bilingual parity restored**: the FR edition told the reader to consult the English book for two hook scripts (`session-start.sh`, `coach-suggest.sh`). Both are now inlined in French, so the FR EPUB is self-contained. This had been true since V2.
- **Self-referential claims invalidated by the restructuring**: chapter 22 called itself "the last chapter" (chapter 23 follows it), chapter 17 called itself "the book's endpoint" (Parts VIII and IX follow it), chapter 20 said the book had "spent seventeen chapters" (twenty precede it), and the chapter 11 TL;DR claimed two of the six memory locations are written by Claude (one is).
- **TOC pagination**: part covers take a full page in `print.css`, but the entries for Parts VI–IX and the annexes gave the part cover and its first chapter the same page number.
- **Annex L PowerShell hook** was missing the `--no-verify` guard that the bash and Python versions have, so a Windows-only team following the annex shipped a weaker guard than the book's other listings. It also assigned to `$input`, a PowerShell automatic variable.
- Stale authoring comments removed, including one instructing a rewrite-from-V1 of the chapter V4 had just rewritten, and a finished V2 translation backlog that was being served to every visitor of the FR page.

### Verified against
- Official Claude Code documentation at `code.claude.com/docs/en/` (changelog, what's-new digests weeks 22–37, permission-modes, sandboxing, memory, workflows, agents, artifacts, headless, plugin-evals, routines).
- `github.com/anthropics/claude-plugins-official` and `github.com/anthropics/claude-plugins-community`.

---

## [V3.1] - 2026-06-11

New **Part VII, "Packaging & distribution"**. Bilingual EN/FR.

### Added
- **Chapter 16, Plugins & marketplaces**: when to graduate from `.claude/` to a plugin, the `.claude-plugin/plugin.json` anatomy, `${CLAUDE_PLUGIN_ROOT}` / `${CLAUDE_PROJECT_DIR}` and the cache gotcha, `userConfig` parametrization, the `marketplace.json` + install flow, packaging the book's own setup as the worked example, and a `/loop` vs Routines vs Desktop-tasks scheduling section.

### Verified against
- Official Claude Code documentation at `code.claude.com/docs/en/` (plugins, plugin-marketplaces, plugins-reference, scheduled-tasks).

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
