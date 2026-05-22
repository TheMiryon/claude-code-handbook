# Section Definitions

Categories of Conventional Commits rules. References are grouped automatically by file prefix.

---

## 1. Message format (`format-`)
**Impact:** HIGH
**Description:** The shape of a single commit message. Type prefix, optional scope, imperative description, optional body and footer.

## 2. Breaking changes (`breaking-`)
**Impact:** HIGH
**Description:** How to signal a backwards-incompatible change so that downstream tooling (semver bump, changelog "BREAKING CHANGES" section) reacts correctly.

## 3. Tooling integration (`tooling-`), future
**Impact:** MEDIUM
**Description:** Patterns for integrating commit conventions with `commitlint`, `husky`, CI release pipelines, and semantic-release. Empty for now.
