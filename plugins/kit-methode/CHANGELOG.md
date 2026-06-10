# Changelog — kit-methode

Format : [Keep a Changelog](https://keepachangelog.com/), versions [SemVer](https://semver.org/).

## [0.6.0] — 2026-06-10

### Added
- `commands/retro.md` : rétrospective arrière read-only sur une fenêtre (`7 days` / `since <sha>` / un `PLAN_*.md`) — ce qui a marché / a fait mal / surprises / max 3 actions process. Distincte de `/standup` (avant) et `/extract-lesson` (technique, dans CLAUDE.md).

## [0.5.0] — 2026-06-10

Commande `bootstrap` : pose l'overlay par-projet (core-only v1).

### Added
- `commands/bootstrap.md` : scaffolder **idempotent** de l'overlay. Algorithme write-safety explicite — énumère les cibles, teste l'existence, **affiche un aperçu**, demande confirmation, puis `Write` **uniquement les fichiers absents** (jamais `Edit`, jamais `cp`/`>`, jamais d'écrasement sans confirmation par fichier). Seule commande mutante du kit.
- Templates bundlés `templates/{rule.example,CLAUDE.hub,PROJECT_BRIEF}.md`.
- L'OPERATING-CONTRACT posé = `templates/operating-contract.md` lu **verbatim** (règles 1-5, pas de paraphrase) + bloc statique §6-7 placeholder.

### Scope
- core-only : pose OPERATING-CONTRACT + rules/example + CLAUDE.md hub + PROJECT_BRIEF. Templates `domain-agent`/`domain-check` différés à v0.6.0.

### Notes
- Templates sous `templates/` → non chargés comme composants du plugin.
- Une commande est un prompt : la write-safety repose sur l'algorithme inscrit + son respect par le modèle (pas de verrou sandbox) ; preuve runtime à l'exécution réelle.

## [0.4.0] — 2026-06-10

Réinjection de l'OPERATING-CONTRACT (la « pièce centrale » de la discipline).

### Added
- `scripts/inject-contract.sh` (hook `UserPromptSubmit`) : réinjecte l'OPERATING-CONTRACT à chaque tour via `hookSpecificOutput.additionalContext` (JSON construit avec `jq -Rs`). Dégrade en « rien émis » si jq absent / fichier illisible ou vide (jamais de JSON malformé).
- `templates/operating-contract.md` : règles génériques 1-5 (co-pilote, confidence card, statut explicite, gates, contrarian). Bundlé, injecté par défaut.
- `userConfig.inject_contract` (boolean, défaut `true`) : coupe la réinjection.

### Notes
- Overlay : si le projet a un `.claude/OPERATING-CONTRACT.md`, le hook l'injecte **à la place** du template bundlé (c'est là que vivent les règles 6-7 spécifiques au projet).
- Event `UserPromptSubmit` (chaque tour) choisi conformément au mapping ; sur resume l'additionalContext est rejoué depuis le transcript (pas de staleness pour un contrat statique).

## [0.3.0] — 2026-06-10

Commande d'auto-audit + enrichissement du setup Claude Code.

### Added
- `commands/audit-claude-setup.md` : commande **read-only, propose-only**. Partie A — audit local déterministe du `.claude/` + plugins actifs (cohérence hooks↔settings, frontmatter, anchors morts, dérive, duplication standalone↔plugin). Partie B — scan best-effort des sources Anthropic (changelog + doc cœur) confronté au setup, propositions avec **diff exact + preuve quotée obligatoire** (sinon question), jamais appliquées. `argument-hint` `[local | external | all]`.

### Notes
- Anti-hallucination : toute proposition externe doit citer une URL fetchée ET quoter la ligne qui la justifie ; pas de preuve → question, jamais proposition.
- Propose-only est une convention de prompt, pas un sandbox (un verrou dur relèverait des permissions).
- Pas de fetch du source SDK (high-noise) ; changelog + doc cœur uniquement.

## [0.2.0] — 2026-06-10

Paramétrage de la couche hooks par projet via `userConfig` natif (pas de fichier `kit.config` maison), + les deux hooks 🟡 absents de la fondation.

### Added
- `userConfig` dans `plugin.json` : `package_manager`, `test_cmd`, `test_paths`, `format_cmd`, `test_gate_block` (demandés à l'activation, exportés aux scripts comme `CLAUDE_PLUGIN_OPTION_*`).
- `scripts/kit-env.sh` : helper sourcé résolvant le gestionnaire de paquets (auto-détection lockfile + override) et les commandes test/format. Sûr sous `set -e`.
- `scripts/post-edit-format.sh` (PostToolUse `Edit|Write`) : formate le fichier écrit via `format_cmd`. No-op si non configuré (aucun formateur deviné), non-bloquant.
- `scripts/stop-test-gate.sh` (Stop) : lance les tests en fin de tour. Garde **≥1 écriture** inconditionnelle, filtre `test_paths` optionnel, **warn-only par défaut** (bloquant via `test_gate_block`), partage `coach-mute`.

### Notes
- `test_paths` est un champ `string` (séparé espaces/virgules), pas `multiple` : la sérialisation env d'un tableau `userConfig` n'est pas documentée.
- Le repo handbook n'ayant ni test ni formateur, les deux hooks restent no-op ici ; le chemin positif n'est prouvable qu'à l'install réelle dans un projet à stack.

## [0.1.0] — 2026-06-10

Première version : packaging du noyau générique en plugin Claude Code installable.

### Added
- Manifeste `.claude-plugin/plugin.json` + marketplace `.claude-plugin/marketplace.json` à la racine du repo.
- 3 agents : `plan-reviewer`, `code-auditor`, `security-auditor`.
- 8 commandes : `ship`, `new-feature`, `audit-quick`, `coach`, `coach-mute`, `coach-on`, `standup`, `extract-lesson`.
- 5 hooks (scripts bash) câblés via `hooks/hooks.json` : `session-start`, `pre-tool-guard`, `activity-log`, `coach-suggest`, `extract-lesson`.

### Changed (portage depuis `.claude/`)
- Scripts de hooks : `cd "$(dirname "$0")/../.."` → `cd "${CLAUDE_PROJECT_DIR}"` (les plugins
  tournent depuis un cache ; le chemin relatif y pointerait à côté).
- Hooks référencés via `bash "${CLAUDE_PLUGIN_ROOT}/scripts/…"` (indépendant du bit exécutable
  perdu à la copie cache, notamment sous Windows).
- `extract-lesson` : présent comme script non câblé dans le `.claude/` source → désormais
  câblé sur `PostToolUse` Bash (gated par significativité + flag `coach-mute`).

### Not included (chantiers suivants)
- `kit.config` et le hook `post-edit-format` (qui en dépend).
- Nouveau contenu : `inject-contract`, `retro`, `audit-claude-setup`, templates de docs.
- Bootstrap d'overlay par-projet, scan des sources externes Anthropic.
- Dé-duplication `.claude/` (dogfood) ↔ `plugins/kit-methode/` (distribuable) : copie assumée pour cette fondation.
