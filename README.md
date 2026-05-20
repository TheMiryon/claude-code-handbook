# Claude Code Handbook · Le Code du Claudeur

> A bilingual step-by-step guide for configuring Claude Code and working with it like a pro.
> Un guide bilingue step-by-step pour configurer Claude Code et travailler avec lui comme un pro.

## 📖 Read the guide / Lire le guide

| Language | PDF | Source |
|---|---|---|
| 🇬🇧 English | [`en/claude-code-handbook-v1.pdf`](en/claude-code-handbook-v1.pdf) | [`en/source.html`](en/source.html) |
| 🇫🇷 Français | [`fr/le-code-du-claudeur-v1.pdf`](fr/le-code-du-claudeur-v1.pdf) | [`fr/source.html`](fr/source.html) |

Both PDFs are 37 pages. Same content, two languages.

---

## 🚀 Quick start — 30 minutes

The guide covers eight chapters. If you want to jump straight in, the appendix has a **"30 minutes to start"** checklist on the last page.

Or skip ahead and just copy the templates below.

---

## 📋 Templates (copy-paste ready)

All the configuration files described in the guide, ready to drop into any project. Adapt paths, project names, and stack to your context.

```
templates/
├── CLAUDE.md                    ← the project brain (root of your repo)
├── .gitignore.sample            ← lines to add to your .gitignore
└── .claude/
    ├── settings.json            ← permissions + hooks
    ├── COMMANDS.md              ← optional: index of your slash commands
    ├── PATTERNS.md              ← optional: copy-paste recipes
    ├── hooks/
    │   ├── pre-tool-guard.sh    ← defensive: block rm -rf, .env writes, --force pushes
    │   ├── post-edit-format.sh  ← auto-format after Write/Edit
    │   ├── session-start.sh     ← project recap at session open
    │   ├── activity-log.sh      ← zero-token activity log
    │   └── coach-suggest.sh     ← Coach mode (Stop event suggestions)
    ├── agents/
    │   ├── code-auditor.md      ← read-only code quality audit
    │   └── security-auditor.md  ← OWASP / GDPR / secrets audit
    ├── commands/
    │   ├── ship.md              ← verify + commit + push in one line
    │   ├── audit-quick.md       ← code-auditor + security-auditor in parallel
    │   ├── standup.md           ← morning recap
    │   ├── coach.md             ← "what's the next step?"
    │   ├── coach-mute.md        ← turn off Coach suggestions
    │   └── coach-on.md          ← turn back on
    └── agent-memory/
        └── README.md            ← cross-session memory pattern
```

### How to install the templates

From your project root:

```bash
# 1. Copy the templates
cp -r /path/to/this/repo/templates/CLAUDE.md ./
cp -r /path/to/this/repo/templates/.claude ./

# 2. Append .gitignore additions
cat /path/to/this/repo/templates/.gitignore.sample >> .gitignore

# 3. Make hooks executable
chmod +x .claude/hooks/*.sh

# 4. Customize CLAUDE.md with your project specifics
$EDITOR CLAUDE.md
```

Then launch Claude Code from your project — it picks up everything automatically.

---

## ✨ What you get

After running the templates and reading the guide:

- **Permanent project context** — Claude loads `CLAUDE.md` at every session, you stop re-explaining your stack
- **Defensive hooks** — destructive commands (`rm -rf` on dangerous paths, `--force` pushes, `.env` writes) blocked before execution
- **Auto-format** — files formatted automatically after each edit, zero friction
- **Session recaps** — git state shown when you open a session, no need to type `git status`
- **Specialized sub-agents** — security and code quality audits in their own context
- **Slash commands** — `/ship`, `/audit-quick`, `/standup`, etc. in one line
- **Coach mode** — suggests the right command at the right moment, without polluting the conversation

---

## 🎯 Audience

- Solo devs who code with Claude daily
- Teams who want consistent behavior across machines
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

## 📝 Versioning

This is **Volume 1**. See [`CHANGELOG.md`](CHANGELOG.md) for what's in this release and what's planned for V2.

---

## 🤝 Contributing

Found a factual error, a typo, or a setup that fails in your environment? Open an issue or a PR. This is a living document.

---

## 📄 License

MIT. See [`LICENSE`](LICENSE). Use, share, modify, sell — just keep the copyright notice.

---

## 🙏 Credits

Built by [@TheMiryon](https://github.com/themiryon). Inspired by the Claude Code crash course by Mayank and Anthropic's official documentation.
