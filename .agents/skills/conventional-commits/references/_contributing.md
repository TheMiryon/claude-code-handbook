# Writing guidelines for new rules

How to add a new rule to this skill without breaking the convention.

## Principles

### 1. One rule, one file

If a "rule" needs more than two pages of explanation, it's actually two rules. Split.

### 2. Incorrect comes before Correct

Always. The reader trains pattern-recognition by seeing the trap first.

```markdown
**Incorrect (the trap):**

[bad example]

**Correct:**

[good example]
```

### 3. Concrete examples only

No "imagine a commit that…", write a real message. Even if it's invented, make it look like something somebody would actually type.

### 4. Frontmatter is required

Every rule has:

```yaml
---
title: Clear action-oriented title
impact: HIGH | MEDIUM | LOW
impactDescription: One sentence on what breaks if this is ignored
tags: comma, separated, tags
---
```

Without the frontmatter, agents can't prioritize.

### 5. Edge cases listed explicitly

Don't make the reader guess. Merge commits, reverts, breaking changes, multi-scope commits, each gets a bullet in the "Edge cases" section.

## Checklist before submitting

- [ ] Title is action-oriented (verb, not noun)
- [ ] Frontmatter complete (title + impact + impactDescription + tags)
- [ ] At least one Incorrect example
- [ ] At least one Correct example
- [ ] Both examples use realistic message text
- [ ] Edge cases listed (or explicitly noted "no edge cases apply")
- [ ] Tools-that-enforce-this section, even if empty
- [ ] Reference link to canonical source
