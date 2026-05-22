# Agent Memory, versioned cross-session memory

> Pattern from Claude Code's official `memory: project` / `memory: user` / `memory: local`
> frontmatter support. Cf. `code.claude.com/docs/en/sub-agents#enable-persistent-memory`.

## Why

A sub-agent re-starts each invocation with a fresh context. It doesn't remember yesterday's audit findings, last week's architecture decisions, or the implicit conventions you've established along the way. Persistent memory fixes this gap.

## When to enable memory

The `memory:` frontmatter field is most valuable for **audit-heavy** sub-agents:
- `security-auditor` remembers which RLS policies have been validated, doesn't re-flag them
- `domain-expert` builds a base of "validated formulas/conventions" specific to your project
- `code-auditor` retains project-specific accepted exceptions ("any" allowed in chart formatters, etc.)
- `design-reviewer` remembers validated deviations from the design system

## How to enable

Add to the agent's YAML frontmatter:

```yaml
---
name: security-auditor
description: ...
memory: project    # or: user, or: local
---
```

When `memory:` is set, Claude Code:
- Creates the memory directory automatically on first use
- Injects read/write instructions into the sub-agent's system prompt
- Auto-loads the first 200 lines or 25KB of `MEMORY.md` at every invocation
- Activates Read, Write, and Edit tools so the agent can manage its memory files

## Memory scopes

| Scope | Location | When |
|---|---|---|
| `user` | `~/.claude/agent-memory/<name>/` | Cross-project knowledge (preferences, reusable patterns) |
| `project` | `.claude/agent-memory/<name>/` | Project knowledge, versioned in git, team-shareable (recommended default) |
| `local` | `.claude/agent-memory-local/<name>/` | Project knowledge but sensitive, gitignored |

## File structure

```
.claude/agent-memory/
└── <agent-name>/
    ├── MEMORY.md              ← INDEX. Auto-loaded at every invocation (first 200 lines or 25KB)
    │                            One line per memory: "- [Title](file.md), one-line hook"
    ├── feedback_<topic>.md    ← User corrections / validations
    ├── project_<topic>.md     ← Decisions, deadlines, motivations
    ├── reference_<topic>.md   ← Pointers to external systems (Linear, Grafana, Slack)
    └── user_<topic>.md        ← User profile/preferences (rare)
```

## The 4 memory types

| Type | When to write | Example |
|---|---|---|
| **feedback** | User corrects OR confirms a non-obvious approach | "No DB mocks in integration tests. Why: Q3 incident where mock/prod divergence masked a broken migration." |
| **project** | Decisions, deadlines, motivations not in the code/git | "Auth rewrite driven by legal/compliance, not tech debt. Scope decisions favor compliance over ergonomics." |
| **reference** | Pointers to external systems | "Bug tracking: Linear project INGEST. Grafana board for latency: grafana.internal/d/api-latency" |
| **user** | User profile/preferences | "Prefers terse responses. No trailing summaries." |

## File format

Each file (except `MEMORY.md`) starts with a YAML frontmatter:

```markdown
---
name: <short title>
description: <one line, used to decide relevance in future conversations>
type: feedback | project | reference | user
---

<content>

For feedback and project, recommended structure:
- The rule/fact in one sentence
- **Why:** reason (often a past incident or strong preference)
- **How to apply:** when/where this memory kicks in
```

## `MEMORY.md` format (the index)

No frontmatter. One line per memory, < 150 characters:

```markdown
- [No DB mocks in integration tests](feedback_db_tests.md), Q3 migration incident
- [RLS Supabase validated 14.05](project_rls_audit.md), don't re-flag validated policies
- [Linear INGEST = pipeline bugs](reference_linear.md), check before duplicates
```

The index is loaded in full; detail files are read on demand.

## What NOT to write to memory

- Code patterns, conventions, architecture, file paths → can be derived by reading the current code
- Git history, recent changes, who-changed-what → `git log` / `git blame` are authoritative
- Debugging solutions or fix recipes → the fix is in the code, context is in the commit message
- Anything already documented in CLAUDE.md
- Ephemeral task details: in-progress work, current conversation context
- **Secrets, tokens, API keys, third-party user PII** (this folder is versioned in git for `project` scope)

## Safeguards

- **Before recommending from memory**: verify the file/function mentioned still exists (`grep` or `Read`). Memory is a snapshot at a point in time, not current truth.
- **Memory vs plan vs tasks**: memory is for cross-conversation knowledge. Plans are for the current conversation. Tasks are for step-by-step progress.
- **No secrets** in versioned memory (use `local` scope or env vars instead).
- **No third-party PII** (GDPR risk).
