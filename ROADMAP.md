# Roadmap

Forward-looking scope for the handbook. The original V3 ranked list is now fully shipped.

## Shipped in V3.0 (June 2026)

- ✅ **Testing & TDD** → Chapter 14
- ✅ **Recovery playbook** → Annex J
- ✅ **Third-party MCP & prompt-injection security** → Chapter 16 (was 15)

(All three live in Part VI, "Discipline & safety".)

## Shipped in V3.1 (June 2026)

- ✅ **Plugins & marketplaces** (+ `/loop` & Routines) → Chapter 17 (was 16), Part VII "Packaging & distribution"

## Shipped in V4.0 (September 2026)

The remaining ranked items, plus everything the product added between June and September 2026.

| Was rank | Topic | Landed as |
|---|---|---|
| 4 | **Windows & cross-platform hooks** | Annex L, with Python and PowerShell versions of the guard hook |
| 5 | **Onboarding an existing codebase** | Annex K |
| 6 | **Context-window management** | Chapter 20 |
| 7 | **Headless mode & CI integration** | Chapter 21 |

Off the original list, but required because the product moved:

- ✅ **Permissions, auto mode & the sandbox** → Chapter 15. Auto mode became the default permission mode in August 2026; the book's guardrail chapters described the old world.
- ✅ **Working in parallel** → Chapter 18 (agent view, agent teams, cross-session messaging, `/batch`)
- ✅ **Dynamic workflows** → Chapter 19
- ✅ **Auditing your own setup** → Chapter 22 (`/doctor`, `/skill-doctor`, `claude plugin eval`)
- ✅ **Artifacts** → Chapter 23
- ✅ **Auto memory + path-scoped rules** → Chapter 11, memory matrix grown from 4 to 6 locations

## V4.1+: Tentative scope

| Topic | Why it might earn a place |
|---|---|
| **Agent SDK** | The book stops at the CLI. Building a custom agent on Claude Code's tools is a different audience, but a real one. Currently out of scope; revisit if readers ask. |
| **Self-hosted & enterprise deployment** | Managed settings, gateways, `managedMcpServers`. Relevant to teams, irrelevant to the solo reader the book is written for. Probably an appendix at most. |
| **A trimmed "essentials" edition** | V4 is ~125 pages, double V2. The three reading paths help, but a genuine 40-page "essentials" cut may serve newcomers better than a longer book. |
| **Computer use & Chrome** | Covered in one line in Chapter 00. Could justify a short chapter if it stabilizes. |

## Out of scope

- Translations beyond EN / FR
- IDE-specific deep-dives (VS Code, JetBrains, iOS, etc.), covered briefly, not as chapters
- A companion video course

## How to suggest a topic

Open an issue with the label `v4-scope` (or comment on an existing one). PRs welcome for typos and corrections in the meantime.
