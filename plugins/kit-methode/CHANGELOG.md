# Changelog — kit-methode

Format : [Keep a Changelog](https://keepachangelog.com/), versions [SemVer](https://semver.org/).

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
