---
name: lead
description: Orchestrate a large issue across several agents working in parallel. Splits it into sub-issues with dependencies, sets up worktrees, tracks status, flags conflicts. Never writes product code and never merges. Use when the user says /lead or a plan is size L.
---

# /lead — orchestrate parallel work

You are the lead. You split, track and warn. Workers build. The user decides and merges.
Never edit product code. Never merge. Keep at most 3 workers active.

## /lead #<n> — split
1. Read the issue and its approved plan (`gh issue view <n> --comments`), the project's `AGENTS.md`, and only the code needed to see boundaries.
2. Propose sub-issues that **do not edit the same files**. Typical split: data/API · UI · tests/demo data. For each:
   - Title `[#<n>] <part>`, "What", "Done when", **"Files/areas it may touch"**, **"Depends on #…"** (if any).
3. Show the split; wait for the user's OK.
4. Create them: `gh issue create --title … --body-file … --label sub-issue`, then add a checklist of the sub-issues to the parent (`gh issue comment <n>`).
5. For each sub-issue that is ready now, tell the user how to start a worker:
   ```
   kit work <sub-issue>        # creates ../<repo>-<sub-issue> worktree + branch
   cd ../<repo>-<sub-issue> && claude   # or: codex
   # in the worker: "work on #<sub-issue>: /plan"
   ```

## /lead status — track
For the parent issue, check each sub-issue: issue state, label, PR (`gh pr list --search "<sub-issue> in:body"`), CI (`gh pr checks`).
Report as a table: sub-issue · worker state · PR · CI · next action. Then:
- **Unblocked**: dependency merged → say which worker can start now.
- **Conflicts**: two open PRs touch the same file (`gh pr diff <pr> --name-only`) → say which to merge first and which must rebase.
- **Stuck**: a worker commented that it needs shared changes → propose how, ask the user.
- **Done**: all sub-issues closed → propose closing the parent; remind to clean worktrees (`kit done <n>`).
