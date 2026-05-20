---
description: "Re-enable the Coach (end-of-session suggestions)"
---

# /coach-on — Turn the Coach back on

You will re-enable the `coach-suggest.sh` Stop hook by removing the mute flag.

## Procedure

1. Remove `.claude/coach-mute` if it exists:
   ```bash
   rm -f .claude/coach-mute
   ```
2. Confirm to the user:
   > *"Coach mute: OFF. Suggestions resume at the next end of turn."*

3. If the file didn't exist → say "Coach was already active, no action needed."

## Safeguards

- `rm -f` doesn't fail if absent — intentional.
- No side effects: no other files touched.
