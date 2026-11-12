---
name: review
description: Independent code review of the current branch or a pull request against main. Run it in a fresh session that did not write the code. Use when the user says /review or a PR is ready.
---

# /review — independent review

You did not write this code. Judge it only by the issue, the diff and the project's rules.
Do not read memory/ledger/roadmap files. Do not edit files.

1. **Gather**
   - PR: `gh pr view --json number,title,body,files` (or the PR number given). Linked issue: `gh issue view <n>`.
   - Diff: `git fetch origin main && git diff origin/main...HEAD`
   - Project rules: the project's `AGENTS.md` (Rules and Architecture sections).
   - Open other files only to understand a changed line.
2. **Check**
   - **Does it do the task?** Every "Done when" point met; nothing out of scope.
   - **Correctness**: edge cases, null/empty data, error handling, off-by-one, time zones, currency and rounding.
   - **Security**: authorization and data access (e.g. RLS, ownership checks), input validation, secrets, injection (SQL/XSS), safe redirects.
   - **Data**: migrations numbered, reversible or safe on existing data; no destructive change without a plan.
   - **Project rules**: anything the project's `AGENTS.md` forbids (e.g. duplicated calculations, wrong component library).
   - **Tests**: new logic tested; tests actually assert behaviour.
   - **UX**: loading/empty/error states, mobile layout, copy.
   - **Simplicity**: dead code, duplication, needless complexity.
3. **Output** — only real findings, each with `file:line`, why it matters, and a suggested fix:
   ```
   ## Review: <PR title>
   Verdict: BLOCKED | OK WITH FIXES | OK
   ### Blockers (must fix before merge)
   ### Should fix
   ### Nits (optional)
   ```
   No findings in a section → write "None". Do not pad.
4. If the user agrees, post it: `gh pr review <n> --comment --body-file <review.md>`.
