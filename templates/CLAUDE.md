# <Project name>

One-sentence description of what the app does.

## Tech stack
- Language: <Python 3.12 | TypeScript 5 | Go 1.22 | Rust 1.80 | ...>
- Framework: <Next.js 16 | FastAPI | Rails | Phoenix | ...>
- DB: <Postgres via Supabase | SQLite | MongoDB | ...>
- Tests: <pytest | vitest | jest | go test>
- Deployment: <Vercel | Fly.io | Railway | self-hosted>

## Useful commands
- `<dev command>` — start the local server
- `<verify command>` — type-check before push (the thing that blocks the build)
- `<test command>` — run the test suite
- `<build command>` — production build (what the deploy provider runs)

## Conventions
- <Naming rule, e.g. camelCase JS, kebab-case files, PascalCase components>
- <Structure rule, e.g. every page has its own `actions.ts`>
- <Behavior rule, e.g. never `alert()`, always toast via Sonner>
- <Type rule, e.g. `any` allowed only in chart formatter callbacks>

## Gotchas
- <Known stack pitfall, e.g. Next.js 16 changed `revalidate` config (breaking from 15)>
- <Internal project pitfall>

## Git workflow
- Target branch: `<master | main>`
- Commit format: `type(scope): description` (Conventional Commits)
- <PR or direct push policy>
- Deploy: `<auto from master | manual>`

## Hard rules (impératives)
- **Never** modify production data without explicit confirmation
- **Always** run `<verify>` before push (typecheck is what blocks the build)
- **Never** commit secrets to git — use the deploy provider's env vars

## When to use which agent (if you have .claude/agents/)
- Before a public deployment → `security-auditor`
- Before a large refactor → `code-auditor`
- After a multi-file change → `qa-tester` (if you have one)

## Slash commands (if you have .claude/commands/)
- `/ship "<msg>"` — verify + commit + push in one line
- `/audit-quick` — code + security audit in parallel
- `/standup` — morning recap

## Coach mode — when to propose what

Triggers I honor before acting. If a condition is true, propose
the command rather than just running.

| Observed trigger | Action to propose |
|---|---|
| Task touches ≥ 5 files or new transversal feature | `/new-feature <slug>` (if defined) |
| Before any `git push` | `/ship "<message>"` |
| ≥ 10 files modified since last commit | `/audit-quick` before ship |
| Server action / auth route modified | `security-auditor` agent before push |
| DB migration | `db-schema-reviewer` agent before push |

**General rule**: if a command covers ~80 % of what was about to be
done manually, propose first. The user can always reply "no, do it
manually" — that's fine.

## Pre-deployment checklist
1. `<verify command>` green
2. `/audit-quick` clean (no 🔴 findings)
3. Tests pass
4. <Other gates: Sentry, observability, backups>
