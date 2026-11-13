---
name: k-ship
description: Verify the current branch and open a pull request for it. Use when the user says /k-ship or the implementation of an issue is finished.
---

# /k-ship — verify and open a pull request

> **Project settings first:** if the project's `AGENTS.md` has `## Skill settings` → `### /k-ship`, read it and apply it on top of this skill. Settings add steps or tighten rules; they never loosen the kit's Safety rules.

Never run on the base branch. Never merge. Never bump versions (that is `/k-release`).
`<base>` below is the project's `Base branch:` from its `AGENTS.md` (default `main`).

1. **Verify** — run the project's commands from its `AGENTS.md` → Commands, in this order, and fix until all pass:
   lint → typecheck/build → tests (plus any "run when you change X" checks the project lists for the files you touched).
   If a failure is unrelated to your change, do not fix it silently: note it in the PR and open an issue.
2. **Self-check the diff**: `git diff origin/<base>...HEAD --stat`, then skim the diff.
   - Nothing outside the issue's scope, no debug code, no secrets, no stray files (logs, screenshots, scratch).
   - Each "Done when" point is met — list how.
3. **Required extra checks.** Read the project's `## Skill settings`: if they require `/k-security` or `/k-design-check` for the paths this change touches (or the change touches sign-in, permissions, payments, user data, AI calls, or UI), run that skill now and fix its "must fix" findings — or tell the user it is still to do and say so in the PR.
4. **Docs**: update only docs this change makes wrong (the project's `AGENTS.md` names which docs matter). Do not write change logs.
5. **Commit and push**:
   - Commits in Conventional Commit style (`feat: …`, `fix: …`).
   - `git push -u origin HEAD`
6. **Open the PR** with the repo's template (`.github/pull_request_template.md`):
   - Title: Conventional Commit, e.g. `feat(loans): what-if for extra payments`.
   - Body: `Closes #<n>`, what changed, how it was verified (commands + what to click), risks.
   - A PR for this branch already exists (`gh pr view`) → just push and add a comment saying what changed.
   - Otherwise pipe the body to `gh pr create --base <base> --title "…" --body-file -` (no temporary files inside the repo).
7. **Review.** If you can start a subagent with a fresh context (Claude Code: the `reviewer` agent), run `/k-review` on this pull request through it now. Fix its blockers, push, and have it look again (at most two rounds; still blocked → stop and report). If you cannot start one, tell the user to run `/k-review` in a new session.
8. **Checkpoint 3 of 3: report and stop.** PR link, CI status (`gh pr checks`), the review verdict, and what the owner should look at before merging (which page or command, on phone and laptop). The owner merges.
