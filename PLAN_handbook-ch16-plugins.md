# Plan — Handbook Ch.16 « Plugins & marketplaces » (V3.1, bilingue)

> Suite de la V3. Chapitre off-roadmap mais à fort impact : la primitive « plugin » est absente du livre. Matériau de première main = le kit-methode construit + prouvé cette session. Spec plugin/marketplace déjà vérifiée à la source (code.claude.com, cette session) ; `/loop` + Routines à vérifier à la rédaction.

## Scope

- **Livrable** : un nouveau **chapitre 16 « Plugins & marketplaces »** (badge ADVANCED) dans une **nouvelle Part VII « Packaging & distribution »**, **bilingue EN+FR lock-step**, + la **release V3.1** (cover « Version 3.1 », CHANGELOG, ROADMAP, README, rebuild EPUB, tag `v3.1.0`).
- **Placement** : **append** — Part VII + Ch.16 après le Ch.15 (fin de Part VI), avant le part-cover des Annexes. **Aucune renumérotation** (00-15 / A-J intacts).
- **Out of scope** : refonte des chapitres existants ; documentation exhaustive de toutes les nouveautés (on cite `/loop` + Routines en une section, pas un chapitre chacun) ; ranks ROADMAP 4-7 (restent en file) ; changement des noms de fichiers EPUB (restent `-v3.epub`, rebuildés — V3.1 est une mineure de la ligne V3).

## Files to create / modify

**Contenu (commit 1)**
- `en/source-v2.html` — *modify* — Part VII cover + Ch.16 (après Ch.15) + entrées TOC (Part VII + Ch.16) **+ bump de la page TOC « Annexes »** (les `toc-page` sont **manuels**, cosmétiques côté HTML — l'EPUB régénère sa propre TOC via pandoc `--toc` ; je les garde grossièrement cohérents).
- `fr/source-v2.html` — *modify* — **miroir** traduit aux positions parallèles (idem TOC + page Annexes).

**Release V3.1 (commit 2)**
- `en/source-v2.html` / `fr/source-v2.html` — *modify* — cover « Version 3 » → « Version 3.1 » ; foreword : **ajouter une clause courte « V3.1 adds the Plugins chapter »**, sans réécrire le paragraphe d'historique V3.
- `CHANGELOG.md` — *modify* — entrée **V3.1** datée.
- `ROADMAP.md` — *modify* — noter le chapitre Plugins livré en V3.1.
- `README.md` — *modify* — « Latest version : V3.1 », compte chapitres 16→17 / parties 6→7, ligne « What's new in V3.1 ».
- `en/claude-code-handbook-v3.epub` / `fr/le-code-du-claudeur-v3.epub` — *rebuild* — via `node prepare-for-epub.js` + pandoc (bash, contourne le bug PS).

**Ne JAMAIS committer** : `*-rendered.html`.

## Dependencies between files

1. Ch.16 écrit **EN puis FR** + entrées TOC des deux côtés (jamais un seul côté) — commit contenu.
2. Bump version + CHANGELOG + ROADMAP + README **avant** rebuild EPUB.
3. Rebuild EPUB **avant** tag/Release.
4. Tag `v3.1.0` + Release (EPUB attachés) + PR `v3.1-draft` → main **après** que tout soit en place.

## Known risks

- **R1 — Dérive bilingue.** *Mitigation* : authoring EN+FR par paire, parité (h2/pre/aside/article comptés) avant commit ; aucun commit un seul côté.
- **R2 — Exactitude technique (plugins + /loop + Routines).** *Mitigation* : la spec plugin/marketplace/userConfig/hooks est déjà vérifiée à la source cette session (réutilisable) ; **`/loop` et Routines à vérifier à la source au moment de rédiger la section** (pas de mémoire). Citer/aligner sur la doc.
- **R3 — Renumérotation.** *Mitigation* : append (Part VII + Ch.16), zéro renvoi/ancre cassés.
- **R4 — Build EPUB / artefacts.** *Mitigation* : tooling confirmé dispo (Node 22, Pandoc 3.9) ; build en bash ; ne jamais stager `*-rendered.html` ; vérifier `git status`.
- **R5 — Fil rouge auto-promotionnel.** Le kit-methode comme exemple ne doit pas virer pub. *Mitigation* : l'utiliser comme **exemple pédagogique concret** (packaging d'un .claude/ → plugin), pas comme produit à vendre ; rester sur les concepts.
- **R6 — Gate de clôture.** *Mitigation* : pre-release checklist CLAUDE.md — 2 EPUB rebuildés **après** le bump de cover (donc **la cover EPUB doit afficher « Version 3.1 »** — cover ≠ tag ≠ README sont 3 surfaces séparées), EN/FR sync, CHANGELOG V3.1 daté, tag = CHANGELOG = README = cover, Release Latest + 2 EPUB.
- Auth/données/types : **N/A** (contenu).

## User checkpoint (✋)

1. **Placement** : nouvelle **Part VII « Packaging & distribution »**, Ch.16 ADVANCED, append sans renumérotation. OK / autre nom de Part ?
2. **Étendue** : chapitre plugins + **une section** `/loop` & Routines (vérifiés source), pas un chapitre par feature. OK ?
3. **Fil rouge** : le kit-methode comme exemple pédagogique (pas pub). OK ?
4. **Versioning** : V3.1, cover « Version 3.1 », tag `v3.1.0`, noms EPUB inchangés (`-v3.epub`, rebuildés). OK ?
5. **Cadence** : commit contenu (EN+FR) puis commit release ; PR `v3.1-draft` → main puis tag/Release. OK ?
