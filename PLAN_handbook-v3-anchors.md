# Plan — Handbook V3 : les 3 anchors du ROADMAP (bilingue)

> Cadrage : `ROADMAP.md` V3 ranks #1-3. Multi-sessions : un anchor fini (EN+FR) à la fois ; la mécanique de release (version, CHANGELOG, EPUB, tag) ne se fait **qu'une fois, à la fin**, quand les 3 anchors sont posés.
> Structure vérifiée (agent Explore) : chapitres 00-13 + annexes A-I, EN/FR parallèles, prochaine annexe = **J**, version « V2 » en `<title>` + cover. Gabarits chapitre/annexe connus.

## Scope

- **Livrable (V3.0)** : 3 contenus du ROADMAP, **bilingues lock-step**, ajoutés à `en/` et `fr/source-v2.html` :
  - **Ch.14 Testing & TDD** (rank #1) — badge INTERMEDIATE.
  - **Ch.15 Third-party MCP & prompt-injection security** (rank #3) — badge ADVANCED.
  - **Annexe J Recovery playbook** (rank #2) — pas de badge.
  - + mécanique de release : bump version V2→V3 (title/cover/foreword), entrée CHANGELOG **V2 (manquante, à reconstruire en concis) + V3.0**, MAJ ROADMAP (anchors faits) + README (liens EPUB V3), rebuild EPUB, tag `v3.0.0` + Release.
- **Placement (recommandé, anti-churn)** : **appendre** — nouvelle **Part VI « Discipline & safety »** contenant Ch.14 + Ch.15 (après Part V / Ch.13), et **Annexe J** après Annexe I. **Aucune renumérotation** des chapitres/annexes existants (sinon : tous les renvois internes + ancres + pages TOC à refaire = risque élevé).
- **Out of scope** : ROADMAP ranks #4-7 (Windows hooks, onboarding legacy, context-window, headless/CI) → V3.1+ ; nouveaux chapitres plugins/`/loop`/Routines (axe « nouveautés » distinct, pas dans les 3 anchors choisis) → chantier séparé ; refonte de chapitres V2 existants ; traductions hors EN/FR.

## Files to create / modify

- `en/source-v2.html` — *modify* — Part VI cover + Ch.14 + Ch.15 (après Ch.13) ; Annexe J (après Annexe I) ; entrées TOC (Part VI + Ch.14/15 + Annexe J) ; bump version (title L5, cover L38, foreword note L64).
- `fr/source-v2.html` — *modify* — **strict miroir** des ajouts EN, traduits (insertions aux positions parallèles ; title L5, cover L35, foreword L59).
- `CHANGELOG.md` — *modify* — ajouter l'entrée **V2** manquante (concise, reconstituée depuis git/README) **puis** l'entrée **V3.0** (les 3 anchors).
- `ROADMAP.md` — *modify* — marquer ranks #1-3 comme livrés en V3.0 ; laisser #4-7 en file.
- `README.md` — *modify* — version + liens EPUB V3.
- `en/claude-code-handbook-v3.epub` / `fr/le-code-du-claudeur-v3.epub` — *build* — via `build-epub.ps1` (+ `prepare-for-epub.js`).

**Ne JAMAIS committer** : `en/source-v2-rendered.html`, `fr/source-v2-rendered.html` (artefacts EPUB gitignorés).

## Dependencies between files

1. Par anchor : écrire le contenu **EN puis FR** (jamais l'un sans l'autre — règle dure du repo), + ses entrées TOC dans les deux fichiers, avant de passer à l'anchor suivant.
2. Les 3 anchors posés (EN+FR) **avant** la mécanique de release.
3. Bump version + CHANGELOG + ROADMAP + README **avant** rebuild EPUB (l'EPUB embarque la version).
4. Rebuild EPUB **avant** tag/Release (le Release attache les EPUB).
5. `prepare-for-epub.js` (pré-rend Mermaid→SVG) **avant** `build-epub.ps1`.

**Cadence de commit** : **chaque anchor fini = un commit** (EN+FR ensemble, diff de parité reviewable) ; la mécanique de release (bump + CHANGELOG + ROADMAP + README + EPUB) = **commit final** séparé.

**Gate de clôture (pre-release checklist CLAUDE.md)** : avant de clore — les 2 EPUB rebuildent sans erreur, EN/FR en sync, CHANGELOG a la section V3.0 datée, **tag = version CHANGELOG = version README**, GitHub Release marquée **« Latest »** avec **les 2 EPUB attachés**.

## Known risks

- **R1 — Dérive bilingue (règle produit n°1).** Tout ajout EN doit avoir son pendant FR. *Mitigation* : authoring par paire EN+FR par anchor ; aucun commit avec un seul côté ; relecture de parité (mêmes sections des deux côtés) avant chaque commit.
- **R2 — Churn de renumérotation.** *Mitigation* : on **append** (Part VI + Annexe J), zéro renumérotation des 00-13 / A-I → aucun renvoi interne ni ancre cassés. (Coût : Testing arrive en Part VI, pas tôt — compromis assumé vs le risque.)
- **R3 — Numéros de page TOC.** Les `toc-page` sont manuels et inconnus avant rendu. *Mitigation* : valeurs au mieux/placeholder, corrigées après rendu si nécessaire ; sur le site HTML elles sont cosmétiques.
- **R4 — Build EPUB non vérifiable par moi.** Besoin de Pandoc + Node en PATH ; bug connu PS 5.1 (backtick) sur le pandoc FR (workaround : one-liner manuel). *Mitigation* : je tente le build ; si l'env ne le permet pas, je te livre les commandes exactes à lancer (`! …`). Honnête : « EPUB rebuilt » seulement si réellement produit.
- **R5 — Exactitude du contenu Claude Code (anchors 1 & 3 surtout).** *Mitigation* : **vérifier à la source au moment de rédiger chaque anchor** (doc Claude Code : MCP/permissions/trust, prompt-injection, recovery/checkpoints, testing) — pas de mémoire ; citer/aligner sur la doc. C'est une règle d'authoring par anchor, pas de planification.
- **R6 — Commit d'artefacts.** *Mitigation* : ne jamais stager `*-rendered.html` ; vérifier `git status` avant commit.
- **R7 — Taille / multi-sessions.** 2 chapitres + 1 annexe × 2 langues = beaucoup de prose. *Mitigation* : séquencer, checkpoint après chaque anchor, release seulement à la fin.
- Auth/données/types : **N/A** (site statique, contenu).

## User checkpoint (✋)

1. **Placement = append** (Part VI « Discipline & safety » : Ch.14 Testing, Ch.15 Security ; Annexe J Recovery), **sans renumérotation**. OK, ou tu tiens à insérer Testing tôt (= renumérotation, plus de churn) ?
2. **Ordre de rédaction** : commencer par **Annexe J Recovery** (la plus courte → valide le flux bilingue+release sur le plus petit morceau), puis Ch.14 Testing, puis Ch.15 Security. OK, ou suivre le rank ROADMAP (Testing d'abord) ?
3. **Badges** : Testing = INTERMEDIATE, Security = ADVANCED. OK ?
4. **Nom de la Part VI** : « Discipline & safety » (proposition). OK / autre ?
5. **Release** : version `v3.0.0`, et entrée CHANGELOG V2 reconstituée en concis. Tag + Release **après** que les 3 anchors soient relus et l'EPUB rebuild. OK ?
6. **EPUB** : je tente le rebuild ; si Pandoc/PS indisponible je te passe les commandes. OK ?
