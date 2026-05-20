---
description: "Quick pre-release audit: code + security in parallel, synthesized report"
---

# /audit-quick — Quick audit before an important release

You will launch **2 sub-agents in parallel** to give a project health status in ~5 minutes, **without modifying any files**.

## Procedure

### 1. Launch these 2 agents simultaneously (same message, multiple tool calls)

**Agent #1 — `code-auditor`**:
> READ-ONLY code quality audit. Focus: dead code, duplication, excessive complexity,
> framework anti-patterns, unjustified `any` types, performance issues, inconsistencies.
> Short report (≤ 500 words) ranked by severity (🔴 / 🟠 / 🟡). Focus on the main source folder.

**Agent #2 — `security-auditor`**:
> READ-ONLY security audit. Focus: auth, secrets, injections, XSS, PII exposure,
> OWASP Top 10 essentials, basic GDPR compliance. Short report (≤ 500 words) ranked
> (🔴 / 🟠 / 🟡). Check server actions modified in the last 7 days
> (`git log --since='7 days ago' --name-only`).

### 2. When both finish

Present a **unified report** in 3 sections only:

#### 🔴 Blockers (must fix before next release)
- List 🔴 findings from both agents
- For each: file:line + one-sentence description + estimated effort

#### 🟠 Important (fix this week if possible)
- Same elements but 🟠

#### 🟢 OK
- Positive note: what's passing well

### 3. Recommended action

End with **one** recommendation: *"Top priority: [item]"* with the exact command to fix it if possible (e.g., *"Edit src/X.ts line Y"*).

## Safeguards

- No file modifications. If an agent suggests a fix, just mention it, don't apply it.
- If an agent takes > 5 minutes, interrupt it and continue with the other.
- Don't re-run this audit within 24h (overhead, trust the linter instead).
