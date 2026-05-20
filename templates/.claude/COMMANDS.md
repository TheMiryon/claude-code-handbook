# Slash commands

> Index of custom commands in `.claude/commands/`, organized by use case.
> Read this when in doubt about "which command to use now".

## Quick decision table

| You want to… | Command |
|---|---|
| Push to your target branch (verify + commit + push in 1 line) | `/ship "<message>"` |
| Audit code + security before a release | `/audit-quick` |
| Get a morning recap (24h commits, WIP, suggested focus) | `/standup` |
| Know the next step (you hesitate) | `/coach` |
| Turn off Coach end-of-session suggestions | `/coach-mute` |
| Turn Coach back on | `/coach-on` |

## Disambiguating similar commands

### `/audit-quick` vs `/coach`

- **`/audit-quick`** = full audit (code + sécu) via 2 sub-agents in parallel. ~3-5 min, longer output. Use **before a push that matters**.
- **`/coach`** = read repo state and recommend max 3 next actions. Fast (~30s), short output. Use when you **hesitate** on the next step.

### `/ship` vs manual git commands

- **`/ship "<msg>"`** = daily push workflow (verify + commit + push) with built-in guards (no `--no-verify`, no `--force`, proper rebase on rejection). Use this 99% of the time.
- Manual `git commit` + `git push` = only when you need very specific control (cherry-pick, amend, etc.).

## Common combos

- **End of large chantier**: implement → `/audit-quick` (fix 🔴) → `/ship "<msg>"`
- **Before public deployment**: `/audit-quick` → fix 🔴 → run tests → `/ship`
- **Morning routine**: `/standup` → pick focus → start coding

## Maintenance of this index

Update when:
- A new command is added to `.claude/commands/`
- A command is renamed or removed
- A new combo emerges in practice

The Coach mode (in CLAUDE.md, "Coach mode" section) references these commands for its automatic triggers. Keep both in sync.
