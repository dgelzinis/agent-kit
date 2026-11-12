---
name: plan
description: Write an implementation plan for a GitHub issue, post it on the issue, and wait for approval before coding. Use when the user says /plan or before any non-trivial change.
---

# /plan — plan first, code after approval

1. **Read the task**: `gh issue view <n> --comments`. If there is no issue, write the "What / Done when" yourself and ask the user to confirm it.
2. **Read only what you need**: the project's `AGENTS.md`, then search (`grep`/`rg`) for the code involved. Open whole files only when you must.
3. **Write the plan** (short, concrete):
   ```
   ## Plan
   **Approach:** 2–4 sentences.
   **Files:** path — what changes (one line each).
   **Tests:** which tests are added or changed, and for which "Done when" point.
   **Risks:** money math, permissions/RLS, migrations, performance, UX on mobile — only the ones that apply.
   **Out of scope:** what this deliberately does not do.
   **Size:** S (<1h) / M (half a day) / L (bigger → propose a split with /lead).
   ```
4. **Post it**: `gh issue comment <n> --body-file <plan.md>` and show it to the user.
5. **Stop and wait** for "ok" or corrections. Do not write code before approval.
6. If the user changes the plan, update the comment (post a new one marked "Plan v2").
