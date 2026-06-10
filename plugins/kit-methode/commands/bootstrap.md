---
description: "Scaffold the per-project kit-méthode overlay (operating-contract, rules skeleton, CLAUDE.md hub, project brief) on top of the generic plugin. Idempotent: previews first, writes only missing files, never overwrites without asking."
argument-hint: "(no args — runs interactively)"
---

# /bootstrap, Lay down the per-project overlay

You scaffold the **overlay** a project needs on top of the generic `kit-methode` plugin. This is the **only kit command that writes files** — so follow the write-safety algorithm below exactly.

> **WRITE-SAFETY (hard rule).** You only ever **create missing files**. You never `Edit` an existing file, never use shell `cp`/`mv`/`>`/`>>` redirection (silent clobber), and never overwrite anything without a per-file explicit confirmation. When in doubt, skip and report.

## 0. Targets

The overlay is exactly these four files (relative to the project root):

| Target | Source |
|---|---|
| `.claude/OPERATING-CONTRACT.md` | assembled (see step 4) |
| `.claude/rules/example.md` | `${CLAUDE_PLUGIN_ROOT}/templates/rule.example.md` |
| `CLAUDE.md` | `${CLAUDE_PLUGIN_ROOT}/templates/CLAUDE.hub.md` |
| `PROJECT_BRIEF.md` | `${CLAUDE_PLUGIN_ROOT}/templates/PROJECT_BRIEF.md` |

## 1. Ask the minimum

Ask the user two things (and nothing else): **project name** and **primary domain** (e.g. "trading indicators", "2D game engine", "SaaS dashboard"). You use these to fill the obvious blanks in the hub and brief. Everything else stays as explicit `<TODO>` markers — **never invent** content.

## 2. Enumerate + test existence

For each of the four targets, test whether the file already exists (`Read` it, or `ls`/`test -f`). Build two sets:
- **CREATE** = targets that do **not** exist.
- **SKIP** = targets that already exist (left untouched by default).

## 3. Preview + confirm

Print the plan, then **wait for an explicit go**:

```
═══ /bootstrap preview ═══
Project: <name>   Domain: <domain>

WILL CREATE:
  + .claude/OPERATING-CONTRACT.md
  + ...
WILL SKIP (already present):
  = CLAUDE.md
```

Ask: *"Create the files in WILL CREATE? (the SKIP ones are left untouched)"* — proceed only on an explicit yes.

## 4. Write — only the CREATE set, file by file

For each target in **CREATE** only, using the `Write` tool (never Edit, never shell redirection):

- **`.claude/rules/example.md`, `CLAUDE.md`, `PROJECT_BRIEF.md`**: copy the corresponding bundled template **verbatim**, then fill only the project-name / domain blanks from step 1. Leave every other `<TODO>` intact.
- **`.claude/OPERATING-CONTRACT.md`** (assembled): **read `${CLAUDE_PLUGIN_ROOT}/templates/operating-contract.md` verbatim** (do NOT paraphrase or regenerate rules 1-5 from memory), then **append** this static block:

  ```markdown

  ## 6. Hard conventions (project)
  <TODO: this project's non-negotiable rules — e.g. "LONG/SHORT enum only",
   "all money via Intl.NumberFormat", "core/ stays pure". These are the 🔴 overlay.>

  ## 7. Sources of truth (project)
  <TODO: the files that decide — e.g. ROADMAP.md, DoD.md, PROJECT_BRIEF.md.
   When code and a source of truth disagree, the source wins.>
  ```

## 5. Report

```
═══ /bootstrap done ═══
Created: <n> file(s)
Skipped: <m> file(s) (already present — untouched)

Next:
  • Fill the <TODO> markers (start with PROJECT_BRIEF.md, then OPERATING-CONTRACT §6-7).
  • Adapt .claude/rules/example.md to a real zone (rename it).
  • Set the kit-methode userConfig (test_cmd / format_cmd) to match your stack.
```

## Safeguards

- **Create-only**: never `Edit`/overwrite an existing file; SKIP it and report. Regenerating a present file requires a separate, explicit per-file confirmation.
- **No shell clobber**: use the `Write` tool, never `cp`/`>`/`>>`.
- **No invention**: fill only project name + domain; everything else stays `<TODO>`.
- **Contract is verbatim**: rules 1-5 come from the bundled file unchanged; you only append the §6-7 placeholder block.
- **Scope**: write nothing outside `.claude/` and the two named root files. `domain-agent` / `domain-check` templates are a later version — don't scaffold them here.
