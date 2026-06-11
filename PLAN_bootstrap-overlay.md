# Plan — Commande `bootstrap` : poser l'overlay par-projet

> Cadrage : `MAPPING-KIT-METHODE.md` point 4 (§159) — « plugin générique + overlay mince posé par un bootstrap ». kit.config déjà couvert par userConfig.
> Mécanisme vérifié : `${CLAUDE_PLUGIN_ROOT}` est substitué dans le **contenu des commandes** → la commande peut lire des templates bundlés et les recopier dans le projet.

## Scope

- **Livrable (core-only v1)** : une commande `bootstrap` qui pose, dans le projet courant, l'**overlay** par-dessus le plugin générique : (1) `.claude/OPERATING-CONTRACT.md` (règles 1-5 du kit + placeholders 6-7) ; (2) `.claude/rules/example.md` (règle path-scoped commentée) ; (3) `CLAUDE.md` (hub projet) ; (4) `PROJECT_BRIEF.md`. **Seul composant du kit qui écrit des fichiers** → idempotent, aperçu avant écriture, **jamais d'écrasement sans demander**.
- **Out of scope** : **`domain-agent` + `domain-check` (différés à v0.6.0** — la partie la plus lourde/risquée : nommage interactif + sortie devant passer `validate`) ; `retro` ; auto-détection/édition de code applicatif ; toute écriture hors `.claude/` + 2 fichiers racine listés ; déploiement du marketplace/`extraKnownMarketplaces` (l'utilisateur ajoute le plugin lui-même). Pas de modification du `.claude/` du repo handbook.

## Files to create / modify

- `plugins/kit-methode/templates/rule.example.md` — *create* — règle path-scoped commentée (frontmatter `paths:` + 3 sections), 100 % placeholder.
- `plugins/kit-methode/templates/CLAUDE.hub.md` — *create* — hub CLAUDE.md projet (stack, conventions, commandes, pointeurs — placeholders).
- `plugins/kit-methode/templates/PROJECT_BRIEF.md` — *create* — brief projet (but, utilisateurs, contraintes, non-buts).
- `plugins/kit-methode/commands/bootstrap.md` — *create* — la commande. **Algorithme write-safety explicite** (pas seulement une consigne en prose) :
  1. Énumérer les 4 chemins cibles.
  2. Tester l'existence de **chacun** ; construire l'ensemble *créer* (absents) vs *sauter* (présents).
  3. **Imprimer l'aperçu** (créera / sautera) et demander un **go explicite**.
  4. Sur go : `Write` **uniquement** les chemins de l'ensemble *créer*, **fichier par fichier**. **Jamais `Edit`** un fichier existant, **jamais** `cp`/redirection `>` shell (clobber silencieux).
  5. Pour un fichier présent que l'utilisateur veut régénérer : exiger une confirmation explicite, par fichier.
  - **OPERATING-CONTRACT figé** : lire `${CLAUDE_PLUGIN_ROOT}/templates/operating-contract.md` **verbatim** (ne pas paraphraser ni régénérer-de-mémoire les règles 1-5) puis **ajouter un bloc statique** « ## 6. Hard conventions (project) <TODO> / ## 7. Sources of truth (project) <TODO> ».
  - Interroge le projet (nom, domaine principal) pour remplir le minimum du hub/BRIEF ; le reste = `<TODO>` marqués, rien deviné.
- `plugins/kit-methode/.claude-plugin/plugin.json` — *modify* — bump `0.4.0` → `0.5.0`.
- `plugins/kit-methode/README.md` — *modify* — section « Bootstrap d'un nouveau projet ».
- `plugins/kit-methode/CHANGELOG.md` — *modify* — section `0.5.0`.

## Dependencies between files

1. Les 3 `templates/*` (rule.example, CLAUDE.hub, PROJECT_BRIEF) existent **avant** `commands/bootstrap.md` (qui les lit/recopie).
2. `bootstrap.md` créé **avant** d'être documenté dans README.
3. `plugin.json` bump **avant** verify.
4. `claude plugin validate` (frontmatter de `bootstrap.md`) **en dernier**. Les `templates/*` vivent sous `templates/` (pas `agents/`/`commands/`) → **non chargés** comme composants (vérifié : le manifeste ne déclare aucun dossier template) ; confirmer au verify qu'aucun composant parasite n'apparaît.

## Known risks

- **R1 — Écriture destructive (risque dominant : c'est la seule commande qui écrit).** *Mitigation, inscrite dans la commande* : idempotence stricte — lister d'abord l'existant, **afficher un aperçu** (créera / sautera), demander un **go explicite**, n'écrire **que les fichiers absents**, **jamais écraser** sans confirmation par fichier. Aligne sur le profil prudence + les garde-fous `pre-tool-guard`.
- **R2 — Mauvais emplacement.** *Mitigation* : `.claude/` pour rules/agents/commands/contract ; racine pour `CLAUDE.md` + `PROJECT_BRIEF.md`. Documenté et affiché dans l'aperçu.
- **R3 — Templates exposés par erreur.** *Mitigation* : tous les templates vivent sous `templates/` (non déclaré dans le manifeste) ; vérifier au `claude plugin validate` qu'aucun composant parasite n'apparaît. (Risque réduit en core-only : plus de templates au format agent/commande.)
- **R4 — Placeholders mal remplis.** *Mitigation* : la commande demande nom de projet + domaine, remplit ces deux-là, laisse le reste en `<TODO: …>` explicites ; ne devine rien (cohérent avec audit-claude-setup).
- **R5 — Projet déjà équipé (standalone `.claude/`).** *Mitigation* : couverte par R1 (détection + skip + confirmation), pas de clobber.
- **R6 — Une commande = un prompt, pas testable fonctionnellement** (contrairement aux scripts de hooks). *Mitigation honnête* : je vérifie ce qui l'est vraiment — `claude plugin validate` (frontmatter bootstrap, absence de composant parasite) + validité des 3 templates bundlés. La write-safety repose sur l'**algorithme explicite** inscrit dans le prompt + son respect par le modèle (même classe de garantie que le read-only d'audit-claude-setup) ; la preuve runtime ne viendra qu'à l'exécution réelle dans un projet. Je ne prétends pas « testé » ce qui ne l'est pas (cf. règle 3 du contrat).
- Auth/sécurité/intégrité/types : **N/A** (markdown). Seule vraie précaution : l'écriture, traitée par R1.

## User checkpoint (✋)

1. **Étendue v1 = core-only** (tranché) : contract + rules + hub + BRIEF ; domain-agent/domain-check → v0.6.0.
2. **Modèle d'écriture** : algorithme explicite — énumérer → exists → **aperçu → confirmation → `Write` seulement l'absent**, jamais `Edit`/`cp`/`>`, jamais d'écrasement sans demander. Confirmer (seule commande mutante du kit).
3. **Interactivité** : demander nom de projet + domaine principal, remplir ces deux champs, laisser le reste en `<TODO>`. OK ?
4. **Emplacement** : `.claude/` (rules/agents/commands/contract) + racine (`CLAUDE.md`, `PROJECT_BRIEF.md`). OK ?
5. **Bump `0.5.0`**. OK ?
