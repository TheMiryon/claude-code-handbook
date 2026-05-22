---
description: "Extract 1-3 lessons from a commit and pin them to CLAUDE.md (versioned), instead of relying on local-only memory."
argument-hint: "[short-sha | empty for HEAD]"
---

# /extract-lesson — Make a lesson stick

Inspired by Boris Cherny's principle: *"Anytime we see Claude do something incorrectly, we add it to CLAUDE.md so it doesn't repeat next time."* Extended here to *"any time we learn something non-obvious"*.

Difference vs `~/.claude/projects/.../memory/`: those are **local** to the machine, lost on reclone or machine change. `CLAUDE.md` is **versioned**, so it survives reclones and is shared with any future teammate.

## Procedure

### 1. Target the commit

`$ARGUMENTS` = short SHA (e.g. `abc1234`). If empty, target `HEAD`.

Read:
- `git show <sha> --stat` for scope
- `git show <sha>` for the full diff
- The commit message in full

### 2. Decide whether a lesson is actually worth pinning

**A lesson is worth pinning if it matches ≥ 1 of these:**
- A non-obvious gotcha that someone else (or future you) would re-discover painfully
- An implicit project convention not documented anywhere yet
- An architectural decision settled by this PR/commit
- A workaround specific to a framework or library version

**A lesson is NOT worth pinning if:**
- The "what" is already in the commit message
- Implementation details that `git blame` would find
- Conventions already documented in `CLAUDE.md` or in an existing skill

If, after reading the diff, nothing fits the criteria, say so honestly:

> *"Commit `<sha>` analyzed — nothing non-obvious to extract. The message + the diff are self-sufficient. No lesson added."*

And stop.

### 3. Write 1 to 3 lessons (max)

Format for each lesson — short, actionable:

```markdown
- **<Short, action-oriented title>** (commit `<sha>`)
  - **Observation:** <one sentence>
  - **Why:** <one sentence>
  - **Rule:** <one imperative sentence>
```

If more than 3 lessons seem extractable from the same commit, it's probably that the commit was doing several things at once (and should have been several commits). Keep the 3 most impactful and flag this to the user.

### 4. Append to `CLAUDE.md`

Find or create a `## 📚 Lessons learned` section at the bottom of the file (or in `src/CLAUDE.md` if the hub has been split). Add the lesson(s) at the top of the section (most recent first), under a date header:

```markdown
## 📚 Lessons learned

### [DD.MM.YY]

- **<Title>** (commit `<sha>`)
  - **Observation:** ...
  - **Why:** ...
  - **Rule:** ...

### [earlier date]
...
```

### 5. Confirm to the user

```
═══ /extract-lesson : <sha> ═══

📚 N lesson(s) added to CLAUDE.md:
  1. <title>
  2. <title>

Suggested next:
  → /ship "docs(claude): lessons from <sha>"
  or: keep working, I wrote — not committed.
```

## Guardrails

- **Never** add a lesson that exposes a secret (API keys, private schema, etc.). `CLAUDE.md` is versioned.
- **Never** add a lesson that names a competing product. Generic technical references only.
- **Never** duplicate a lesson already present in `CLAUDE.md` or in an existing skill. Grep first.
- **When in doubt**, ask the user before writing: *"I'm proposing to add X — you validate?"*
- **Stay under 3 lessons per commit.** Beyond that, the section becomes unreadable.
