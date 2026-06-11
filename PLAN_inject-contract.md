# Plan — Hook `inject-contract` + template OPERATING-CONTRACT (règles 1-5)

> Cadrage : `MAPPING-KIT-METHODE.md` point 2 + §6 (« la pièce centrale »). Découpe générique 1-5 / overlay 6-7.
> Mécanisme vérifié à la source (Hooks reference) : injection de contexte via `hookSpecificOutput.additionalContext` (JSON sur stdout) ; réinjection **à chaque tour** = event **`UserPromptSubmit`** (JSON obligatoire ; stdout nu → debug log seulement). Sur resume, l'`additionalContext` est rejoué depuis le transcript → pas de staleness pour un contrat statique.

## Scope

- **Livrable** : un hook `UserPromptSubmit` qui réinjecte l'OPERATING-CONTRACT à chaque tour. Le plugin **fournit les règles 1-5 génériques** (template bundlé) ; **si** le projet a un `.claude/OPERATING-CONTRACT.md` (ses règles 6-7 overlay incluses), le hook injecte **ce fichier** à la place. Désactivable via `userConfig` (`inject_contract`, défaut on).
- **Out of scope** : `retro`, templates de docs (STACK/CONVENTIONS/WORKFLOW), bootstrap d'overlay (point 4) — chantiers séparés. Pas de paramétrage du seuil de gate (règle 4 = texte fixe « ≥3 fichiers » ici). Pas de modification du `.claude/` du repo handbook (dogfood inchangé).

## Files to create / modify

- `plugins/kit-methode/templates/operating-contract.md` — *create* — les **règles 1-5 génériques** (mode CO-PILOTE ; confidence card `🎯 X% · Trou:` + `⚠️ TROU` ; statut explicite codé≠testé≠vérifié ; gates chantier≥3→/new-feature, push→/ship ; contrarian par défaut, couper>ajouter). Concis (~30-40 lignes : chaque tour = coût tokens). Bundlé, lu via `${CLAUDE_PLUGIN_ROOT}`.
- `plugins/kit-methode/scripts/inject-contract.sh` — *create* — hook. **Ne source PAS kit-env.sh** (aucune logique PM/test) et **pas de `cd`** : chemins **absolus** `${CLAUDE_PROJECT_DIR}/.claude/OPERATING-CONTRACT.md` (projet, prioritaire si présent) et `${CLAUDE_PLUGIN_ROOT}/templates/operating-contract.md` (fallback bundlé). **Toggle à l'idiome maison** : `INJECT="${CLAUDE_PLUGIN_OPTION_INJECT_CONTRACT:-true}"; [ "$INJECT" = "true" ] || exit 0`. Lit le fichier puis **émet `hookSpecificOutput.additionalContext` via `jq -Rs`** (échappement sûr). **Sortie vide (exit 0, rien)** si jq manque, fichier illisible **ou vide** (`[ -s "$FILE" ]`) — jamais de JSON malformé ni d'injection inutile.
- `plugins/kit-methode/.claude-plugin/plugin.json` — *modify* — ajouter `userConfig.inject_contract` (boolean, défaut `true`) ; bump `0.3.0` → `0.4.0`.
- `plugins/kit-methode/hooks/hooks.json` — *modify* — ajouter le bloc `UserPromptSubmit` → `inject-contract.sh`.
- `plugins/kit-methode/README.md` — *modify* — documenter le hook, l'override par `.claude/OPERATING-CONTRACT.md`, le toggle, le coût tokens.
- `plugins/kit-methode/CHANGELOG.md` — *modify* — section `0.4.0`.

## Dependencies between files

1. `templates/operating-contract.md` existe **avant** `inject-contract.sh` (qui le lit en fallback).
2. `inject-contract.sh` + `userConfig.inject_contract` existent **avant** d'ajouter l'entrée dans `hooks.json`.
3. `claude plugin validate` + `bash -n` + test fonctionnel du JSON émis **en dernier**.

## Known risks

- **R1 — Coût tokens.** Réinjecter le contrat à **chaque** prompt ajoute des tokens par tour. *Mitigation* : contrat concis (1-5 seulement) ; toggle `inject_contract` (off possible) ; variante `SessionStart` (une fois) documentée si l'utilisateur préfère.
- **R2 — JSON malformé.** Contenu du contrat (newlines, guillemets, backticks) à échapper. *Mitigation* : construire le JSON avec `jq -Rs` (slurp fichier → string JSON sûre), jamais de concat. Un prompt cassé par un JSON invalide serait grave → en cas de doute, **n'émettre rien**.
- **R3 — jq absent / fichier illisible / vide.** *Mitigation* : gardes explicites (`command -v jq`, `[ -r "$FILE" ]`, `[ -s "$FILE" ]`), sortie vide + exit 0 (pas d'injection plutôt que sortie corrompue ou tokens vides).
- **R4 — Double discipline.** Si le projet a déjà sa propre injection (`.claude/` standalone) **et** le plugin → contrat injecté deux fois. *Mitigation* : documenté ; `audit-claude-setup` (chantier précédent) détecte déjà la duplication standalone↔plugin.
- **R5 — Resume staleness.** Aucune (contrat statique ; le rejeu transcript est correct). Noté pour mémoire.
- **R6 — Dogfood live impossible** (le repo n'active pas le plugin sur lui-même). *Mitigation* : tester le JSON émis en isolation (entrée synthétique → vérifier `additionalContext` valide via `jq`).
- Auth/sécurité/intégrité/types : **N/A** (hook read-only qui n'écrit rien ; injecte seulement du texte de discipline, aucun secret).

## User checkpoint (✋)

1. **Event = `UserPromptSubmit`** (chaque tour, conforme au mapping « réinjecté chaque tour ») plutôt que `SessionStart` (une fois, moins cher mais peut s'estomper sur longue session). *Recommandé* : UserPromptSubmit + toggle. OK ?
2. **Toggle `userConfig.inject_contract`** (boolean, défaut `true`). OK ?
3. **Résolution overlay** : projet `.claude/OPERATING-CONTRACT.md` si présent, sinon template bundlé 1-5. OK ?
4. **Règle 4 (gate)** : seuil en dur « ≥3 fichiers » dans le template (pas de paramétrage ce chantier). OK ?
5. **Bump `0.4.0`**. OK ?

> Note technique (résolue) : le hook n'utilise pas kit-env.sh ni `cd` (chemins absolus) ; toggle à l'idiome maison `:-true` / test `= "true"` ; gardes jq/lisible/non-vide.
