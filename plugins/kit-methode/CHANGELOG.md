# Changelog — kit-methode

Format : [Keep a Changelog](https://keepachangelog.com/), versions [SemVer](https://semver.org/).

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
