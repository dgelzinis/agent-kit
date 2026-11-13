# Knowledge packs

Short, opinionated notes agents read before working in an area: the industry standard for it, named with its source, and the rules and traps that matter in practice. One pack per technology or problem, at most about 40 lines, only what an agent would get wrong without being told.

Every pack starts with a **Standards** line naming the authoritative sources. Tools change: for exact syntax and version-specific behaviour, check the current official docs rather than memory.

## Which packs to read

| You are working on… | Read |
|---|---|
| any code | `code.md` (always) |
| a screen, a page, anything users see | `ux.md` (always for UI) |
| tests, or any change that needs them | `testing.md` |
| sign-in, permissions, user data, secrets, input handling | `security.md` |
| a backend route or endpoint | `api.md`, plus the backend's technology pack |
| payments, subscriptions, plans | `payments-stripe.md` |
| a feature that calls an AI model | `ai-llm.md` |
| React / Vite frontend | `react-vite.md` |
| Node / Express backend | `node-express.md` |
| Supabase / PostgreSQL | `supabase.md` |
| a Next.js site | `nextjs.md` |

Technology packs are listed per project in its `AGENTS.md` (`Stacks: react-vite, node-express, supabase`). Problem packs (`code`, `ux`, `testing`, `security`, `api`, `payments-stripe`, `ai-llm`) are chosen by what the change touches. Read only the packs you need.

## Keeping them good
- A project lesson that applies to the technology or problem, not just that project, goes into its pack.
- A technology or recurring problem with no pack: draft one from the official docs (same format: Standards line, then rules) and propose it as a pull request to the kit. `/ka-project setup` notes missing packs.
- `/ka-retro` checks one or two packs each month against the current official docs and proposes corrections.
