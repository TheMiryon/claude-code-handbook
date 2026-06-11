# Plan — Empaqueter le kit-méthode en plugin + marketplace Claude Code (fondation)

> Source de cadrage : `MAPPING-KIT-METHODE.md` § « Prochaines étapes », point **1** + portage.
> Spec vérifiée à la source (code.claude.com : Plugins / Plugin marketplaces / Plugins reference), pas de mémoire.

## Scope

- **Livrable** : un plugin Claude Code **installable et validé** (`claude plugin validate`), distribué via une marketplace hébergée dans **ce repo**. On porte dans le plugin les composants **déjà génériques** observés sur les 3 projets (3 agents, ~8 commands, hooks purs), avec le seul ajustement technique imposé par le format plugin (chemins `${CLAUDE_PLUGIN_ROOT}` / `${CLAUDE_PROJECT_DIR}`).
- **Out of scope (chantiers suivants, ne PAS faire ici)** :
  - `kit.config` et tout hook 🟡 qui en dépend → notamment `post-edit-format.sh` (hardcode `pnpm/eslint`) et `stop-test-gate.sh` (absent). **Exclus**.
  - Nouveau contenu : `inject-contract`, `retro`, `audit-claude-setup`, templates `STACK/CONVENTIONS/WORKFLOW/OPERATING-CONTRACT`. **Exclus** (point 2).
  - Bootstrap d'overlay (point 4), scan sources externes (point 5), rebuild handbook v3 (point 6). **Exclus**.
  - **Dé-duplication** `.claude/` (dogfood) ↔ `plugins/kit-methode/` (distribuable) : on **accepte une copie** pour la fondation ; le choix source-de-vérité (symlink / génération) est un suivi explicite, pas tranché ici.

## Files to create / modify

**Le plugin (`plugins/kit-methode/`)**
- `plugins/kit-methode/.claude-plugin/plugin.json` — *create* — manifeste (`name: kit-methode`, `version: 0.1.0`, `description`, `author`). `name` est le seul champ requis ; il devient le namespace (`/kit-methode:ship`).
- `plugins/kit-methode/agents/plan-reviewer.md` — *create (copie)* — 🟢 générique tel quel.
- `plugins/kit-methode/agents/code-auditor.md` — *create (copie)* — squelette 🟢 (contexte stack reste commenté/générique).
- `plugins/kit-methode/agents/security-auditor.md` — *create (copie)* — structure 🟢.
- `plugins/kit-methode/commands/{ship,new-feature,audit-quick,coach,coach-mute,coach-on,standup,extract-lesson}.md` — *create (copie)* — 8 commands 🟢. Format `commands/` (flat `.md`) = portage drop-in, zéro réécriture de structure.
- `plugins/kit-methode/hooks/hooks.json` — *create À NEUF* — câblage des hooks au format plugin, scripts référencés via `${CLAUDE_PLUGIN_ROOT}/scripts/…`. **Ne pas transcrire `settings.json`** : omettre l'entrée `post-edit-format` (PostToolUse `Edit|Write`) tout en gardant `activity-log` (async) sur ce même matcher.
- `plugins/kit-methode/scripts/{pre-tool-guard,activity-log,session-start,coach-suggest,extract-lesson}.sh` — *create (copie + patch chemins)* — 5 hooks purs/génériques. **Patch** : remplacer `cd "$(dirname "$0")/../.."` par `cd "${CLAUDE_PROJECT_DIR}"` et toute lecture `.claude/…` par `${CLAUDE_PROJECT_DIR}/.claude/…`.
- `plugins/kit-methode/README.md` — *create* — quoi/pourquoi + install (`/plugin marketplace add <repo>` → `/plugin install kit-methode@<marketplace>`). **Doit documenter les invocations namespacées explicites** (`/kit-methode:ship`, `/kit-methode:extract-lesson`, …) car les hooks émettent des chaînes `/…` nues qui seront fausses en projet consommateur (cf. R2).
- `plugins/kit-methode/CHANGELOG.md` — *create* — section `0.1.0`.

**La marketplace (racine repo)**
- `.claude-plugin/marketplace.json` — *create* — `name`, `owner.name`, `plugins: [{ name: kit-methode, source: "./plugins/kit-methode", description }]`.

**Hygiène repo**
- `.gitignore` — *modify (si besoin)* — ne rien exclure du plugin ; vérifier qu'aucun pattern existant n'avale `plugins/`.
- `MAPPING-KIT-METHODE.md` — *commit* (actuellement non commité ; il documente le cadrage).

**Non touché** : le `.claude/` existant du repo (le handbook continue de dogfooder sa config locale) ; le contenu du livre (`en/`, `fr/`, `index.html`).

**Notes confirmées (revue plan-reviewer)** :
- `prompt-log` est listé 🟢 dans le mapping mais **absent** du repo → rien à porter (omission décidée, pas silencieuse).
- `marketplace.json` `owner` = objet `{ name (requis), email (optionnel) }` — conforme à la spec vérifiée.

## Dependencies between files

1. `plugin.json` doit exister avant tout (sinon `validate` échoue : `name: Required`).
2. Les `scripts/*.sh` patchés doivent exister **avant** `hooks/hooks.json` (qui les référence via `${CLAUDE_PLUGIN_ROOT}`).
3. Le dossier `plugins/kit-methode/` doit être complet **avant** `marketplace.json` (dont la `source` pointe dessus).
4. `claude plugin validate ./plugins/kit-methode` puis `claude plugin validate .` (marketplace) **en dernier** — verify final.

## Known risks

- **R1 — Chemins des hooks (le plus critique).** Les plugins sont copiés dans un cache (`~/.claude/plugins/cache`) ; `cd "$(dirname "$0")/../.."` y pointerait sur le cache, pas le projet. *Mitigation* : tous les scripts portés utilisent `${CLAUDE_PROJECT_DIR}` pour le projet et `${CLAUDE_PLUGIN_ROOT}` pour les fichiers bundlés. Tester réellement (install dans un repo tiers) avant tag.
- **R2 — Namespacing.** Les skills deviennent `/kit-methode:ship` une fois installés ailleurs. Les renvois en clair `/ship`, `/audit-quick` dans les corps de commands/hooks resteront « nus » → légèrement faux en projet consommateur (corrects dans le handbook qui garde son `.claude/`). *Mitigation fondation* : on documente la limite dans le README ; réécriture des renvois = polish ultérieur (ou laisser, Claude résout par contexte).
- **R3 — Duplication / drift.** `.claude/` et `plugins/kit-methode/` divergeront. *Mitigation* : copie assumée pour la fondation + suivi explicite (symlink dé-référencé à la copie cache, ou génération mono-source) tracé dans le CHANGELOG / mapping.
- **R4 — Portabilité Windows/bash.** Hooks en `.sh` → nécessitent bash chez le consommateur (déjà une hypothèse du kit). *Mitigation* : noter le prérequis dans le README ; pas de réécriture PowerShell ici.
- **R5 — Marketplace par chemin relatif.** `source: "./plugins/kit-methode"` ne résout **que** si la marketplace est ajoutée via git (GitHub/URL git), pas via URL directe vers le `.json`. *Mitigation* : on héberge sur GitHub (déjà le cas) ; documenter l'ajout via `owner/repo`.
- **R6 — Données / sécurité.** Aucun secret, aucun appel réseau ajouté ; hooks read-only (git, logs locaux). `pre-tool-guard` conserve ses garde-fous (`.env`, `rm -rf`, `--force`, `--no-verify`).

## User checkpoint (✋)

Décisions à valider **avant** de coder :

1. **Nom du plugin & de la marketplace.** Proposé : plugin `kit-methode`, marketplace `kit-methode-marketplace` (ou un nom à toi). → invocation `/kit-methode:ship`. OK ou autre nom ?
2. **Format des commands** : `commands/` (flat `.md`, portage drop-in — **recommandé** pour la fondation) vs migration immédiate en `skills/<nom>/SKILL.md` (plus « moderne » mais réécriture). Recommandation : `commands/` maintenant, migration skills/ plus tard.
3. **Périmètre des hooks portés** : `pre-tool-guard`, `activity-log`, `session-start`, `coach-suggest`, `extract-lesson` (5 purs). `post-edit-format` **exclu** (non générique). Confirmer.
4. **Duplication assumée** : on copie dans le plugin sans toucher `.claude/`, dé-dup traitée plus tard. OK ?

Variante possible : inclure quand même `post-edit-format` en version no-op (formateur commenté) pour parité structurelle — non recommandé (faux signal).
