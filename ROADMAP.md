# Roadmap

Forward-looking scope for the next version of the handbook. The order below is the current best guess — it may shift as work begins, but ranks #1–#3 are the planned anchors of V3.

## V3 — Tentative scope

| Rank | Topic | Why it's prioritized |
|---|---|---|
| 🥇 | **Testing discipline & TDD** | The biggest blind spot in V2 — the guide repeats "run `verify`" everywhere without ever teaching how to write the tests. The setup doesn't hold up in a team without test-first reflexes. |
| 🥈 | **Recovery playbook** | Short (one annex), highly actionable, missing from every other Claude Code guide online. Real differentiation — V2 is strong on guardrails *before* damage but silent on what to do *after*. |
| 🥉 | **Third-party MCP & prompt-injection security** | The fastest-growing risk in 2026 and the gap most other guides ignore. Covers the risk of arbitrary code via `npx -y` skills/MCP servers, plus prompt injection via files or web pages Claude reads. |
| 4 | **Windows & cross-platform hooks** | V2's hooks are bash + jq only. Add Python (and where possible PowerShell) hook examples as an annex so Windows readers stop hitting friction at install time. |
| 5 | **Onboarding an existing codebase** | V2 assumes a project configured cleanly from scratch. Most readers have legacy code — V3 will add a discovery strategy for large existing repos. |
| 6 | **Context-window management** | When to `/compact`, when to `/clear`, and at what fill rate precision starts to drop. More advanced; can wait. |
| 7 | **Headless mode & CI integration** | `claude -p`, automated PR review, GitHub Actions. Niche but real — last in the queue. |

## Out of scope (for V3)

- Translations beyond EN / FR
- IDE-specific deep-dives (VS Code, JetBrains, iOS, etc. — covered briefly, not as chapters)
- A companion video course

## How to suggest a topic

Open an issue with the label `v3-scope` (or comment on an existing one). PRs welcome for typos and corrections in V2 in the meantime.
