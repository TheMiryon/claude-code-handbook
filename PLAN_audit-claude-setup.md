# Plan — Commande `audit-claude-setup` (auto-audit local + scan externe, propose-only)

> Cadrage : `MAPPING-KIT-METHODE.md` points 2 (créer la commande) + 5 (scan sources externes). Décision Step 0 : **rapport seul, zéro écriture** ; Routine cloud hors scope (déjà tranché : commande à la main d'abord).
> Sources externes vérifiées : changelog `code.claude.com/docs/en/changelog`, index `code.claude.com/docs/llms.txt`, repos `anthropics/claude-agent-sdk-{python,typescript,demos}`, `anthropics/claude-code`.

## Scope

- **Livrable** : une commande `audit-claude-setup` (prompt markdown) **strictement read-only** qui produit un rapport en 2 parties **nettement séparées** : **(A) audit local** — déterministe, zéro réseau, se lit comme **autoritaire** — du `.claude/` du projet *et* du plugin kit-methode actif (cohérence hooks↔settings/hooks.json, frontmatter des commands/agents, anchors morts, dérive wired↔présent, duplication standalone↔plugin) ; **(B) scan externe** — best-effort, dépendant du réseau, se lit comme **« suggestions étayées »** (jamais autoritaire) — confrontant la version installée et le setup aux sources Anthropic, proposant des améliorations **avec le diff exact à appliquer, jamais appliqué**. L'incertitude de B ne doit pas contaminer A.
- **Out of scope** : Routine cloud d'automatisation ; toute écriture/auto-merge ; `retro`, `inject-contract`, templates de docs, bootstrap (chantiers séparés) ; modification du `.claude/` du repo handbook (dogfood inchangé, comme aux chantiers précédents).

## Files to create / modify

- `plugins/kit-methode/commands/audit-claude-setup.md` — *create* — la commande. Frontmatter `description` + `argument-hint` (ex. `[local | external | all]` pour cibler une partie). Corps = procédure A puis B, format de sortie, garde-fous.
- `plugins/kit-methode/.claude-plugin/plugin.json` — *modify* — bump `version` `0.2.0` → `0.3.0`.
- `plugins/kit-methode/README.md` — *modify* — ajouter la commande à la liste + une ligne « read-only, propose-only ».
- `plugins/kit-methode/CHANGELOG.md` — *modify* — section `0.3.0`.

## Dependencies between files

1. `audit-claude-setup.md` créé **avant** d'être référencé dans README.
2. `plugin.json` bump **avant** verify (cohérence version ↔ CHANGELOG).
3. `claude plugin validate ./plugins/kit-methode` (vérifie le frontmatter de la nouvelle commande) **en dernier**.

## Known risks

- **R1 — Hallucination du scan externe (le risque dominant).** « Propose des améliorations d'après la doc » peut inventer des fonctionnalités OU **mal lire** une vraie page (URL valide, contenu mal décrit). *Mitigation renforcée, inscrite dans la commande* : chaque proposition externe DOIT (a) citer une **URL effectivement fetchée** ET (b) **quoter le snippet/ligne exacte** du contenu fetché qui la justifie, juste à côté de la proposition. Si le contenu ne soutient pas directement la claim → émettre en **🔵 question, jamais en proposition**. Interdiction de s'appuyer sur la mémoire du modèle pour les features Claude Code. Une citation d'URL sans preuve quotée est interdite.
- **R2 — Accès web indisponible** (offline, headless, WebFetch non autorisé). *Mitigation* : la partie B est best-effort ; si un fetch échoue, la commande le signale et **continue l'audit local** (A) qui ne dépend pas du réseau. `argument-hint` `local` permet de forcer A seul.
- **R3 — Détection de version** (`claude --version` à parser). *Mitigation* : best-effort ; à défaut, comparer au « latest » du changelog de façon qualitative.
- **R4 — Faux positifs de l'audit local.** La double présence standalone (`.claude/`) ↔ plugin est parfois légitime (dogfood). *Mitigation* : classer en ℹ/🟠 avec explication, pas en 🔴 automatique.
- **R5 — Cible de l'audit quand le kit est un plugin.** La discipline vit alors dans le cache plugin, pas `.claude/`. *Mitigation* : la commande détecte les deux sources (`claude plugin list` + lecture `.claude/`).
- **R6 — La commande pourrait écrire malgré la consigne.** Le « diff exact à appliquer » de B agite l'étape suivante sous le nez du modèle. *Mitigation* : garde-fou en tête du prompt — « read-only strict : aucun Edit/Write/commit ; tu PROPOSES, tu n'appliques jamais », répété dans la section sortie. **Honnêteté** : propose-only est une **convention de prompt, pas un sandbox** ; le README ne doit PAS impliquer un verrou technique. Un verrou dur = affaire de permissions/settings, hors scope ici.
- Auth/sécurité/intégrité/types : **N/A** (prompt read-only). Seule précaution data : ne jamais afficher le contenu de `.env*` / secrets pendant l'audit.

## User checkpoint (✋)

1. **Anti-hallucination** : toute proposition externe **liée à une URL fetchée** (sinon non émise). *Recommandé*, confirme.
2. **Étendue du scan B (résolue vers le léger, cf. revue)** : **changelog + pages doc cœur** (plugins, hooks, skills, settings) uniquement. **Pas de fetch du source SDK** (high-noise, aimant à hallucinations, peu lié à un plugin-discipline). SDK éventuellement cité plus tard si besoin nommé. Confirme.
3. **`argument-hint`** : `[local | external | all]` (défaut `all`) pour pouvoir lancer l'audit local seul (utile offline). OK ?
4. **Dogfood** : commande ajoutée **au plugin seulement**, pas au `.claude/` du repo (cohérent avec les chantiers précédents). OK ?
5. **Bump `0.3.0`**. OK ?
