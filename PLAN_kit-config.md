# Plan — Paramétrer les hooks 🟡 du plugin kit-methode via `userConfig` natif

> Cadrage : `MAPPING-KIT-METHODE.md` point 3 (`kit.config`) + les deux hooks 🟡 qui en dépendent.
> Décision tranchée (checkpoint Step 0) : **userConfig natif + auto-détection**, pas de fichier `kit.config` maison.
> Spec vérifiée à la source (Plugins reference §User configuration) : `userConfig` déclare des valeurs demandées à l'activation, exportées aux scripts comme `CLAUDE_PLUGIN_OPTION_<KEY>` et substituables `${user_config.KEY}` dans les commandes de hooks.

## Scope

- **Livrable** : la couche hooks du plugin devient paramétrable **par projet sans hand-edit**, via `userConfig` (demandé à l'activation) + **auto-détection du gestionnaire de paquets** (lockfile). On livre les deux hooks 🟡 absents de la fondation : `post-edit-format` (formatage post-écriture) et `stop-test-gate` (tests en fin de tour). Zéro-config par défaut : ce qui est déductible n'est pas demandé ; ce qui n'a pas de défaut sûr (formateur) est no-op tant que non configuré.
- **Out of scope** : reste du point 2 (contenu non-hook : `inject-contract`, `retro`, `audit-claude-setup`, templates de docs), bootstrap d'overlay (4), scan externe (5), v3 (6). Pas de fichier `kit.config` committé (écarté au profit de userConfig). Pas de dé-dup `.claude/` ↔ plugin.

## Files to create / modify

- `plugins/kit-methode/.claude-plugin/plugin.json` — *modify* — ajouter le bloc `userConfig` (`package_manager`, `test_cmd`, `test_paths`, `format_cmd`, `test_gate_block`) ; bump `version` `0.1.0` → `0.2.0`.
- `plugins/kit-methode/scripts/kit-env.sh` — *create* — helper **sourcé** par les deux hooks : détecte le gestionnaire de paquets (pnpm-lock.yaml→pnpm, yarn.lock→yarn, bun.lockb→bun, package-lock.json→npm ; override par `$CLAUDE_PLUGIN_OPTION_PACKAGE_MANAGER`) et résout `TEST_CMD` / `FORMAT_CMD` depuis l'env. Source unique pour éviter le drift. **Sûr sous `set -e`** : aucun construct fatal (les tests de présence de lockfile utilisent `[ -f … ]` / `|| true`, jamais un `grep` nu qui retournerait non-zéro) ; les consommateurs le sourcent **après** leur `cd … || exit 0` et chaque résolution a un fallback. La promesse « ne plante jamais » repose là-dessus.
- `plugins/kit-methode/scripts/post-edit-format.sh` — *create* — formate le fichier écrit via `$FORMAT_CMD` (résolu par kit-env). **No-op si `format_cmd` vide** (aucun formateur deviné). Conserve le skip des sorties de build (`node_modules`, `dist`, `.next`, migrations). Non-bloquant.
- `plugins/kit-methode/scripts/stop-test-gate.sh` — *create (à neuf)* — lance les tests en fin de tour. **Garde inconditionnelle « ≥1 écriture cette session »** (même logique `WRITES>=1` que coach-suggest, via `.claude/logs/activity.log` filtré sur le `session_id`) : un Stop lecture-seule / réponse-seule ne lance JAMAIS de tests, indépendamment de `test_paths`. `test_cmd` vide → fallback `<pm détecté> test` ; si aucun PM détecté → no-op. Filtre `test_paths` **en plus** de la garde (ne lance que si les fichiers écrits intersectent ces chemins). **Warn-only par défaut** (stderr) ; bloquant (exit 2) seulement si `test_gate_block=true`. Partage le flag `.claude/coach-mute`.
  - **Format des chemins** : `test_paths` est comparé aux chemins tels que stockés dans `activity.log` (repo-relatifs, après `sed 's/.*| //'`) par sous-chaîne — documenté dans le README pour que l'utilisateur saisisse le bon format (ex. `src/lib/calculations`), sinon le filtre resterait silencieusement inactif.
- `plugins/kit-methode/hooks/hooks.json` — *modify* — câbler `post-edit-format` sur `PostToolUse` `Edit|Write` (avant activity-log) et `stop-test-gate` sur `Stop` (avant coach-suggest), via `bash "${CLAUDE_PLUGIN_ROOT}/scripts/…"`.
- `plugins/kit-methode/README.md` — *modify* — section « Configuration (userConfig) » : les 5 options, l'auto-détection, le comportement no-op/warn-only par défaut.
- `plugins/kit-methode/CHANGELOG.md` — *modify* — section `0.2.0`.

## Dependencies between files

1. `kit-env.sh` doit exister **avant** `post-edit-format.sh` et `stop-test-gate.sh` (ils le sourcent via `${CLAUDE_PLUGIN_ROOT}`).
2. Les 3 scripts doivent exister **avant** d'ajouter leurs entrées dans `hooks.json`.
3. `userConfig` dans `plugin.json` **avant** verify (sinon les options ne sont pas déclarées).
4. `claude plugin validate ./plugins/kit-methode` + `bash -n` sur les nouveaux scripts **en dernier**.

## Known risks

- **R1 — env userConfig non garantie en dev (`--plugin-dir`).** `CLAUDE_PLUGIN_OPTION_*` est peuplé à l'activation d'un plugin installé ; non confirmé en mode `--plugin-dir`. *Mitigation* : les scripts gèrent l'absence (auto-détection + no-op). Aucun script ne plante si l'env est vide.
- **R2 — gate bloquant = piège.** Un `Stop` qui bloque (exit 2) sur tests rouges peut empêcher de terminer le tour. *Mitigation* : **warn-only par défaut**, bloquant strictement opt-in (`test_gate_block`), respecte `coach-mute`, et ne tourne que si une commande de test est résolue.
- **R3 — tests à chaque Stop = lent/coûteux.** *Mitigation* : filtre `test_paths` (ne lance que si l'activité a touché ces chemins) ; sinon ne lance que si ≥1 écriture dans la session.
- **R4 — `sh -c "$FORMAT_CMD"` = exécution de commande depuis la config.** C'est la config du *propre* plugin de l'utilisateur (confiance), pas une entrée tierce. *Mitigation* : documenté ; pas de valeur par défaut devinée.
- **R5 — auto-détection PM ambiguë** (monorepo, plusieurs lockfiles). *Mitigation* : override explicite `package_manager` ; ordre de détection documenté ; si rien de sûr → no-op plutôt que deviner.
- **R6 — dogfood impossible ici.** Le repo handbook n'a ni test ni formateur → les deux hooks no-op dans ce repo. Le chemin positif n'est validable qu'à l'install réelle dans un projet à stack (Trading/Nyx/pivola). À signaler ; non prouvé sans install.
- Auth/sécurité, intégrité de données, type-safety : **N/A** (config + scripts shell, aucun code applicatif, aucun secret, aucun appel réseau).

## User checkpoint (✋)

Décisions à valider avant code :

1. **stop-test-gate non-bloquant par défaut** (warn-only ; bloquant via `test_gate_block=true`). *Recommandé* (cf. R2, profil prudent). OK ?
2. **Déclencheur du gate** : garde « ≥1 écriture » **toujours** appliquée (jamais de tests sur un Stop conversationnel) ; `test_paths` vide → lance sur tout Stop ayant écrit ; renseigné → seulement si les fichiers écrits intersectent ces chemins. OK ?
3. **Pas de formateur deviné** : `format_cmd` vide ⇒ `post-edit-format` no-op (on ne lance jamais prettier/eslint « au hasard »). Confirmer.
4. **Helper partagé `kit-env.sh`** (sourcé par les 2 hooks) vs logique inline dupliquée. *Recommandé* : helper (anti-drift, 2 consommateurs + extensions futures).
5. **Bump `0.2.0`** (mineur : ajout rétro-compatible). OK ?
