---
title: Scope is optional but strongly recommended on multi-module repos
impact: MEDIUM
impactDescription: "Without scope on a 20-module monorepo, the CHANGELOG becomes a chronological wall of changes with no way to filter to your area."
tags: format, scope
---

## Scope is optional, recommended in monorepos

The scope sits in parentheses between the type and the colon: `feat(api): …`. It localizes the change to a part of the codebase. On a single-module project the scope is often omitted; on a monorepo or a multi-package repo, it's essential.

**Incorrect (in a monorepo):**

```
feat: add caching layer
```

Where? `api`? `frontend`? `cli`? A reviewer skimming `git log` has to read the diff to find out. Multiplied across 50 commits per week, this is real time lost.

**Correct:**

```
feat(api): add caching layer for /products endpoint
```

Scope (`api`) + a description that adds locality (`for /products endpoint`). The reviewer knows in 5 seconds whether this affects them.

### Edge cases

- **A change that legitimately spans multiple scopes**: pick the dominant one and mention the others in the body: `feat(api,db): add caching, schema for cache_entries`. Most commitlint configs reject this — prefer splitting if you can.
- **A repo with no obvious scopes**: don't invent them. Skip scope entirely until natural boundaries emerge.
- **A breaking change**: scope still goes between type and `!` marker: `feat(api)!: …`.

### Tools that enforce this

- `commitlint` rule: `scope-enum` (with a configured list of valid scopes)
- `commitlint` rule: `scope-empty` (set to "never" to require a scope)

Reference: https://www.conventionalcommits.org/en/v1.0.0/#specification
