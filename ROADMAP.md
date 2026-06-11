# Roadmap

Forward-looking scope for the handbook. Ranks #1–#3 **shipped as V3.0** (June 2026); #4–#7 are the queue for V3.1+.

## Shipped in V3.0

- ✅ **Testing & TDD** → Chapter 14
- ✅ **Recovery playbook** → Annex J
- ✅ **Third-party MCP & prompt-injection security** → Chapter 15

(All three live in the new Part VI, "Discipline & safety".)

## V3.1+: Tentative scope

| Rank | Topic | Why it's prioritized |
|---|---|---|
| 4 | **Windows & cross-platform hooks** | V2's hooks are bash + jq only. Add Python (and where possible PowerShell) hook examples as an annex so Windows readers stop hitting friction at install time. |
| 5 | **Onboarding an existing codebase** | V2 assumes a project configured cleanly from scratch. Most readers have legacy code. V3 will add a discovery strategy for large existing repos. |
| 6 | **Context-window management** | When to `/compact`, when to `/clear`, and at what fill rate precision starts to drop. More advanced; can wait. |
| 7 | **Headless mode & CI integration** | `claude -p`, automated PR review, GitHub Actions. Niche but real: last in the queue. |

## Out of scope (for V3)

- Translations beyond EN / FR
- IDE-specific deep-dives (VS Code, JetBrains, iOS, etc.), covered briefly, not as chapters
- A companion video course

## How to suggest a topic

Open an issue with the label `v3-scope` (or comment on an existing one). PRs welcome for typos and corrections in V2 in the meantime.
