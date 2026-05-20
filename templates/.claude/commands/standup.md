---
description: "Morning recap: done yesterday, WIP, suggested focus, friction"
---

# /standup — Daily solo standup

You will produce a short recap (≤ 200 words) in 3 sections to frame the day. To use at the start of a session, especially after a 24h+ break.

## Procedure

### 1. Collect (in parallel)

- `git log --since='24 hours ago' --oneline` — last 24h commits
- `git log --since='7 days ago' --oneline | head -20` — full week if nothing in 24h
- `git status --short` — uncommitted work in progress
- `git diff --stat` — scope of the WIP
- Read your roadmap file if you have one (e.g. `ROADMAP.md`, `TODO.md`, `src/ROADMAP.md`)
- If a "Definition of Done" or release checklist exists: spot 2-3 priority items unchecked

### 2. Report — strict format

```
═══ Standup · <day of week + date> ═══

🟢 Done yesterday / since last session
  • <commit or major decision>
  • <commit or major decision>

🟡 In progress (working tree)
  • <N files modified, in which folders>
  • <what the diff suggests as intent>

🎯 Focus today (suggestion, not a command)
  • <1 highest-value thing per roadmap + WIP>
  • <1 alternative if the mood isn't there>

⚠️  Friction spotted
  • <blocker if present: red typecheck, broken dep, etc.>
```

### 3. Opening question

End with ONE open question:
> *"Want to tackle focus #1, or do you have something else in mind?"*

## Safeguards

- **Max 3 bullets per section**. Standup discipline = brevity.
- **No judgment** ("should have done X"). Just observation + suggestion.
- **No detailed action plan** — this isn't `/new-feature`. Just orientation.
- If nothing notable in 24h → say so without padding: *"Working tree clean, last push <date>. No visible friction. What are you tackling?"*
- Max 1 invocation of `/standup` per day — otherwise it's procrastination.
