---
paths:
  - "src/api/**/*.ts"
  - "src/routes/**/*.ts"
---

# API rules

<!--
  This is a PATH-SCOPED RULE (Handbook, Chapter 11).

  It only enters the context window when Claude reads a file matching one of
  the globs above. That makes it the right home for anything that is true for
  part of the repo but not all of it, and the pressure valve for a CLAUDE.md
  that has grown past 200 lines.

  Drop the `paths:` frontmatter entirely and the rule loads unconditionally,
  at the same priority as .claude/CLAUDE.md.

  Personal rules that should apply in every project go in ~/.claude/rules/
  instead of here.
-->

- Every endpoint validates its input with the shared zod schema in `src/api/schemas/`. Never trust `req.body` directly.
- Errors use the standard envelope `{ error: { code, message } }`. Never `throw` a bare string, and never leak a stack trace to the client.
- Every handler is covered by at least one test asserting the 4xx path, not only the happy path.
- New endpoints are versioned under `/v{n}/`. Changing the shape of an existing response is a breaking change: add a new version instead.

## Why these exist

The envelope and the zod boundary are what let the client treat every failure
the same way. A handler that throws its own shape forces a special case into
every caller, which is how the error handling drifted last time.
