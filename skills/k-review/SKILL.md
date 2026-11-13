---
name: k-review
description: Independent code review of the current branch or a pull request against main. Run it in a fresh session that did not write the code. Use when the user says /k-review or a PR is ready.
---

# /k-review — independent review

> **Project settings first:** if the project's `AGENTS.md` has `## Skill settings` → `### /k-review`, read it and apply it on top of this skill. Settings add steps or tighten rules; they never loosen the kit's Safety rules.

You did not write this code. Judge it only by the issue, the diff and the project's rules.
Do not read memory/ledger/roadmap files. Do not edit files.

1. **Pick the pull request.** A number was given → that one. Otherwise `gh pr view --json number` for the current branch. If the current branch has no PR: `gh pr list --state open --json number,title,headRefName` → exactly one open PR: use it; several: ask which. Never review "whatever is checked out" by guessing. No PR at all → review the current branch against the project's base branch and say so.
2. **Gather** (no checkout needed)
   - PR: `gh pr view <n> --json number,title,body,files,headRefName`. Linked issue: `gh issue view <issue>`.
   - Diff: `gh pr diff <n>` (branch without a PR: `git fetch origin <base> && git diff origin/<base>...HEAD`, where `<base>` is the project's `Base branch:`, default `main`).
   - To read a changed file in full: `git fetch origin <headRefName>` then `git show origin/<headRefName>:<path>`.
   - Project rules: the project's `AGENTS.md` (Rules and Architecture sections).
   - Open other files only to understand a changed line.
3. **Check**
   - **Does it do the task?** Every "Done when" point met; nothing out of scope.
   - **Correctness**: edge cases, null/empty data, error handling, off-by-one, time zones, currency and rounding.
   - **Security**: authorization and data access (e.g. RLS, ownership checks), input validation, secrets, injection (SQL/XSS), safe redirects.
   - **Data**: migrations numbered, reversible or safe on existing data; no destructive change without a plan.
   - **Project rules**: anything the project's `AGENTS.md` forbids (e.g. duplicated calculations, wrong component library).
   - **Tests** (`stacks/testing.md`): new logic tested; tests actually assert behaviour.
   - **Standards**: the change follows the knowledge packs for what it touches (`~/GIT/agent-kit/stacks/README.md` says which).
   - **UX**: loading/empty/error states, mobile layout, copy.
   - **Code design** (`~/GIT/agent-kit/stacks/code.md`): one job per function/component/module; business rules in one place and free of framework or database details; no duplicated formula or validation; no abstraction without a present need; dead code, needless complexity.
4. **Output** — only real findings, each with `file:line`, why it matters, and a suggested fix:
   ```
   ## Review: <PR title>
   Verdict: BLOCKED | OK WITH FIXES | OK
   ### Blockers (must fix before merge)
   ### Should fix
   ### Nits (optional)
   ```
   No findings in a section → write "None". Do not pad.
   The `Verdict:` line must be exactly one of `Verdict: BLOCKED`, `Verdict: OK WITH FIXES`, `Verdict: OK` — `kit stats` counts it.
5. Post it on the PR without creating a file in the repo: pipe the text to `gh pr comment <n> --body-file -` (comments are what the metrics read).
6. A blocker that reveals a pattern (not a one-off) → suggest the label `lesson` on the issue and say where the prevention belongs.
