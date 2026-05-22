# DEPLOY.md — From this draft to V2 live on GitHub

Step-by-step checklist for shipping V2. Estimated time: **45 minutes** (15 of file ops + 15 of build + 15 of GitHub UI).

---

## 1. Copy the V2 files into your local handbook clone

You currently have all V2 artifacts in `/home/user/handbook-v2/` (in this remote session). You need to copy them into your **local clone of `claude-code-handbook`** on your computer.

### 1.a — Get the files onto your computer

**Option A: Direct download (recommended for this session)**

Use the chat UI's file download feature, or copy each file by selecting and pasting from the Claude Desktop view. The files you need:

```
handbook-v2/
├── BUILD.md
├── CHANGELOG.diff.md
├── README.diff.md
├── DEPLOY.md                                      (this file)
├── assets/css/print.css
├── en/source-v2.html
├── fr/source-v2.html
└── templates/
    ├── .agents/skills/conventional-commits/
    │   ├── SKILL.md
    │   └── references/
    │       ├── _sections.md
    │       ├── _template.md
    │       ├── _contributing.md
    │       ├── format-type-required.md
    │       ├── format-scope-optional.md
    │       ├── format-description-imperative.md
    │       └── breaking-change-marker.md
    └── .claude/
        ├── agents/plan-reviewer.md
        ├── commands/extract-lesson.md
        ├── commands/new-feature.md
        └── hooks/extract-lesson.sh
```

### 1.b — Drop them into your local repo

In a terminal **on your computer**, in your local `claude-code-handbook` clone:

```bash
# 1. Create a working branch
git checkout -b v2-draft

# 2. Copy the new files (adapt the source path to where you saved them)
mkdir -p assets/css
cp ~/Downloads/handbook-v2/assets/css/print.css   assets/css/print.css
cp ~/Downloads/handbook-v2/en/source-v2.html      en/source-v2.html
cp ~/Downloads/handbook-v2/fr/source-v2.html      fr/source-v2.html
cp ~/Downloads/handbook-v2/BUILD.md               BUILD.md
cp ~/Downloads/handbook-v2/DEPLOY.md              DEPLOY.md     # optional, can delete after

# 3. Copy the new templates (additive — don't overwrite existing)
mkdir -p templates/.agents/skills/conventional-commits/references
cp ~/Downloads/handbook-v2/templates/.agents/skills/conventional-commits/SKILL.md \
   templates/.agents/skills/conventional-commits/SKILL.md
cp ~/Downloads/handbook-v2/templates/.agents/skills/conventional-commits/references/* \
   templates/.agents/skills/conventional-commits/references/

cp ~/Downloads/handbook-v2/templates/.claude/agents/plan-reviewer.md \
   templates/.claude/agents/plan-reviewer.md
cp ~/Downloads/handbook-v2/templates/.claude/commands/extract-lesson.md \
   templates/.claude/commands/extract-lesson.md
cp ~/Downloads/handbook-v2/templates/.claude/commands/new-feature.md \
   templates/.claude/commands/new-feature.md
cp ~/Downloads/handbook-v2/templates/.claude/hooks/extract-lesson.sh \
   templates/.claude/hooks/extract-lesson.sh
chmod +x templates/.claude/hooks/extract-lesson.sh

# 4. Verify everything's in place
git status
```

You should see ~16 new files. If anything's missing, double-check the source folder.

---

## 2. Apply the README and CHANGELOG diffs

### 2.a — README.md

Open `README.md` in your editor. Replace the entire content with the block in `README.diff.md` (the one I generated earlier). Or, if you prefer to keep some V1 sections:

- Replace the **first paragraph** with V2's description
- Replace the **"Features delivered" / "Quick Start" sections** with V2's content
- Add the **"What's new in V2"** section
- Update the **Downloads table** with V1 and V2 links
- Keep the **License** line at the bottom

### 2.b — CHANGELOG.md

Open `CHANGELOG.md`. The new `## [V2.0]` block from `CHANGELOG.diff.md` goes **right after the introduction line** and **above the `## [V1.0]` block**. Replace today's date placeholder `YYYY-MM-DD` with the actual release date.

---

## 3. Build the PDFs locally

In a terminal in your repo root:

```bash
# Install Paged.js CLI globally (one-time)
npm install -g pagedjs-cli

# Build both PDFs
pagedjs-cli en/source-v2.html -o en/claude-code-handbook-v2.pdf
pagedjs-cli fr/source-v2.html -o fr/le-code-du-claudeur-v2.pdf
```

This takes ~30-60 seconds per file. Output: two PDFs in the same folders as the V1 PDFs (which you keep alongside).

**Verify the output:**
- Open both PDFs.
- Check page count is ~50-55 (acceptable range; exact number depends on font rendering).
- Spot-check: are the Mermaid diagrams visible? Are code blocks not cut across pages?
- If a code block is split, see BUILD.md → "Troubleshooting".

---

## 4. Commit and push the V2 branch

```bash
git add -A
git status   # quick sanity check

git commit -m "feat(v2): release V2.0 — 52 pages, 5 parts, new skills/plan-first/audit-loop chapters

Major restructure inspired by Boris Cherny's workflow and the Anthropic
skill folder pattern. Adds dedicated chapters on skills (06), plan-first
development (07), audit loop (08), parallel worktrees (10), memory
matrix (11). Adds 'Who this is for' page, 'How to read' guide, glossary,
cheat sheet, two anonymized case studies. All TL;DR boxes, 4 Mermaid
diagrams, generic non-domain-specific examples throughout.

Templates added: plan-reviewer agent, /extract-lesson hook + command,
/new-feature pipeline, conventional-commits skill (full example with
4 rules + scaffolding).

EN and FR fully translated. Print CSS rewritten for strict page-break
discipline."

git push -u origin v2-draft
```

---

## 5. Create the GitHub Pull Request (optional but recommended)

On GitHub, open `https://github.com/TheMiryon/claude-code-handbook/compare/main...v2-draft` and create a PR with:

- **Title**: `V2.0 — 52 pages, 5 parts, new skills/plan-first/audit-loop chapters`
- **Body**: paste the content of `CHANGELOG.diff.md` (the `## [V2.0]` section)

You can self-merge it after a quick review. Or push directly to `main` if you prefer (you're the only maintainer). The PR is mainly useful as a public diff people can browse.

---

## 6. Update the GitHub repo settings

This is what the user asked about. Do these in the GitHub UI at `https://github.com/TheMiryon/claude-code-handbook`.

### 6.a — Repo "About" section (top right of the page)

Click the ⚙️ next to "About". Update:

**New description** (replace the current one):

```
The Claude Code handbook you actually finish. 52 pages, bilingual (EN/FR), free. Hooks, sub-agents, skills, plan-first dev, audit loop. For developers and knowledge workers.
```

(Limit: 350 chars. Above is ~210 chars, safe.)

**Website URL**: leave empty unless you have a landing page. If you set up GitHub Pages later (`en/index.html` and `fr/index.html`), set it to `https://themiryon.github.io/claude-code-handbook/`.

**Topics** (add to existing — they look fine but add these for V2 discoverability):

Existing (keep):
- `productivity`
- `tutorial`
- `developer-tools`
- `bilingual`
- `anthropic`
- `claude-ai`
- `ai-coding`
- `claude-code`

Add (new):
- `skills`
- `hooks`
- `subagents`
- `mcp`
- `agentic-workflows`
- `knowledge-worker`
- `pdf-guide`

You can have up to 20 topics. Currently 8, adding 7 → 15. Plenty of room.

**Settings checkboxes** (right side of About panel):
- ✅ **Releases** — should already be ticked
- ✅ **Packages** — leave off unless you publish to npm/etc
- ✅ **Deployments** — only useful if you set up GitHub Pages

### 6.b — Create the V2 GitHub Release

Go to `https://github.com/TheMiryon/claude-code-handbook/releases/new`.

**Tag**: `v2.0.0` (creates from `main` after you merge V2)

**Release title**:
```
V2.0 — The handbook you actually finish
```

**Release notes** (paste this body):

```markdown
The Claude Code handbook gets a major rewrite. 52 pages, 5 parts, bilingual EN/FR.

## What's new in V2

- **Chapter 06 — Skills (the right way)**. Full coverage of the Anthropic-style `.agents/skills/<name>/` pattern. Wiring to agents. Anti-patterns (orphan skills, prompt duplication). With a Mermaid diagram of the wiring.
- **Chapter 07 — Plan-first development**. The `/new-feature` pipeline with a `plan-reviewer` sub-agent acting as staff engineer at step 1.5, inspired by Boris Cherny. Mermaid diagram of the full pipeline.
- **Chapter 08 — The audit loop**. The `extract-lesson` hook + slash command. Pin lessons to `CLAUDE.md` (versioned) instead of local-only memory. Mermaid diagram of the loop.
- **Chapter 10 — Parallel worktrees**. The Boris Cherny pattern for running multiple Claude sessions in parallel via `git worktree`.
- **Chapter 11 — The memory matrix**. Explicit decision rules for the 4 memory locations (`CLAUDE.md` / skills / agent-memory / `~/.claude/projects`). Decision tree diagram.

## Restructure for clarity

- 5 parts (Foundations / Baseline setup / Specialized configuration / Advanced workflow / Going further)
- "For who / not for who" page right after the foreword — extends the audience to **knowledge workers**, not just developers
- "How to read" guide with 3 reading paths and difficulty badges (Beginner / Intermediate / Advanced)
- TL;DR boxes at the start of every new chapter
- Stricter print discipline — code blocks and tables never split mid-page

## New annexes

- **Annex F** — Glossary (15+ terms)
- **Annex H** — Two anonymized case studies (a solo dev over 6 months, a knowledge worker over 3 months)
- **Annex I** — 2-page foldable cheat sheet

## New templates (in `templates/`)

- `plan-reviewer.md` — the staff-engineer sub-agent
- `extract-lesson.sh` — the audit-loop hook
- `extract-lesson.md` — the slash command that pins lessons
- `new-feature.md` — the full pipeline
- `conventional-commits/` — full example skill with 4 rules + scaffolding (`_sections`, `_template`, `_contributing`)

## Tagline

> The handbook you actually finish. 52 pages. Free. Works for developers and knowledge workers.

## Downloads

| | English | Français |
|---|---|---|
| **V2** (latest) | `en/claude-code-handbook-v2.pdf` | `fr/le-code-du-claudeur-v2.pdf` |
| V1 (kept for download) | `en/claude-code-handbook-v1.pdf` | `fr/le-code-du-claudeur-v1.pdf` |

## Credits & inspiration

- Anthropic's official Claude Code documentation
- Boris Cherny's public talks on his Claude Code workflow at Anthropic
- The Anthropic Skills repository pattern (`.agents/skills/<name>/SKILL.md`)
- Feedback from real-world usage on a TypeScript SaaS production project (anonymized — see Annex H)
```

**Attachments**: drag-drop the two new PDFs (`en/claude-code-handbook-v2.pdf` and `fr/le-code-du-claudeur-v2.pdf`) into the asset zone. GitHub will host them at predictable URLs you can link to from the README.

**☑️ Set as latest release**

**☑️ Create a discussion for this release** (optional — useful if you want feedback from readers)

Click **Publish release**.

### 6.c — Pin the V2 release

On the repo home page, click the ⚙️ next to "Releases" in the right sidebar → check "Pin this release" on V2.0 → save. This makes V2 visible as the "latest" badge on the home page.

---

## 7. (Optional) GitHub Pages for the web version

If you want `en/index.html` and `fr/index.html` to render as live web pages:

1. Settings → Pages → Source: "Deploy from a branch"
2. Branch: `main`, folder: `/` (root)
3. Save
4. Copy the source HTMLs to index.html names:
   ```bash
   cp en/source-v2.html en/index.html
   cp fr/source-v2.html fr/index.html
   git add en/index.html fr/index.html
   git commit -m "docs: web version of V2 via GitHub Pages"
   git push
   ```
5. Wait ~1 minute. The web version is live at:
   - `https://themiryon.github.io/claude-code-handbook/en/`
   - `https://themiryon.github.io/claude-code-handbook/fr/`
6. Update the repo About → Website URL to the EN URL.
7. Add a row in the README's Downloads table for the web version.

---

## 8. Announcement (optional)

If you want to share V2 publicly, here are draft posts:

### Twitter / X

```
Claude Code Handbook V2 is out.

52 pages, bilingual (EN/FR), free.
The handbook you actually finish.

New: dedicated chapters on skills, plan-first dev (staff-engineer review at step 1.5), audit loops, parallel worktrees, the 4-locations memory matrix. Works for devs AND knowledge workers.

→ github.com/TheMiryon/claude-code-handbook
```

### LinkedIn

```
The Claude Code Handbook V2 just shipped. 

After six months of using Claude Code in production on a real solo dev project, I rewrote the handbook from scratch. V2 is 52 pages, bilingual EN/FR, completely free.

What's different from V1 and from the other Claude Code guides out there:

→ A dedicated chapter on Skills — the third primitive of Claude Code, often glossed over
→ Plan-first development with a "staff engineer" reviewer agent — inspired by Boris Cherny
→ An audit loop that pins lessons in Git instead of local memories
→ The memory matrix — clear rules for where to store what (4 locations, not 1)
→ A "Who this is for" page that explicitly extends the audience to knowledge workers, not just developers

And probably my favorite — a strict print design where code blocks and tables never split across pages, with Mermaid diagrams baked in. The handbook you actually finish reading.

PDF + web, EN + FR, all free under MIT.

github.com/TheMiryon/claude-code-handbook
```

### Reddit / r/ClaudeAI (or similar)

```
Title: I rewrote my Claude Code handbook — V2 (52 pages, EN+FR, free)

Body: V1 was 33 pages and missed some of the more recent practices (Boris Cherny's plan-first workflow, the official skill folder pattern, parallel worktrees, the memory matrix).

V2 fixes that. Same MIT license, same free PDFs, but with:
- Dedicated chapters on Skills, Plan-first dev, Audit loops, Worktrees, Memory matrix
- A "Who this is for" page that opens the audience to non-devs (knowledge workers, writers, researchers using Claude Code)
- Two anonymized case studies — one solo SaaS dev (6 months), one knowledge worker (3 months)
- A 2-page cheat sheet annex
- 4 Mermaid diagrams baked into the chapters
- Strict print discipline — no orphan headings, no cut code blocks

GitHub: https://github.com/TheMiryon/claude-code-handbook

Templates folder has the new plan-reviewer agent, extract-lesson hook+command, and a full example skill (conventional-commits) with 4 rules.

Constructive criticism welcome.
```

---

## Checklist (print or copy somewhere)

- [ ] Copy V2 files into local repo on a `v2-draft` branch
- [ ] Apply `README.diff.md` to `README.md`
- [ ] Apply `CHANGELOG.diff.md` to `CHANGELOG.md`
- [ ] `npm install -g pagedjs-cli` (one-time)
- [ ] Build EN PDF: `pagedjs-cli en/source-v2.html -o en/claude-code-handbook-v2.pdf`
- [ ] Build FR PDF: `pagedjs-cli fr/source-v2.html -o fr/le-code-du-claudeur-v2.pdf`
- [ ] Spot-check both PDFs (page count, diagrams, code blocks intact)
- [ ] `git add -A && git commit -m "feat(v2): release V2.0..."` (full message in §4)
- [ ] `git push -u origin v2-draft`
- [ ] (optional) Create PR `v2-draft → main` and merge
- [ ] Update repo About → description (text in §6.a)
- [ ] Update repo About → topics (add the 7 new ones in §6.a)
- [ ] Create GitHub Release `v2.0.0` with notes from §6.b and PDF attachments
- [ ] Pin the V2 release
- [ ] (optional) GitHub Pages setup
- [ ] (optional) Tweet / LinkedIn / Reddit announcement
- [ ] Delete `DEPLOY.md` from the repo (or keep, your call)
