---
# Path-scoped rule (kit-méthode overlay example).
# Loaded only when Claude touches files matching the `paths` globs below.
# Copy/rename this file per coherent zone of your project (one rule = one zone).
paths:
  - "src/<zone>/**"   # TODO: the glob(s) this rule governs
---

# Rule: <zone name>   <!-- TODO -->

## Context
<!-- TODO: what this zone is and why it needs special rules (2-3 lines). -->

## Must
<!-- TODO: hard constraints when editing this zone.
     e.g. "Pure functions only — no I/O, no global state."
          "Every public function has a return type." -->

## Must not
<!-- TODO: anti-patterns to refuse here.
     e.g. "Never import the network/UI layer from this zone."
          "No magic numbers — use named constants." -->
