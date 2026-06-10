---
description: "Audit a project's Claude Code setup (.claude/ + active plugins) and propose evidence-backed improvements from official Anthropic sources. Read-only, never applies changes."
argument-hint: "[local | external | all]  (default: all)"
---

# /audit-claude-setup, Audit & enrich your Claude Code setup

You will audit how this project uses Claude Code and **propose** improvements. You **never apply** anything.

`$ARGUMENTS` selects the scope: `local` (Part A only — no network), `external` (Part B only), or `all` / empty (both). Use `local` when offline.

> **READ-ONLY, PROPOSE-ONLY (hard rule).** No `Edit`, no `Write`, no `git` mutation, no file created. You produce a report. The user applies what they want, themselves. This is a *prompt convention*, not a sandbox: honour it strictly.

---

## Part A — Local audit (deterministic, authoritative)

Skip if `$ARGUMENTS` = `external`. This part needs no network; its findings are authoritative.

### 1. Discover the setup

- Read the project's `.claude/`: `settings.json` (+ `settings.local.json`), `hooks/`, `agents/`, `commands/` (and/or `skills/`), `CLAUDE.md` (+ any `@`-imports).
- List the active plugins: run `claude plugin list` (and read the installed kit-methode plugin if present). The discipline may live in a **plugin** (cache), not in `.claude/` — cover both sources.

### 2. Coherence checks

For each, report file:line and a one-line fix. Rank 🔴 (broken) / 🟠 (risky) / 🟡 (smell) / 🟢 (ok) / ℹ (info).

- **Hooks ↔ wiring**: every hook command in `settings.json` / `hooks/hooks.json` points to a script that **exists**. Flag wired-but-missing (🔴) and present-but-unwired (🟠).
- **Frontmatter**: every command/agent `.md` has a non-empty `description`. Agents have a valid `name`. Flag missing/malformed YAML.
- **Dead anchors / broken cross-references**: a command/hook/CLAUDE.md that references `/x`, an agent, or a file path that does not resolve. (Note: a plugin namespaces commands as `/<plugin>:x` — a bare `/x` reference is a smell, not necessarily broken, when the command is plugin-provided.)
- **Duplication standalone ↔ plugin**: the same command/agent present both in `.claude/` and in an enabled plugin → namespacing/precedence confusion. Classify ℹ/🟠 with the explanation (this is sometimes a legitimate dogfood, not an automatic 🔴).
- **Settings hygiene**: destructive-command guards present (`rm -rf`, `--force`, `--no-verify`, `.env`)? Permissions sane? Secrets never referenced in plaintext.
- **Path portability**: plugin hook scripts use `${CLAUDE_PLUGIN_ROOT}` / `${CLAUDE_PROJECT_DIR}` (not relative `../`); `.sh` scripts kept LF (a `.gitattributes` enforcing it).

**Never print the contents of `.env*` or any secret** while auditing.

---

## Part B — External scan (best-effort, evidence-backed suggestions)

Skip if `$ARGUMENTS` = `local`. This part depends on the network and is **never authoritative** — present it as suggestions, clearly separated from Part A.

### 1. Detect the installed version

- Run `claude --version` (best-effort). Keep the version string for comparison.

### 2. Fetch the official sources (and only these)

- Changelog: `https://code.claude.com/docs/en/changelog`
- Docs index: `https://code.claude.com/docs/llms.txt` → then the **core** pages relevant to setup: plugins, hooks, skills, settings, sub-agents.
- (Do **not** fetch SDK source files — out of scope for a discipline-setup audit.)

If a fetch fails (offline, tool unavailable): **say so plainly, skip Part B, and still deliver Part A.** Do not guess.

### 3. Compare and propose

Compare the fetched material against what Part A found in the setup. For each gap (a capability the docs/changelog describe that the setup doesn't use, or a newer idiom than the setup follows):

**Evidence rule (mandatory — anti-hallucination).** Every proposal MUST carry:
- the **source URL** you actually fetched, AND
- a **quoted snippet/line** from that fetched content that directly supports the proposal.

If the fetched content does **not** directly support a claim, emit it as a 🔵 **question**, never as a proposal. A URL with no quoted evidence is forbidden. Never rely on your own memory of Claude Code features — only on fetched text.

For each valid proposal, give the **exact diff/snippet to apply** — but do **not** apply it.

---

## Output format

```
═══ /audit-claude-setup ═══  (scope: <local|external|all>)

──── A. LOCAL SETUP (authoritative) ────
🔴 Blockers
  • <file:line> — <issue> — fix: <one line>
🟠 Risks   / 🟡 Smells   / ℹ Info
  • ...
🟢 What's healthy
  • ...

──── B. EXTERNAL (evidence-backed suggestions, not authoritative) ────
Installed: claude <version | "unknown">   |   Sources fetched: <list, or "NONE — skipped">

💡 Proposal: <title>
   Source : <fetched URL>
   Evidence: "<quoted line/snippet from that page>"
   Proposed diff (NOT applied):
     + <...>
🔵 Questions (unconfirmed by fetched content)
   • ...

──── Priorities ────
  1. <highest impact/effort item, A before B>
  2. ...
```

End with: *"Report only — nothing was changed. Want me to apply any specific item? Tell me which, and I'll do it as a normal edit you can review."*

## Safeguards

- **Read-only / propose-only**: no Edit/Write/commit, ever. You propose; the user applies.
- **Part A is authoritative; Part B is suggestions.** Never let B's uncertainty bleed into A.
- **No proposal without quoted evidence** (Part B). No-evidence → 🔵 question.
- **Network is best-effort**: a failed fetch degrades to Part A, never to guessing.
- **Never expose secrets** (`.env*`, tokens, keys) in the report.
- If scope is huge, audit `.claude/` + the active kit-methode plugin first, and say what you skipped.
