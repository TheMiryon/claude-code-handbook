---
title: Clear, action-oriented title (e.g., "Every commit must start with a type prefix")
impact: HIGH | MEDIUM | LOW
impactDescription: "1 line explaining the impact of NOT following this rule (e.g., 'Without a type, CHANGELOG generators skip the commit.')"
tags: format, type, breaking
---

## [Rule title]

[1-2 sentences explaining what the rule says and why it matters. No academic preamble.]

**Incorrect (the trap):**

```
[Bad commit message example]
```

[1 sentence on what's wrong and what the consequence is.]

**Correct:**

```
[Good commit message example]
```

[1 sentence on why this version is better.]

### Edge cases

- [Specific edge case 1 + how to handle it]
- [Specific edge case 2 + how to handle it]

### Tools that enforce this

- `commitlint` rule: [rule name if applicable]
- Husky `commit-msg` hook snippet: [if applicable]

Reference: [link to canonical source]
