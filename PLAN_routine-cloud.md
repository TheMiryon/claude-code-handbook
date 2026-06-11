# Plan — Routine cloud d'`audit-claude-setup` (GitHub Actions, safe-by-default)

> Cadrage : `MAPPING-KIT-METHODE.md` point 5 — automatiser le scan externe d'`audit-claude-setup`, **diff proposé jamais auto-mergé**. Décision : « à la main d'abord » (fait + prouvé) → routine maintenant.
> Spec vérifiée (code.claude.com/docs/en/github-actions) : action `anthropics/claude-code-action@v1` ; inputs `prompt` (accepte un skill), `anthropic_api_key: ${{ secrets.ANTHROPIC_API_KEY }}`, `plugin_marketplaces` (URLs git, newline) + `plugins` (newline) pour installer un plugin avant exécution, `claude_args`. Trigger `on: schedule: cron`. `github_token` + permissions `issues: write` permettent à Claude d'ouvrir une issue.

## Scope

- **Livrable** : un workflow GitHub Actions committé qui lance `/kit-methode:audit-claude-setup external` (plugin installé depuis la marketplace de ce repo) et **ouvre une issue** avec le rapport / diff proposé. **Jamais d'auto-merge, jamais de push/PR** — garanti par les **permissions** (pas seulement le prompt). **Safe-by-default** : `workflow_dispatch` (manuel) + `schedule:` **commenté** ; inerte tant que le secret `ANTHROPIC_API_KEY` n'est pas ajouté ET le cron décommenté → aucun déclenchement ni coût au merge.
- **Out of scope** : Routine native Claude (agent cloud live) — variante mentionnée, non créée (action outward + coût récurrent). Auto-application des propositions. Audit de projets tiers (le workflow tourne sur ce repo).

## Files to create / modify

- `.github/workflows/kit-methode-audit.yml` — *create* — le workflow : `on: workflow_dispatch` + cron commenté (avec **garde-commentaire : ne PAS ajouter de trigger `pull_request`/`pull_request_target`** → exposerait `ANTHROPIC_API_KEY` au code de forks) ; `permissions: contents: read, issues: write` (pas de `pull-requests`, pas de `contents: write`) ; job ubuntu ; **pas de `actions/checkout`** (scope `external` = scan doc seul, ne lit pas le FS du repo ; commenté comme « à ajouter pour un scope `all` ») ; `anthropics/claude-code-action@v1` avec `anthropic_api_key`, `plugin_marketplaces: https://github.com/TheMiryon/claude-code-handbook.git` (clone le **default branch = main** → fonctionnel **une fois PR #3 mergée**, le workflow arrivant sur main avec le plugin), `plugins: kit-methode@kit-methode-marketplace`, `prompt: "/kit-methode:audit-claude-setup external"` + consigne d'ouvrir **une issue** récapitulative et **rien d'autre**, `claude_args: --model claude-sonnet-4-6 --max-turns 15` (**15 = levier de coût**, commenté).
- `plugins/kit-methode/README.md` — *modify* — courte section « Automatiser l'audit (routine) » : pointeur vers le workflow + les 2 étapes d'activation (ajouter le secret, décommenter le cron) + la garantie permissions.

## Dependencies between files

1. Le workflow référence le nom de marketplace `kit-methode-marketplace` (de `.claude-plugin/marketplace.json`, déjà en place) et le skill namespacé `/kit-methode:audit-claude-setup` (déjà livré). Aucune dépendance de création nouvelle.
2. Lint YAML + relecture vs spec **en dernier** (pas de `claude plugin validate` ici : artefact CI, pas composant plugin).

## Known risks

- **R1 — Secret / sécurité.** Clé API en clair = fuite. *Mitigation* : `${{ secrets.ANTHROPIC_API_KEY }}` uniquement, jamais hardcodé ; permissions **least-privilege** (`contents: read`, `issues: write`).
- **R2 — Déclenchement / coût involontaire.** *Mitigation* : `workflow_dispatch` + cron **commenté** ; le job échoue proprement sans le secret. Rien ne tourne tant que l'utilisateur n'a pas opt-in (secret + cron). Documenté.
- **R3 — Auto-merge / écriture non voulue (la garantie centrale).** *Mitigation* : **permissions du workflow** sans `contents: write` ni `pull-requests` → même si le modèle essayait, il **ne peut pas** push/PR. Seul `issues: write` est accordé. C'est une garantie *appliquée*, pas seulement promise par le prompt (contrairement au propose-only d'audit-claude-setup).
- **R4 — Install du plugin en CI / reachability de branche (catch de la revue).** L'URL nue clone le **default branch (main)** ; le plugin n'est sur `main` qu'**après** le merge de PR #3. *Mitigation* : le workflow est committé DANS PR #3 → il arrive sur main **en même temps** que le plugin ; documenté comme **activation post-merge** (et de toute façon inerte sans secret). Nom `kit-methode@kit-methode-marketplace` confirmé vs `marketplace.json`.
- **R7 — Exfil du secret par fork.** *Mitigation* : pas de trigger `pull_request`/`pull_request_target` (seuls `workflow_dispatch` + `schedule`), + garde-commentaire dans le fichier pour qu'un futur mainteneur ne réintroduise pas le vecteur.
- **R5 — Non testable sans secret.** *Mitigation honnête* : je lint le YAML et vérifie chaque champ vs la doc ; le run CI réel n'est prouvable qu'une fois le secret ajouté par l'utilisateur. Pas de « testé » abusif.
- **R6 — Dérive de modèle.** `--model claude-sonnet-4-6` peut vieillir. *Mitigation* : champ unique, commenté comme ajustable.
- Intégrité données/types : **N/A**.

## User checkpoint (✋)

1. **Forme = GitHub Action committée** (pas de Routine native live sur ton compte). Recommandé (safe). OK ?
2. **Safe-by-default** : `workflow_dispatch` + cron commenté, inerte sans secret. Confirmer.
3. **Garantie no-auto-merge par les permissions** (`issues: write` seul ; pas de write/PR). Confirmer.
4. **Modèle** `claude-sonnet-4-6` (ajustable). OK ?
5. **Emplacement** `.github/workflows/` de ce repo. OK ?

> Tu pars dormir : « on fait la routine » = ton go préalable. Je patche les 🟡 de la revue moi-même et je vais jusqu'au commit ; je ne m'arrête que sur un 🔴.
