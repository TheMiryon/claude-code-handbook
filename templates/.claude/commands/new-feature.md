---
description: "Orchestrated pipeline for a sizeable change: plan → plan-review → code → verify → audits"
argument-hint: "<short description of the feature>"
---

# /new-feature — Guided pipeline

5 steps with **explicit user checkpoints** between each. The point: avoid the "I'll do everything in one go" trap. Force plan validation before code, then chain the right audits based on what was touched.

Use this when the change touches **≥ 3 files**, OR a critical module (auth, payments, calculations), OR a database migration, OR a cross-cutting feature. For a one-file fix, use direct Edit.

## Procedure

### Step 0 — Capture scope

`$ARGUMENTS` = one-line description of the feature. If empty or < 10 characters, ask:

> *"Describe the feature in 1-2 sentences: what we're building, who the end user is, and the motivation. If you're unsure about scope, tell me — we'll list it before planning."*

Reformulate in 2 lines max and **wait for explicit confirmation** before step 1.

### Step 1 — Plan (you, no sub-agent yet)

Write `PLAN_<slug>.md` at repo root with **exactly** this structure:

```markdown
# Plan — <Readable title>

## Scope
- One sentence: what will be delivered.
- Out of scope: what we are NOT doing in this chantier.

## Files to create / modify
- `path/to/file.ext` — create / modify — role
- ...

## Dependencies between files
1. Step A must precede B because ...
2. ...

## Known risks
- Risk 1 + mitigation
- Risk 2 + mitigation
(Always include: auth/security, type safety, data integrity, framework breaking changes if relevant)

## User checkpoint (✋)
- Decisions to validate before coding: [list]
- Variants: [if applicable]
```

Then tell the user:
> *"Plan written to `PLAN_<slug>.md`. Before asking your go, I'll have `plan-reviewer` (staff engineer) review it — 30 seconds to challenge scope, alternatives, risks."*

### Step 1.5 — Plan review (`plan-reviewer` sub-agent)

Invoke the `plan-reviewer` agent with this brief:

> *"Review `PLAN_<slug>.md` at repo root and produce a structured verdict (Strengths / Points to challenge / Open questions / Simpler alternative / Verdict 🟢/🟡/🔴). Confidence ≥ 80% required before marking a point 🟠 or 🔴."*

When the report comes back, show it to the user **in full** (it's short — don't summarize), then:

- **🟢 GO** → *"Verdict 🟢 GO. I move to implementation, or you want to adjust first?"*
- **🟡 GO with adjustments** → patch `PLAN_<slug>.md` with the suggested adjustments (or ask the user to decide for UX/product calls), then re-checkpoint: *"Plan patched. Go?"*
- **🔴 STOP** → *"Verdict 🔴 STOP. I propose we re-examine [point] before coding. Your options: (a) re-do the plan, (b) override (tell me why the reviewer is wrong), (c) abandon this chantier."*

**Write no code until the user gives an explicit "go"**, even if the verdict is 🟢.

### Step 2 — Implementation (you, sequential)

Implement file by file **in the dependency order from the plan**. After each file:
- Run your verify command if the file can break the typecheck (server logic especially)
- If red → fix before moving on. NEVER stack errors.

At mid-point (≥ 50% of plan files touched), checkpoint with the user:
> *"Mid-plan: [X files done, Y remaining]. Continue or pause to review?"*

### Step 3 — Final verify

Run your verify command. If red → STOP, show errors, **don't run audits**.

### Step 4 — Targeted audits (sub-agents in parallel)

Based on what was touched, invoke **in parallel** (one message, multiple tool calls):

| Touched | Agent to invoke |
|---|---|
| Always | `qa-tester` (end-to-end integrity) |
| Server action / API route / auth | `security-auditor` |
| Migration / new table | `db-schema-reviewer` |
| UI component | `design-reviewer` |
| Domain calculation | `<domain>-expert` |
| Big page / heavy component | `performance-profiler` |
| > 200 lines changed total | `code-auditor` |

Brief each agent with: *"Read-only audit of feature `<slug>` whose plan is in `PLAN_<slug>.md`. Focus on files changed since last commit (`git diff --name-only HEAD`). Report ≤ 400 words, ranked 🔴 / 🟠 / 🟢."*

### Step 5 — Synthesis + next action

```
═══ /new-feature: <slug> ═══

✅ Plan       : PLAN_<slug>.md
✅ Plan review: 🟢 GO (or as patched)
✅ Code       : N file(s) created, M modified
✅ Verify     : green
🟢/🟠/🔴 Audits:
  • qa-tester        : [one-line summary]
  • security-auditor : [one-line summary]
  • ...

🔴 Findings to fix before ship:
  - [item 1]

Recommended next:
  → /ship "feat(<scope>): <description>"
  or: fix the 🔴 above first
```

End with:
> *"I `/ship` directly (if no 🔴), I fix first, or you want to read the diff yourself?"*

## Guardrails

- **Never** skip the checkpoint after step 1.5 (plan-review). The cost of a bad coded plan is 10× the cost of a reviewed plan.
- **Never** run audits if verify is red — token waste.
- **Never** invoke 4+ audit agents simultaneously. Pick 2–3 max based on scope.
- If the user says "stop" at any checkpoint, **stop immediately**. Don't push.
- If, at step 2, you realize the plan is wrong: go back to step 1, **don't patch in flight**. Re-write the plan, re-checkpoint, restart.
- **Do not delete** `PLAN_<slug>.md` at the end — it's useful documentation for the commit and any future review.
