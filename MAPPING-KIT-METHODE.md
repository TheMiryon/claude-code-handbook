# Mapping du kit-méthode — cartographie cross-projets

> **But** : isoler ce qui est *générique* (réutilisable partout, candidat plugin) de ce qui est *overlay par projet*, à partir de l'observation réelle de 3 setups `.claude/` + l'état actuel du handbook. Sert de base au futur **plugin Claude Code** + au bootstrap d'un nouveau projet.
>
> **Date** : 2026-06-10
> **Sources** (inventaires lecture-seule) :
> - `Trading - wizard extension` — JS pur / `.mjs`, extension Manifest V3, Kraken (réf. squelette)
> - `Spirit of Nyx` — Phaser 3 + TypeScript + Vite, jeu 2D
> - `pivola` — Next.js 16 + TypeScript + Supabase, pnpm, SaaS (le plus mature)
> - `claude-code-handbook-v1` — état actuel du repo (futur foyer du kit)

## Légende des verdicts

| Symbole | Sens | Destination |
|---|---|---|
| 🟢 **Générique** | Contenu agnostique, voyage tel quel | **Plugin** |
| 🟡 **Mécanisme générique / contenu spécifique** | La forme se réutilise, le contenu est par-projet | **Plugin = template** + overlay par projet |
| 🔴 **Overlay** | Spécifique au projet (et, pour `rules/`, techniquement non-distribuable via plugin) | **Reste par projet** |

---

## État actuel du handbook-v1 (point de départ)

Le handbook est **déjà ~85 % le kit générique** : hooks/agents/commands templés, dossier `templates/`, placeholders propres (`<Project name>`, `<verify command>`…), skill `conventional-commits`. Il pratique sa propre méthode (son `.claude/` = miroir de `templates/`).

**Ce n'est pas encore un plugin** : pas de `.claude-plugin/plugin.json` ni `marketplace.json`.

**Manques par rapport au noyau observé sur les 3 projets :**
- Hooks : `inject-contract.sh`, `stop-test-gate.sh` absents
- Commands : `retro.md`, `audit-claude-setup.md`, `standup.md` absents (note : `standup` présent ; à vérifier)
- Docs templates : `STACK.md`, `CONVENTIONS.md`, `WORKFLOW.md`, `OPERATING-CONTRACT.md` absents (seuls `CLAUDE.md`, `COMMANDS.md`, `PATTERNS.md`, `agent-memory/README.md` présents)

---

## 1. Hooks

| Hook | Trading | Nyx | Pivola | handbook | Verdict |
|---|---|---|---|---|---|
| `session-start.sh` | ✓ | ✓ | ✓ (enrichi : news/errors/méta-audit) | ✓ | 🟡 *(récap git générique ; lit des chemins projet)* |
| `inject-contract.sh` | ✓ | ✓ | ✓ | ✗ | 🟡 *(mécanisme 🟢 ↔ `OPERATING-CONTRACT.md` 🔴)* |
| `pre-tool-guard.sh` | ✓ | ✓ | ✓ | ✓ | 🟢 *(bloque `.env`, `rm -rf`, `--force`, `--no-verify`)* |
| `post-edit-format.sh` | ✓ | ✓ | ✓ (`pnpm exec`) | ✓ | 🟡 *(à templater : gestionnaire de paquets / formateur)* |
| `stop-test-gate.sh` | ✓ (`npm test`) | ✓ (`pnpm`) | ✓ (cible `calculations/`) | ✗ | 🟡 *(à templater : commande de test + cibles)* |
| `activity-log.sh` | ✓ | ✓ | ✓ | ✓ | 🟢 |
| `prompt-log.sh` | ✓ | ✓ | ✓ | ✗ (?) | 🟢 |
| `coach-suggest.sh` | ✓ | ✓ | ✓ | ✓ | 🟡 *(logique 🟢 ↔ triggers ajustés par projet)* |
| `extract-lesson.sh` | — | ✓ | — | ✓ | 🟢 *(à généraliser au noyau)* |

**Bilan** : 8–9 hooks, ossature quasi identique partout. 4 sont des 🟡 dont le seul contenu spécifique = **commande de test / gestionnaire de paquets / chemins projet** → un fichier `kit.config` (variables) réglerait l'essentiel.

---

## 2. Agents

| Agent | Trading | Nyx | Pivola | handbook | Verdict |
|---|---|---|---|---|---|
| `plan-reviewer` | ✓ | ✓ | ✓ | ✓ | 🟢 **100 % générique partout** |
| `code-auditor` | ✓ | ✓ | ✓ | ✓ | 🟡 *(squelette 🟢 ↔ contexte stack : core/fetch · Phaser/RNG/fixed-point · TS strict/Supabase)* |
| `security-auditor` | ✓ (dormant) | ✓ (dormant) | ✓ (RGPD/Supabase actif) | ✓ | 🟡 *(structure 🟢 ↔ checklist domaine)* |
| `agents/README.md` | ✓ | ✗ | ✓ | ✓ | 🟢 |
| **Agent(s) domaine** | `trading-domain-expert` | `game-balance-analyst` + `directeur-monde` | `trading-domain-expert` **+ 16** | — | 🔴 **Overlay pur** |

**Divergence majeure = l'agent domaine :**
- Trading : 1 axe (formules indicateurs / règles / risque).
- Nyx : **2 axes** (équilibrage combat *vs* direction monde/art) → 2 agents pour éviter la pollution de contexte.
- Pivola : **explosion** (trading + ethics/RGPD, a11y, design-reviewer, db-schema, perf, qa, i18n, release-notes, + 5 marketing/launch en hibernation, + tech-watch/error-watch).

→ Le plugin fournit les **3 agents de base** + un **template d'agent domaine** ; chaque projet greffe le(s) sien(s).

---

## 3. Commands

| Command | Trading | Nyx | Pivola | handbook | Verdict |
|---|---|---|---|---|---|
| `ship`, `new-feature`, `audit-quick`, `coach`, `coach-mute`, `coach-on`, `extract-lesson`, `retro` | ✓ | ✓ | ✓ | ✓ (sauf `retro`) | 🟢 |
| `audit-claude-setup` | ✓ | ✓ | ✓ | ✗ | 🟢 *(à ajouter au handbook ; + futur scan externe)* |
| `standup` | ✓ | ✗ | ✓ | ✓ | 🟢 |
| `trading-check` (commande domaine) | ✓ | ✗ | ✓ | — | 🔴 *(template `domain-check`)* |
| Wrappers domaine Pivola : `widget`, `loro`, `news`, `errors`, `release`, `check-dod` | — | — | ✓ | — | 🔴 |

**Bilan** : ~10 commands 🟢 forment le cœur stable. Les commandes domaine sont des wrappers fins autour d'un agent → **template `domain-check`**.

---

## 4. Rules (path-scoped) — 🔴 et non-distribuables via plugin

| Projet | Fichiers `rules/` | `paths:` |
|---|---|---|
| Trading | `core` · `strategies` · `extension` | `indicator-engine*`, `core/**` · schéma stratégie · `*.jsx`, `manifest*` |
| Nyx | `engine` · `data` · `scenes` | `src/engine/**` · `src/data/**` · `src/scenes/**`, `src/ui/**` |
| Pivola | `widgets` · `calculations` · `migrations` | `src/components/dashboard/widgets/**` · `src/lib/calculations/**` · migrations DB |

**Constat clé** : **même pattern** (frontmatter `paths:` + 3 sections), **contenu 0 % partageable**, et **techniquement hors plugin** (une règle path-scoped a besoin du contexte du projet cible). → Le plugin fournit **le pattern + un fichier d'exemple commenté** ; le contenu est posé par le bootstrap, par projet.

---

## 5. Config & docs

| Fichier | Trading | Nyx | Pivola | handbook | Verdict |
|---|---|---|---|---|---|
| `CLAUDE.md` (hub) | ✓ | ✓ | ✓ | ✓ (templé) | 🟡 *(structure hub 🟢 ↔ contenu)* |
| `STACK.md` | ✓ | ✗ (fondu dans CLAUDE) | ✓ | ✗ | 🟡 |
| `CONVENTIONS.md` | ✓ | ✓ | ✓ | ✗ | 🟡 |
| `WORKFLOW.md` | ✓ | ✓ | ✓ | ✗ | 🟡 |
| `OPERATING-CONTRACT.md` | ✓ | ✓ | ✓ | ✗ | 🟡 **(voir §7)** |
| `COMMANDS.md` | ✓ | ✓ | ✓ | ✓ | 🟡 *(table décision 🟢 ↔ combos par projet)* |
| `PATTERNS.md` | ✓ | ✓ (vide) | ✓ | ✓ (templé) | 🟡 *(recettes par stack)* |
| `settings.json` | ✓ | ✓ | ✓ | ✓ | 🟡 *(câblage hooks 🟢 ↔ permissions/outils par projet)* |
| `agent-memory/README.md` | ✓ (pattern) | ✓ (pattern) | ✓ **(actif)** | ✓ | 🟢 *(pattern)* |

---

## 6. L'OPERATING-CONTRACT — la pièce centrale, à scinder proprement

Structure identique partout (réinjecté chaque tour). Ligne de partage observée :

| Règle | Verdict |
|---|---|
| 1. Mode CO-PILOTE (proposer/expliquer, attendre le go) | 🟢 |
| 2. Confidence card `🎯 X% · Trou:` + `⚠️ TROU` | 🟢 |
| 3. Statut explicite : codé ≠ testé ≠ vérifié en vrai | 🟢 |
| 4. Gates : chantier ≥ N fichiers → `/new-feature` ; push → `/ship` | 🟢 *(seuil divergent : Trading **≥3**, Pivola **≥5** → variable)* |
| 5. Contrarian par défaut, couper > ajouter, pas d'ajout réflexe | 🟢 |
| 6. Conventions dures (LONG/SHORT, purety core/, RLS, `Intl.NumberFormat`…) | 🔴 |
| 7. Sources de vérité (BRIEF/ROADMAP/DoD… par nom de fichier) | 🔴 |

→ **Règles 1-5 = template générique** (le cœur de ta discipline) ; **6-7 = overlay** rempli par projet.

---

## Synthèse — le noyau vs l'overlay

### 🟢 Noyau générique (→ plugin)
- **Hooks** : `pre-tool-guard`, `activity-log`, `prompt-log`, `extract-lesson` (purs) + `session-start`, `inject-contract`, `post-edit-format`, `stop-test-gate`, `coach-suggest` (mécanisme générique, paramétrés par `kit.config`)
- **Agents** : `plan-reviewer`, `code-auditor`, `security-auditor` (+ `README`)
- **Commands** : `ship`, `new-feature`, `audit-quick`, `coach`(+`mute`/`on`), `standup`, `extract-lesson`, `retro`, `audit-claude-setup`
- **Pattern** : `agent-memory/`
- **OPERATING-CONTRACT règles 1-5**, ossature CLAUDE.md/STACK/CONVENTIONS/WORKFLOW/COMMANDS/PATTERNS, structure `settings.json`

### 🔴 Overlay par projet (jamais dans le plugin)
- Agent(s) domaine + commande domaine (`*-check`)
- `rules/*` (paths + contenu)
- OPERATING-CONTRACT règles 6-7 (conventions dures + sources de vérité)
- `PROJECT_BRIEF`, docs métier, `settings.local.json`, logs

### 🟡 À templater (le vrai travail de design)
- `kit.config` : gestionnaire de paquets, commande de test/lint/format, cibles du test-gate, chemins surveillés par les hooks
- Templates de docs (CLAUDE.md hub, STACK/CONVENTIONS/WORKFLOW, OPERATING-CONTRACT) avec placeholders
- Templates `domain-agent` / `domain-check` / `rule` (frontmatter + 3 sections)

---

## Conséquences pour le packaging plugin

**Voyage dans le plugin** : skills, agents, commands, hooks, `settings.json` défaut, MCP/LSP.
**Ne voyage PAS** (reste par projet) : `rules/` path-scoped, `CLAUDE.md` projet, contenu de l'OPERATING-CONTRACT.

→ Architecture cible = **plugin générique** (installé via marketplace) **+ overlay mince** posé par un **bootstrap** (commande/script qui génère : `rules/` squelette, agent domaine, hub CLAUDE.md, BRIEF, `kit.config`).

---

## Prochaines étapes (à cadrer en `/new-feature` DANS le repo handbook)

1. **Packager le handbook en plugin + marketplace** (`.claude-plugin/plugin.json` versionné + `marketplace.json`).
2. **Combler les manques** : `inject-contract`, `stop-test-gate`, `retro`, `audit-claude-setup`, templates `STACK/CONVENTIONS/WORKFLOW/OPERATING-CONTRACT`, `agent-memory` au noyau.
3. **Introduire `kit.config`** pour absorber les 🟡 paramétrables (pnpm/npm, test, format, chemins).
4. **Bootstrap d'overlay** : commande qui pose le squelette par-projet (rules, agent domaine, hub, BRIEF).
5. **Étendre `/audit-claude-setup`** au **scan des sources externes** (doc Anthropic, changelog Claude Code, repos SDK) → diff proposé, jamais auto-mergé (décision : commande à la main d'abord ; Routine cloud plus tard).
6. **Mettre à jour le contenu du handbook** (v3) pour refléter plugins / `/loop` / Routines / nouveautés.

> **Hors scope de ce doc** : refaire le handbook lui-même. Ce mapping est la photo de départ ; le rebuild est un chantier `/new-feature` séparé.
