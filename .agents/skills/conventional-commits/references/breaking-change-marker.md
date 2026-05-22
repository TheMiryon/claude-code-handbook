---
title: Breaking changes must be signaled with `!` and BREAKING CHANGE footer
impact: HIGH
impactDescription: "Without the marker, semver auto-bumpers ship a minor/patch when they should ship a major. Downstream consumers break silently."
tags: breaking, semver, footer
---

## Breaking change marker

A commit that introduces a backwards-incompatible change must signal this in **two places**: a `!` between the scope (or type) and the colon, AND a `BREAKING CHANGE:` footer with details.

**Incorrect (silent breaking change):**

```
feat(api): replace cookies with JWT tokens
```

This is a feature, yes, but it breaks every existing client that relied on cookie auth. Without the `!` marker, semantic-release will ship this as a minor version bump (`1.4.0` → `1.5.0`), and existing consumers will upgrade transparently and break at runtime.

**Correct:**

```
feat(api)!: replace cookies with JWT tokens

BREAKING CHANGE: cookie-based session authentication is removed.
Clients must now obtain a JWT via POST /auth/login and pass it as
`Authorization: Bearer <token>` on every request. Existing sessions
are invalidated.

Migration guide: docs/migration/v2-jwt.md
```

The `!` makes the breaking change visible in `git log --oneline`. The `BREAKING CHANGE:` footer gives downstream consumers the why and a migration path. Semantic-release will correctly bump the major version (`1.4.0` → `2.0.0`).

### Edge cases

- **A "soft" breaking change** (a deprecation that will become breaking later): use `feat(api): deprecate cookies, add JWT support` with no `!` yet. Mark `!` only when the deprecation lands.
- **Multiple breaking changes in one commit**: list each in the footer. One `BREAKING CHANGE:` line per change, or one block with bullet points.
- **A breaking refactor with no user-visible change**: still mark it. Internal consumers (other modules, plugins) may break. The convention is conservative on purpose.
- **Reverting a breaking change**: `revert: feat(api)!: replace cookies with JWT tokens`, the revert is itself breaking (in the reverse direction).

### Tools that enforce this

- `commitlint` rule: `subject-exclamation-mark` (require `!` when footer has `BREAKING CHANGE:`, and vice versa)
- semantic-release: `releaseRules` configuration to map `!` to major version bump
- `release-please`: detects `BREAKING CHANGE:` footer and bumps accordingly

Reference: https://www.conventionalcommits.org/en/v1.0.0/#specification (section "Specification" item 11–13)
