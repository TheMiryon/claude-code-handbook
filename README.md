# Claude Code Handbook · Le Code du Claudeur

> The Claude Code handbook you actually finish. Bilingual (EN/FR), free. Hooks, sub-agents, skills, plan-first dev, audit loop — for developers and knowledge workers.
> Le manuel Claude Code que tu finis vraiment. Bilingue (EN/FR), gratuit.

**Latest version**: V2 (May 2026) — 52 pages, 14 chapters in 5 parts.
**V1** (May 2026, 33 pages) is preserved for download.

## 📖 Read the guide / Lire le guide

| | English | Français |
|---|---|---|
| **Read online** | [themiryon.github.io/claude-code-handbook/en/](https://themiryon.github.io/claude-code-handbook/en/) | [themiryon.github.io/claude-code-handbook/fr/](https://themiryon.github.io/claude-code-handbook/fr/)
| **EPUB (V2)** | [`en/claude-code-handbook-v2.epub`](en/claude-code-handbook-v2.epub) | [`fr/le-code-du-claudeur-v2.epub`](fr/le-code-du-claudeur-v2.epub) |

---

## ✨ What's new in V2

- Full chapter on **skills** — the third primitive of Claude Code, alongside hooks and sub-agents (Chapter 06)
- **Plan-first development** with a `plan-reviewer` sub-agent acting as staff engineer (Chapter 07)
- **The audit loop** — capture lessons in Git-versioned files instead of local-only memory (Chapter 08)
- **Parallel worktrees** for running multiple Claude sessions side by side (Chapter 10)
- **The memory matrix** — clear rules for the 4 memory locations (Chapter 11)
- **Two anonymized case studies**: a 6-month solo developer + a 3-month knowledge worker (Annex H)
- **Glossary** for newcomers (Annex F)
- Reading paths and difficulty badges so you can read the book in the order that fits you
- Stricter print design — "1 concept = 1 page" where possible, no orphan headings

See [`CHANGELOG.md`](CHANGELOG.md) for the full change log.

---

## 🚀 Quick start — 30 minutes

The guide covers 14 chapters in 5 parts. If you want to jump straight in, Annex G has a **"30-minute quick start"** checklist.

Or skip ahead and just copy the templates below.

---

## 📋 Templates (copy-paste ready)

All the configuration files described in the guide, ready to drop into any project. Adapt paths, project names, and stack to your context.

```
templates/
├── CLAUDE.md                       ← the project brain (root of your repo)
├── .gitignore.sample               ← lines to add to your .gitignore
├── .agents/
│   └── skills/
│       └── conventional-commits/   ← example skill (SKILL.md + references/) — NEW in V2
└── .claude/
    ├── settings.json               ← permissions + hooks
    ├── COMMANDS.md                 ← optional: index of your slash commands
    ├── PATTERNS.md                 ← optional: copy-paste recipes
    ├── hooks/
    │   ├── pre-tool-guard.sh       ← defensive: block rm -rf, .env writes, --force pushes
    │   ├── post-edit-format.sh     ← auto-format after Write/Edit
    │   ├── session-start.sh        ← project recap at session open
    │   ├── activity-log.sh         ← zero-token activity log
    │   ├── coach-suggest.sh        ← Coach mode (Stop event suggestions)
    │   └── extract-lesson.sh       ← audit-loop hook — NEW in V2
    ├── agents/
    │   ├── code-auditor.md         ← read-only code quality audit
    │   ├── security-auditor.md     ← OWASP / GDPR / secrets audit
    │   └── plan-reviewer.md        ← staff-engineer plan review — NEW in V2
    ├── commands/
    │   ├── ship.md                 ← verify + commit + push in one line
    │   ├── audit-quick.md          ← code-auditor + security-auditor in parallel
    │   ├── standup.md              ← morning recap
    │   ├── coach.md                ← "what's the next step?"
    │   ├── coach-mute.md           ← turn off Coach suggestions
    │   ├── coach-on.md             ← turn back on
    │   ├── new-feature.md          ← plan-first pipeline — NEW in V2
    │   └── extract-lesson.md       ← capture a lesson to CLAUDE.md — NEW in V2
    └── agent-memory/
        └── README.md               ← cross-session memory pattern
```

### How to install the templates

From your project root:

```bash
# 1. Copy the templates
cp -r /path/to/this/repo/templates/CLAUDE.md ./
cp -r /path/to/this/repo/templates/.claude ./
cp -r /path/to/this/repo/templates/.agents ./   # NEW in V2 — skills

# 2. Append .gitignore additions
cat /path/to/this/repo/templates/.gitignore.sample >> .gitignore

# 3. Make hooks executable
chmod +x .claude/hooks/*.sh

# 4. Customize CLAUDE.md with your project specifics
$EDITOR CLAUDE.md
```

> **Windows users**: run these commands from **git-bash**, **WSL**, or any POSIX shell. The native PowerShell terminal doesn't have `cp -r`, `cat >>`, or `chmod` — the install steps assume a Unix-style shell. (Once installed, Claude Code itself runs fine on Windows.)

Then launch Claude Code from your project — it picks up everything automatically.

---

## ✨ What you get

After running the templates and reading the guide:

- **Permanent project context** — Claude loads `CLAUDE.md` at every session, you stop re-explaining your stack
- **Defensive hooks** — destructive commands (`rm -rf` on dangerous paths, `--force` pushes, `.env` writes) blocked before execution
- **Auto-format** — files formatted automatically after each edit, zero friction
- **Session recaps** — git state shown when you open a session, no need to type `git status`
- **Specialized sub-agents** — security, code, and plan-review audits in their own context
- **Slash commands** — `/ship`, `/audit-quick`, `/standup`, `/new-feature`, `/extract-lesson`, etc.
- **Coach mode** — suggests the right command at the right moment, without polluting the conversation
- **Versioned domain knowledge** via the skill system (NEW in V2)
- **Plan-first pipeline** with second-opinion review (NEW in V2)
- **Lesson-capture loop** that survives reclones (NEW in V2)

---

## 🎯 Audience

- Solo devs who code with Claude daily
- Teams who want consistent behavior across machines
- Knowledge workers (researchers, writers, analysts) — V2 extends explicitly beyond devs
- Beginners moving past "vibe coding" toward a reproducible workflow

---

## 🌍 Interface coverage

The guide and templates apply to **all 6 Claude Code surfaces**:

- Terminal CLI
- VS Code extension (also works in Cursor)
- JetBrains plugin
- Desktop app (macOS / Windows)
- Web (`claude.ai/code`)
- iOS app

For the Claude.ai chat product (not Claude Code), only the `CLAUDE.md` concept transfers via "Projects".

---

## 📦 Building the PDFs / EPUBs yourself

See [`BUILD.md`](BUILD.md) for the Paged.js / Chrome-headless (PDF) and Pandoc (EPUB) pipelines.

---

## 🤝 Contributing

Found a factual error, a typo, or a setup that fails in your environment? Open an issue or a PR. This is a living document.

---

## 📄 License

MIT. See [`LICENSE`](LICENSE). Use, share, modify, sell — just keep the copyright notice.

---

## 🙏 Credits

Built by [@TheMiryon](https://github.com/themiryon). Inspired by the Claude Code crash course by Mayank and Anthropic's official documentation.
