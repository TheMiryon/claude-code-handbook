---
description: "Backward-looking retrospective over a period or chantier: what worked, what hurt, surprises, and concrete process actions. Read-only."
argument-hint: "[period: e.g. '7 days', 'since <sha>', or a PLAN_<slug>.md]  (default: 7 days)"
---

# /retro, Look back and improve the process

You will run a short **retrospective** to improve how the work is done — not the code itself. Read-only, **no modifications**.

This is distinct from its neighbours:
- `/standup` looks **forward** (frame today). `/retro` looks **backward** (learn from a stretch of work).
- `/extract-lesson` pins a **technical** lesson to `CLAUDE.md`. `/retro` reflects on **process** (cadence, friction, decisions) and may *point* to `/extract-lesson` for anything worth making durable.

## 1. Scope the window

`$ARGUMENTS` sets the window: a duration (`7 days`), `since <sha>`, or a `PLAN_<slug>.md` (retro on one chantier). Default: last 7 days.

## 2. Collect (in parallel, read-only)

- `git log --since='<window>' --oneline` (or `<sha>..HEAD`) — what shipped.
- `git log --since='<window>' --stat --pretty=format:'%h %s'` — scope/shape of changes.
- If `.claude/logs/activity.log` exists: scan it for the window — agents used, retries, churn (files edited many times = friction signal).
- Any `PLAN_*.md` touched in the window — was the plan followed, or did scope drift?
- The commit cadence: bursts, reverts, "fix typo" chains, `wip` commits = process smells.

## 3. Report — strict format

```
═══ Retro · <window> ═══

🟢 What worked
  • <a habit/decision/tool that paid off — be specific, cite a commit/file>

🔴 What hurt
  • <friction: rework, a plan that drifted, a missing check, a painful debug>

💡 Surprises / learnings
  • <something non-obvious that emerged>

🎯 Process actions (max 3, concrete)
  • <one change to HOW you work next stretch — e.g. "smaller commits", "run /audit-quick before ship">
    → if a learning is technical & durable: "consider /extract-lesson on <sha>"
```

Keep each section to **3 bullets max**. A retro that lists 10 things changes nothing.

## 4. Closing

End with one question:
> *"Want to turn any process action into a habit (CLAUDE.md / a hook), or pin a technical learning with /extract-lesson?"*

## Safeguards

- **Strict read-only**: no Edit, no Write, no commit. You observe and reflect.
- **No blame, no rewriting history** ("should have…"). Observation → forward action only.
- **Process, not code review**: for code quality use `/audit-quick`; for a single bug use direct inspection. `/retro` is about *how* the work went.
- If the window is empty (no commits, no activity) → say so plainly and stop; don't manufacture a retro.
