# Project patterns, copy-paste recipes

> Different from `CLAUDE.md` (which defines **rules**), here are **recipes**.
> Different from `.claude/agents/` (audit roles), here are code templates to copy.

Keep it short, a stale pattern is worse than a missing pattern. If you find yourself doing the same thing 3+ times outside this file, **add** the pattern. If you find yourself doing things differently from what's here, **update** the file or delete the pattern.

---

## Pattern 1, <example: Server Action with auth + validation + toast>

Pattern for any server-side mutation that touches the DB. Adapt to your stack.

```ts
// path/to/feature/actions.ts
'use server'

import { createClient } from '@/lib/your-db-client'
import { redirect } from 'next/navigation'
import { z } from 'zod'

const Schema = z.object({
  title: z.string().min(1).max(200).trim(),
  // ... validated fields
})

export async function createSomething(formData: FormData) {
  // 1. Auth, always check before touching DB
  const client = await createClient()
  const { data: { user } } = await client.auth.getUser()
  if (!user) redirect('/login')

  // 2. Parse + validate (server-side, never trust client)
  const parsed = Schema.safeParse({
    title: formData.get('title'),
  })
  if (!parsed.success) {
    return { error: 'Invalid data', fieldErrors: parsed.error.flatten().fieldErrors }
  }

  // 3. Insert, scope by user_id (defense in depth even with RLS)
  const { error } = await client
    .from('table_name')
    .insert({ ...parsed.data, user_id: user.id })

  if (error) {
    console.error('createSomething error', error)
    return { error: 'Creation failed' }
  }

  // 4. Revalidate the affected route
  revalidatePath('/path/to/feature')
  return { success: true }
}
```

Client-side:
```tsx
'use client'
import { toast } from 'sonner'

const result = await createSomething(formData)
if (result?.error) toast.error(result.error)
else toast.success('Created.')
```

**Why**: uniform pattern = no missed auth, no missed validation, no silent errors, consistent UX.

---

## Pattern 2, <example: Parallel DB queries for dashboards>

When loading multiple sources in a server component, parallelize.

```ts
// ❌ Bad, serializes waits (3× the time)
const trades = await db.from('trades').select('*')
const strategies = await db.from('strategies').select('*')
const config = await db.from('user_config').select('*').single()

// ✅ Good, Promise.all parallelizes (1× the slowest)
const [tradesRes, strategiesRes, configRes] = await Promise.all([
  db.from('trades').select('*').eq('user_id', userId),
  db.from('strategies').select('*').eq('user_id', userId),
  db.from('user_config').select('*').eq('user_id', userId).single(),
])
```

**Gotcha**: if one query depends on the result of another, you CAN'T parallelize. In that case, sequential is necessary, but often that means you should denormalize.

---

## Pattern 3, <add your project-specific recipes>

Replace this template with concrete patterns from your project as they emerge.

Each pattern should have:
- **Title** + 1-line goal
- **❌ Bad example** (what NOT to do)
- **✅ Good example** (the recipe)
- **Why** (the reasoning, especially the non-obvious part)

---

## Maintenance

- **Add** a pattern only after you've done it manually 3+ times (otherwise = over-engineering)
- **Remove** a pattern as soon as it's outdated (wrong framework version, archi decision changed)
- **Don't exceed 10 patterns**, beyond that, it becomes verbose docs rather than recipes
- Update each time a project convention changes (e.g., migration from one library to another)
