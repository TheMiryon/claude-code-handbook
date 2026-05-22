# DEPLOY V2 — HTML + EPUB (drop PDF V2)

New plan: **distribute via beautiful HTML on GitHub Pages + EPUB download**. PDF V2 is dropped (V1 PDF stays available for archival). Total time: 20 minutes.

---

## 1. Install Pandoc (one-time, 2 min)

Download from <https://pandoc.org/installing.html> — pick the Windows MSI (~50 MB). Default install. Restart your terminal so `pandoc` is on the PATH.

Verify:
```powershell
pandoc --version
```

You should see "pandoc 3.x" or similar.

## 2. Drop the new files into your repo

Unzip the new pack into `C:\Users\rohmm\claude-code-handbook-v1` (your local clone). The pack contains:

```
prepare-for-epub.js     ← new
build-epub.ps1          ← new
index.html              ← new (root landing page)
DEPLOY-V2.md            ← this file
```

The `print.css`, `source-v2.html` files you already have stay as-is.

## 3. Build the EPUBs (1 min)

```powershell
cd C:\Users\rohmm\claude-code-handbook-v1
.\build-epub.ps1
```

You should see:
```
→ Step 1/2 : Rendering Mermaid diagrams inline...
  ✓ Wrote en/source-v2-rendered.html (XXX KB)
  ✓ Wrote fr/source-v2-rendered.html (XXX KB)

→ Step 2/2 : Building EPUBs via Pandoc...
  ✓ en/claude-code-handbook-v2.epub
  ✓ fr/le-code-du-claudeur-v2.epub
```

Open the EPUBs in any reader (Apple Books, Calibre, Edge can open them too) to verify they look good.

## 4. Make `en/` and `fr/` browseable as web pages

Rename `source-v2.html` → `index.html` in both folders. That way the GitHub Pages URL `themiryon.github.io/claude-code-handbook/en/` shows the EN handbook directly:

```powershell
Copy-Item en/source-v2.html en/index.html
Copy-Item fr/source-v2.html fr/index.html
```

(Copy, don't rename — we keep `source-v2.html` as the source of truth for future EPUB rebuilds.)

## 5. Enable GitHub Pages (5 min)

1. Push your work to a new branch:
   ```powershell
   git checkout -b v2-draft   # if not already on it
   git add -A
   git commit -m "feat(v2): release V2.0 — HTML + EPUB distribution"
   git push -u origin v2-draft
   ```

2. Create a PR `v2-draft → main` and merge (or push direct to main if you prefer).

3. On GitHub, go to **Settings → Pages**:
   - Source: **Deploy from a branch**
   - Branch: **main**, folder: **/ (root)**
   - Save

4. Wait ~60 seconds. Your site is live at:
   - `https://themiryon.github.io/claude-code-handbook/` ← landing
   - `https://themiryon.github.io/claude-code-handbook/en/` ← English handbook
   - `https://themiryon.github.io/claude-code-handbook/fr/` ← French handbook
   - `https://themiryon.github.io/claude-code-handbook/en/claude-code-handbook-v2.epub` ← EPUB download
   - `https://themiryon.github.io/claude-code-handbook/fr/le-code-du-claudeur-v2.epub` ← EPUB FR

## 6. Update the GitHub repo About section

Click ⚙️ next to "About" on the repo home page:

**Description (replace):**
```
The Claude Code handbook you actually finish. Bilingual (EN/FR), free. Hooks, sub-agents, skills, plan-first dev, audit loop. For developers and knowledge workers.
```

**Website URL:**
```
https://themiryon.github.io/claude-code-handbook/
```

**Topics — keep existing, add:**
- `skills`, `hooks`, `subagents`, `mcp`, `agentic-workflows`, `knowledge-worker`, `epub`

## 7. Create the V2 GitHub Release

Go to `Releases → Draft new release`:

- **Tag**: `v2.0.0`
- **Title**: `V2.0 — The handbook you actually finish`
- **Body**: paste the content from `CHANGELOG.diff.md` (the `## [V2.0]` section)
- **Attachments**: drag-drop the 2 EPUBs:
  - `en/claude-code-handbook-v2.epub`
  - `fr/le-code-du-claudeur-v2.epub`
- ☑️ Set as latest release
- **Publish release**

## 8. Update README

Replace the Downloads table in README.md with:

```markdown
## Read / Download

| | English | Français |
|---|---|---|
| **Read online** | [HTML](https://themiryon.github.io/claude-code-handbook/en/) | [HTML](https://themiryon.github.io/claude-code-handbook/fr/) |
| **V2 EPUB** (Kindle, iPad, etc.) | [Download](en/claude-code-handbook-v2.epub) | [Download](fr/le-code-du-claudeur-v2.epub) |
| **V1 PDF** (archived) | [Download](en/claude-code-handbook-v1.pdf) | [Download](fr/le-code-du-claudeur-v1.pdf) |
```

Note: no V2 PDF. The HTML version IS the canonical V2 format. If users want PDF, they can use their browser's "Print to PDF" from the web version — it works well.

---

## Why this is better than chasing PDF perfection

- **HTML reflows naturally** on any screen size. No "page break in wrong place" possible.
- **EPUB also reflows**. The user adjusts font size, dark mode, etc. in their reader.
- **Both are accessible**: screen readers, copy-paste, search, mobile friendly.
- **Modern dev handbooks live on the web** (React docs, Anthropic docs, Rust book). PDF is for archives.
- **You stop iterating on print CSS forever**. Done.

The HTML + EPUB combo covers 99% of reader needs. The 1% who insist on PDF can print from browser.
