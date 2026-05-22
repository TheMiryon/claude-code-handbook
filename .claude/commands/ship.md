---
description: "Verify + commit + push in one command"
argument-hint: "<commit message>"
---

# /ship — Verify, commit & push

You will deploy a commit following **strictly** this procedure.

## 1. Pre-check

Run the typecheck command (e.g. `pnpm verify`, `npm run typecheck`, `mypy`, `tsc --noEmit`).
**If red → STOP immediately**, display the errors, ask the user whether to fix or abandon.
Never commit with a red typecheck.

## 2. Git state

Run `git status --short` and `git diff --stat`. Display:
- the modified files
- a summary of the diff

If zero files modified → display "Nothing to commit" and stop.

## 3. Build the commit

The commit message = `$ARGUMENTS` (what the user typed after `/ship`).

If `$ARGUMENTS` is empty or too short (< 10 characters), ask for a more precise message.

Format the commit in the project's canonical style (cf. `git log --oneline -5`):
- First line short (≤ 70 characters), no trailing period
- Prefix `feat:` / `fix:` / `refactor:` / `docs:` / `chore:` as appropriate
- Optional body (1-2 lines max) if explaining the why is necessary

## 4. Stage + commit + push

Execute in this order:
1. `git add` of the relevant files (not blind `git add .`)
2. `git commit -m "..."` with the built message
3. `git push origin <target branch>`

## 5. Confirmation

Display:
- the SHA of the created commit
- the message
- a "X file(s), Y insertions, Z deletions" summary
- any warnings from the push (e.g. deploy preview link)

## Safeguards

- **Never** use `--no-verify` (skip pre-commit hooks) unless the user explicitly requests it
- **Never** force-push (`-f` / `--force`) without explicit confirmation
- If `<verify>` fails with a missing dependency, suggest the install command but don't run it automatically
- If push fails (rejected), pull with `--no-rebase`, resolve conflicts if needed, then re-push
