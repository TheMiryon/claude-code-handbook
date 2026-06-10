# Kit Méthode — plugin Claude Code

Discipline de travail réutilisable, extraite du **Claude Code Handbook** et éprouvée sur plusieurs projets. Le plugin apporte un noyau **générique** : agents de revue, commandes d'orchestration, hooks garde-fous. Le contenu spécifique à un projet (conventions dures, agents de domaine, règles path-scoped) reste **hors plugin** — il se pose par-dessus, par projet.

## Ce que contient le plugin

**Agents** (revue, read-only)
- `plan-reviewer` — challenge un `PLAN_<slug>.md` en mode staff engineer avant tout code.
- `code-auditor` — audit qualité (dead code, duplication, complexité, anti-patterns).
- `security-auditor` — audit sécurité (auth, secrets, injections, XSS, RGPD).

**Commandes**
- `ship` — verify + commit + push.
- `new-feature` — pipeline plan → revue de plan → code → verify → audits.
- `audit-quick` — code-auditor + security-auditor en parallèle.
- `coach` / `coach-mute` / `coach-on` — orientation « prochaine étape » + mute du Coach.
- `standup` — récap quotidien (fait / en cours / focus / friction).
- `extract-lesson` — épingle 1-3 leçons d'un commit dans `CLAUDE.md`.
- `audit-claude-setup` — audite le `.claude/` + les plugins actifs d'un projet et **propose** des améliorations étayées par les sources Anthropic (changelog, doc). **Read-only, n'applique jamais rien.**

**Hooks**
- `SessionStart` — récap git d'ouverture de session.
- `UserPromptSubmit` — réinjecte l'OPERATING-CONTRACT (`inject-contract`) à chaque tour.
- `PreToolUse` — garde-fous (`.env`, `rm -rf`, `git push --force`, `--no-verify`).
- `PostToolUse` — formatage post-écriture (`post-edit-format`, si configuré) + log d'activité (zéro token) + nudge `extract-lesson` après un commit significatif.
- `Stop` — test-gate (`stop-test-gate`, si configuré) + Coach : suggestions de fin de session selon ce qui a été touché.

## Installation

Le plugin est distribué via la marketplace hébergée dans ce repo :

```shell
/plugin marketplace add TheMiryon/claude-code-handbook
/plugin install kit-methode@kit-methode-marketplace
```

Pour tester en local depuis un clone :

```shell
/plugin marketplace add /chemin/vers/claude-code-handbook
/plugin install kit-methode@kit-methode-marketplace
```

Vérifier le packaging avant publication :

```bash
claude plugin validate ./plugins/kit-methode   # le plugin
claude plugin validate .                        # la marketplace (à la racine du repo)
```

## Invocations (namespacées)

Une fois installé, **les commandes sont préfixées par le nom du plugin** :

| Bare (dogfood local) | Installé via plugin    |
|----------------------|------------------------|
| `/ship`              | `/kit-methode:ship`    |
| `/new-feature`       | `/kit-methode:new-feature` |
| `/audit-quick`       | `/kit-methode:audit-quick` |
| `/coach`             | `/kit-methode:coach`   |
| `/coach-mute`        | `/kit-methode:coach-mute` |
| `/coach-on`          | `/kit-methode:coach-on` |
| `/standup`           | `/kit-methode:standup` |
| `/extract-lesson`    | `/kit-methode:extract-lesson` |

> Les hooks (`coach-suggest`, `extract-lesson`) impriment encore des noms `/...` nus
> dans leurs suggestions ; lis-les comme la forme namespacée ci-dessus en projet consommateur.

## Configuration (`userConfig`)

Deux hooks dépendent de la stack du projet. Claude Code te demande ces valeurs **à l'activation du plugin** (et tu peux les changer ensuite via `/plugin`). Tout est **optionnel** : par défaut, formatage désactivé et test-gate en auto-détection.

| Option | Rôle | Défaut |
|---|---|---|
| `package_manager` | `pnpm`/`npm`/`yarn`/`bun` | vide → **auto-détecté** via le lockfile |
| `test_cmd` | commande du test-gate | vide → repli `<gestionnaire> test` ; rien de détecté → gate off |
| `test_paths` | filtre : ne teste que si un fichier écrit correspond | vide → tout tour ayant écrit |
| `format_cmd` | formateur post-écriture (le chemin du fichier est ajouté en argument) | vide → **aucun formatage** (jamais deviné) |
| `test_gate_block` | tests rouges bloquent la fin du tour (`exit 2`) | `false` → **avertissement seulement** |
| `inject_contract` | réinjecte l'OPERATING-CONTRACT à chaque tour | `true` → mettre `false` pour économiser des tokens |

Comportement :
- **`post-edit-format`** ne fait rien tant que `format_cmd` est vide. Renseigné (ex. `prettier --write` ou `pnpm exec eslint --fix`), il formate chaque fichier écrit, silencieux et non-bloquant.
- **`stop-test-gate`** ne se déclenche qu'après **≥1 écriture** dans la session (jamais sur un tour de lecture/réponse), respecte `/coach-mute`, et reste **non-bloquant par défaut**. `test_paths` se compare aux chemins **repo-relatifs** tels que loggés (ex. `src/lib/calculations`), par sous-chaîne.
- **`inject-contract`** réinjecte un OPERATING-CONTRACT à chaque tour. Par défaut il injecte les **règles génériques 1-5** du kit (`templates/operating-contract.md`). Pour ajouter tes conventions dures et sources de vérité (règles 6-7), crée un **`.claude/OPERATING-CONTRACT.md`** dans ton projet : le hook l'injecte alors **à la place** du template. Mettre `inject_contract=false` pour le couper.

## Prérequis

- **bash** + **jq** disponibles dans le PATH (les hooks sont des scripts `.sh`).
  Sous Windows, Git Bash / WSL fournissent les deux.
- Les hooks opèrent sur le **projet consommateur** via `${CLAUDE_PROJECT_DIR}` ; les
  scripts bundlés sont référencés via `${CLAUDE_PLUGIN_ROOT}`.

## Périmètre & limites (v0.2.0)

- **Inclus** : 3 agents, 8 commandes, 7 hooks (5 purs + `post-edit-format` et `stop-test-gate`
  paramétrés par `userConfig`).
- **Pas encore inclus** (chantiers suivants) : nouveau contenu non-hook (`inject-contract`,
  `retro`, `audit-claude-setup`, templates de docs), bootstrap d'overlay par-projet,
  scan des sources externes.
- Le Coach et `extract-lesson` portent des **triggers d'exemple** (Supabase, migrations…)
  commentés dans les scripts : adapte-les à ta stack.

## Licence

MIT.
