---
description: "Temporarily disable the Coach (end-of-session suggestions)"
---

# /coach-mute, Turn off the Coach

You will disable the `coach-suggest.sh` Stop hook that prints end-of-session suggestions. Useful when you know what you're doing and the reminders become noise.

## Procedure

1. Create an empty file `.claude/coach-mute` at the repo root:
   ```bash
   touch .claude/coach-mute
   ```
2. Confirm to the user:
   > *"Coach mute: ON. No more end-of-session suggestions until `/coach-on`."*

3. Remind that `.claude/coach-mute` is gitignored, local to the machine, doesn't pollute the repo.

## Safeguards

- Don't disable other hooks (PreToolUse, PostToolUse, SessionStart stay active).
- If the file already exists → confirm "already muted" and exit without action.
