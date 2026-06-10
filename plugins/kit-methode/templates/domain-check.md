---
description: "Run the __DOMAIN__ domain expert over the relevant files (read-only)."
argument-hint: "[files or area to check]  (default: changes since last commit)"
---

# /__DOMAIN_SLUG__-check, __DOMAIN__ check

You will invoke the `__DOMAIN_SLUG__-expert` agent to review __DOMAIN__ correctness. Read-only, **no modifications**.

## Procedure

1. **Scope**: `$ARGUMENTS` (files or area). If empty, use files changed since the last commit (`git diff --name-only HEAD`).
2. **Invoke** the `__DOMAIN_SLUG__-expert` agent on that scope (read-only audit).
3. **Present** its findings ranked by severity, and recommend the single highest-value fix.

## Safeguards

- **Read-only**: no Edit/Write/commit. The agent proposes; you don't apply.
- **__DOMAIN__-specific only**: for general code quality use `/audit-quick`, for security use `security-auditor`.
- If the scope is empty (nothing changed) → say so and stop.
