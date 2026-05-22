---
title: Description must be in imperative present tense, lowercase, no trailing period
impact: MEDIUM
impactDescription: "A consistent grammatical voice makes the CHANGELOG readable as a single narrative. Mixed tenses turn it into noise."
tags: format, description, grammar
---

## Imperative present, lowercase, no period

The commit description (after the colon and space) is written in **imperative present tense** — as if completing the sentence "If applied, this commit will…". It starts with a **lowercase** letter and ends **without a period**.

**Incorrect (mixed past, capitalized, with period):**

```
fix(api): Fixed bug where dates were shifted by timezone offset.
```

Three problems: "Fixed" is past tense (sounds like a report), the first letter is capitalized (looks heavy in a list), the period is redundant.

**Correct:**

```
fix(api): fix timezone offset shift on date serialization
```

Imperative ("fix" — what this commit does, not what was done), lowercase start, no period. Reads cleanly as a bullet in a CHANGELOG.

### Why this matters

When the CHANGELOG generator runs `git log --pretty=%s`, it gets a sequence of subject lines. Consistent grammatical voice means the CHANGELOG reads as a unified document:

```
- fix timezone offset shift on date serialization
- add caching layer for /products endpoint
- bump express to 4.21
```

Mixed voice breaks the rhythm:

```
- Fixed timezone offset shift on date serialization.
- Adding caching for products
- Express bumped to 4.21
```

### Edge cases

- **First word is a tool name with a fixed capitalization** (e.g., `GraphQL`, `OAuth`): keep its native casing. `feat(api): support OAuth 2.0 PKCE flow`.
- **Description longer than 72 characters**: that's the cut-off for `git log --oneline`. Move detail to the commit body, leave the subject tight.
- **A bug fix where the bug needs explaining**: subject is the fix, body explains the bug. `fix(api): handle missing TZ offset` + body explaining the failure mode.

### Tools that enforce this

- `commitlint` rules: `subject-case` (set to lowercase), `subject-full-stop` (forbid period), `header-max-length` (set to 72)

Reference: https://chris.beams.io/posts/git-commit/ (the classic "Seven Rules of a Great Commit Message")
