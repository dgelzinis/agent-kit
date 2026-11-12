---
name: ship
description: Verify the current branch and open a pull request for it. Use when the user says /ship or the implementation of an issue is finished.
---

# /ship — verify and open a pull request

Never run on `main`. Never merge. Never bump versions (that is `/release`).

1. **Verify** — run the project's commands from its `AGENTS.md` → Commands, in this order, and fix until all pass:
   lint → typecheck/build → tests (plus any "run when you change X" checks the project lists for the files you touched).
   If a failure is unrelated to your change, do not fix it silently: note it in the PR and open an issue.
2. **Self-check the diff**: `git diff main...HEAD --stat`, then skim the diff.
   - Nothing outside the issue's scope, no debug code, no secrets, no stray files (logs, screenshots, scratch).
   - Each "Done when" point is met — list how.
3. **Docs**: update only docs this change makes wrong (the project's `AGENTS.md` names which docs matter). Do not write change logs.
4. **Commit and push**:
   - Commits in Conventional Commit style (`feat: …`, `fix: …`).
   - `git push -u origin HEAD`
5. **Open the PR** with the repo's template (`.github/pull_request_template.md`):
   - Title: Conventional Commit, e.g. `feat(loans): what-if for extra payments`.
   - Body: `Closes #<n>`, what changed, how it was verified (commands + what to click), risks.
   - `gh pr create --title "…" --body-file <body.md>`
6. **Report**: PR link, CI status (`gh pr checks`), and remind the user to run `/review` in a fresh session.
