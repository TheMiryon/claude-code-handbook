---
name: conventional-commits
description: Conventional Commit format rules (type, scope, description, breaking change marker) with Incorrect → Correct examples. Use this skill when writing a commit message, reviewing a PR's commits, designing a CHANGELOG-from-git workflow, or configuring a commit linter.
license: MIT
metadata:
  author: claude-code-handbook
  version: "1.0.0"
  date: 2026-05
  abstract: Reference catalog for the Conventional Commits format, with one
    rule per file under references/. Each rule shows an incorrect example
    (the trap) before the correct one. Designed to be loaded by a
    commit-reviewer agent or referenced from a /ship slash command.
---

# Conventional Commits — skill reference

Canonical rules for the Conventional Commits format (https://www.conventionalcommits.org/). One single source of truth: if an agent or a slash command needs to validate a commit message, it loads this skill.

## When to apply

- Writing a commit message
- Reviewing the commits in a pull request
- Generating a CHANGELOG from git history
- Configuring `commitlint`, `husky` commit-msg hook, or equivalent
- Onboarding a new contributor to the convention

## Rule categories

| Priority | Category | Impact | Prefix |
|----------|----------|--------|--------|
| 1 | Message format | HIGH | `format-` |
| 2 | Breaking changes | HIGH | `breaking-` |
| 3 | Tooling integration (future) | MEDIUM | `tooling-` |

## How to use

Read individual rule files for explanation + Incorrect/Correct examples:

```
references/format-type-required.md
references/format-scope-optional.md
references/format-description-imperative.md
references/breaking-change-marker.md
references/_sections.md       ← category definitions
references/_template.md       ← template for new rules
references/_contributing.md   ← style guide for new rules
```

## References

- https://www.conventionalcommits.org/en/v1.0.0/
- https://github.com/angular/angular/blob/main/CONTRIBUTING.md
- https://keepachangelog.com/
