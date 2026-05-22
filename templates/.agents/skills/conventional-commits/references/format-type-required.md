---
title: Every commit message must start with a type prefix
impact: HIGH
impactDescription: "Without a type, CHANGELOG generators skip the commit or bucket it under 'Other', and reviewers can't filter the diff by feature/fix/refactor."
tags: format, type, prefix
---

## Type prefix required

The first token of the commit subject line must be one of the recognized commit types: `feat`, `fix`, `refactor`, `docs`, `chore`, `test`, `style`, `perf`, `build`, `ci`, `revert`. The type is followed by an optional scope in parentheses, then a colon and a space, then the description.

**Incorrect (the trap):**

```
Add login form validation
```

No type. Tools that auto-generate a CHANGELOG (semantic-release, conventional-changelog, release-please) will either skip this commit entirely or put it under a catch-all "Other" section. A reviewer scanning git history can't tell whether this is a feature or a bug fix without reading the diff.

**Correct:**

```
feat(auth): add login form validation
```

`feat` declares a new feature; `(auth)` localizes it; the description is in imperative present tense (see `format-description-imperative.md`).

### Edge cases

- **A revert commit**: `revert: feat(auth): add login form validation`. The original message is preserved after `revert:` so you can trace what was undone.
- **A merge commit**: skip the convention, merges are auto-generated and downstream tools ignore them anyway.
- **A commit that's both feat and fix**: it's actually two commits. Split them.
- **A commit with no clean category**: use `chore` as the fallback, never invent a new type. `chore` is the universal "maintenance / nothing user-visible" type.

### Tools that enforce this

- `commitlint` rule: `type-enum`, accepts a configured list of types
- Husky `commit-msg` hook: `npx --no-install commitlint --edit "$1"`
- semantic-release: refuses to publish if no commits match a recognized type

Reference: https://www.conventionalcommits.org/en/v1.0.0/#specification
