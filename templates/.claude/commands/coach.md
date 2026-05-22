---
description: "Analyze repo state and recommend the next command/agent to use"
---

# /coach, What's the next step?

You will analyze the current repo state + the in-progress session, and recommend a concrete next command/agent/action. Read-only, **no modifications**.

To use when the user hesitates, just finished a chantier, or wants a reminder of best practices.

## Procedure

### 1. Repo state (in parallel)

Launch simultaneously:
- `git status --short`, what's modified uncommitted?
- `git diff --stat`, how many lines, in which folders?
- `git log --oneline -5`, what's been pushed recently?
- `git log -1 --stat`, detail of the last commit
- If `.claude/logs/activity.log` exists: `tail -100` to see what the session touched

### 2. Apply Coach triggers

Compare observed state to the triggers defined in CLAUDE.md "Coach mode" section. List matching commands.

Priority triggers (reminder, adapt to your project):
- UI files touched → polish command (e.g., `/loro <file>`)
- Calculations modified → validation command
- Server actions / auth / API → `security-auditor` agent
- DB migrations → `db-schema-reviewer` agent
- ≥ 10 files modified → `/audit-quick`
- Uncommitted, ready to push → `/ship "<msg>"`
- New feature > 5 files incoming → `/new-feature <slug>`

### 3. Structured recommendation

Present this exact format:

```
═══ Coach · chantier state ═══

  Modified uncommitted : N file(s)
  Scope               : [list of main folders touched]
  Last commit         : <sha>, <message>
  Current session     : [one-line summary of what was done since SessionStart]

Recommended actions (by priority):

  1. <command/agent>
     → <reason in one sentence>

  2. <command/agent>
     → <reason>

  3. <command/agent>
     → <reason>

If nothing urgent: keep working, run `/coach` again when you hesitate.
```

Maximum **3 recommendations** simultaneously (more = decision paralysis).

### 4. Action proposal

End with:
> *"Want me to run #1 directly, or prefer to think / do it manually?"*

## Safeguards

- **Strict read-only**: no Edit, no Write, no commit.
- **No judgment** on the quality of work, just procedural orientation.
- If nothing to recommend (working tree clean, recent clean commit) → say it plainly: *"Nothing to flag. Keep going."*
- Don't re-invoke a sub-agent yourself, propose, the user decides.
- Max 1 `/coach` invocation per 5 minutes (otherwise it's self-flagellation).
