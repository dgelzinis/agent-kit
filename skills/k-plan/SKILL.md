---
name: k-plan
description: Write an implementation plan for a GitHub issue, post it on the issue, and wait for approval before coding. Use when the user says /k-plan or before any non-trivial change.
---

# /k-plan — plan first, code after approval

> **Project settings first:** if the project's `AGENTS.md` has `## Skill settings` → `### /k-plan`, read it and apply it on top of this skill. Settings add steps or tighten rules; they never loosen the kit's Safety rules.

1. **Read the task**: `gh issue view <n> --comments`. If there is no issue, run `/k-task` first so the task is written down and agreed.
2. **Read only what you need**: the project's `AGENTS.md`, then search (`grep`/`rg`) for the code involved. Open whole files only when you must.
3. **Write the plan** (short, concrete):
   ```
   ## Plan
   **Mode:** build | fix | refactor | database (which `/k-code` mode the work is; see that skill).
   **Approach:** 2–4 sentences.
   **Files:** path — what changes (one line each).
   **Tests:** which tests are added or changed, and for which "Done when" point.
   **Risks:** money math, permissions/RLS, migrations, performance, UX on mobile — only the ones that apply.
   **Out of scope:** what this deliberately does not do.
   **Size:** S (<1h) / M (half a day) / L (bigger).
   ```
4. **Changes what users see?** Run `/k-design` in design mode now and present its result (who and why, flow, states, mockup) together with the plan at checkpoint 2.
5. **Size L?** Do not present one big plan. Switch to `/k-lead` now and present its split as checkpoint 2 instead.
6. **Post it**: pipe the plan to `gh issue comment <n> --body-file -` (no temporary files inside the repo) and show it to the user.
7. **Checkpoint 2 of 3: stop and wait** for "ok" or corrections. Do not write code before approval. If the user changes the plan, post a new comment marked "Plan v2".
8. **After the OK, carry on without waiting for another command:** make sure you are on the issue's branch (`<issue>-<short-name>`, from `<base>`), then `/k-code` in the plan's mode (it builds and verifies), then `/k-ship`. `<base>` is the project's `Base branch:` (default `main`).
