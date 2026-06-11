# Plan — Étendre `bootstrap` : agent de domaine + `domain-check` (v0.7.0)

> Suite du bootstrap core (v0.5.0/0.6.0). Partie volontairement différée par la revue (la plus lourde : sortie instanciée devant être valide + nommage interactif). Maintenant traitée à part, avec plan + revue.

## Scope

- **Livrable** : `bootstrap` pose **aussi** l'overlay de domaine : `.claude/agents/<slug>-expert.md` et `.claude/commands/<slug>-check.md`, dérivés du **domaine** déjà demandé à l'étape 1. Deux nouveaux templates bundlés. Le bootstrap **slugifie** le domaine, **substitue `name` + `description`** dans le frontmatter (→ fichiers **immédiatement valides** et chargeables par le projet), laisse le **corps en `<TODO>`**. Conserve le modèle write-safety existant (idempotent, aperçu, create-only, jamais d'écrasement).
- **Out of scope** : Routine cloud d'`audit-claude-setup` ; toute autre commande ; modification du `.claude/` du repo handbook ; auto-détection du domaine (l'utilisateur le fournit).

## Files to create / modify

- `plugins/kit-methode/templates/domain-agent.md` — *create* — template d'agent de domaine. Frontmatter avec **tokens** `__DOMAIN_SLUG__` / `__DOMAIN__` (name: `__DOMAIN_SLUG__-expert`, description mentionnant `__DOMAIN__`, `model`, `tools`) + corps en `<TODO>` (contexte domaine, ce que l'agent vérifie, règles). Sous `templates/` → non chargé comme composant (le frontmatter à tokens n'est donc jamais validé côté plugin).
- `plugins/kit-methode/templates/domain-check.md` — *create* — commande fine : invoque l'agent `__DOMAIN_SLUG__-expert` **par nom nu** (convention du kit, cf. audit-quick/new-feature) sur les fichiers pertinents. Frontmatter `description` (token `__DOMAIN__`) + corps `<TODO>`.
- `plugins/kit-methode/commands/bootstrap.md` — *modify* — ajouter les 2 cibles à l'algorithme existant ; ajouter une étape **slugification** + **substitution des tokens** ; étendre l'aperçu et le rapport. **Contrat de substitution renforcé** :
  1. Slugifier le domaine, substituer `__DOMAIN_SLUG__`/`__DOMAIN__` **en mémoire**, puis **un seul `Write`** par cible — pas de fichier intermédiaire, **pas de `sed`/redirection sur la destination** (préserve create-only).
  2. **Gate no-residual-token** : après substitution, scanner le frontmatter rendu pour `__` ; si un token survit, **abandonner ce fichier et le signaler**, ne jamais écrire un composant cassé.
  3. Frontmatter résultant complet (name+description remplis) ; seul le corps garde des `<TODO>`.
  4. **Retirer** la note de report des Safeguards actuels (« domain-agent/domain-check = version ultérieure, ne pas scaffolder ici ») — sinon la commande se contredit.
- `plugins/kit-methode/.claude-plugin/plugin.json` — *modify* — bump `0.6.0` → `0.7.0`.
- `plugins/kit-methode/README.md` — *modify* — bootstrap pose désormais 6 fichiers ; retirer la note « à venir ».
- `plugins/kit-methode/CHANGELOG.md` — *modify* — section `0.7.0`.

## Dependencies between files

1. Les 2 `templates/domain-*.md` existent **avant** la modif de `bootstrap.md` (qui les lit/substitue).
2. `plugin.json` bump **avant** verify.
3. `claude plugin validate` **en dernier** — confirmer qu'aucun composant parasite n'apparaît malgré le frontmatter à tokens (templates non chargés).

## Known risks

- **R1 — Frontmatter instancié invalide (risque dominant).** Les fichiers écrits vont dans `.claude/agents|commands/` du projet → chargés par Claude Code ; un `name`/`description` resté en token = composant cassé. *Mitigation, APPLIQUÉE (pas seulement décrite)* : **gate no-residual-token** dans `bootstrap.md` — après substitution, scan du frontmatter rendu pour `__` ; si un token survit, le fichier est **abandonné, pas écrit**. C'est ce qui transforme le contrat en garde appliquée. Le plugin lui-même n'est pas affecté (templates sous `templates/`, non chargés).
- **R2 — Slug invalide.** Domaine avec espaces/accents/majuscules/caractères spéciaux → nom de fichier/agent invalide. *Mitigation* : règle slug explicite dans le prompt — minuscules, espaces→`-`, ne garder que `[a-z0-9-]`, compresser les `-` ; si le slug devient vide, redemander le domaine.
- **R3 — Write-safety.** Les 2 cibles rejoignent l'algorithme create-only/aperçu/jamais-d'écrasement existant. *Mitigation* : réutiliser tel quel, juste 2 cibles de plus ; collision (agent déjà présent) → SKIP.
- **R4 — `validate` perturbé par les tokens.** *Mitigation* : `templates/` non déclaré dans le manifeste → non chargé ; vérifier au verify que `validate` reste vert et n'expose aucun composant.
- **R5 — Commande = prompt, runtime non unit-testable.** *Mitigation honnête* : verify = `claude plugin validate` + relecture du contrat de substitution ; **en plus**, je peux **simuler la substitution** en isolation (sed des tokens sur une valeur d'exemple → faire valider le frontmatter instancié) pour prouver que la sortie serait valide. Le firing réel reste à l'exécution.
- Auth/sécurité/intégrité/types : **N/A** (markdown + écriture create-only déjà couverte).

## User checkpoint (✋)

1. **Contrat de substitution** : `name`+`description` remplis dans le frontmatter (sortie valide), corps en `<TODO>`. Confirmer.
2. **Règle slug** : minuscules, espaces→`-`, `[a-z0-9-]` seulement, `-` compressés. OK ?
3. **Write-safety inchangée** : create-only, aperçu, jamais d'écrasement (désormais 6 cibles). Confirmer.
4. **Test de substitution en isolation** (sed tokens → valider le frontmatter instancié) en plus du `plugin validate`. OK ?
5. **Bump `0.7.0`**. OK ?
