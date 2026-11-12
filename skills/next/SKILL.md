---
name: next
description: Start of a session. Shows where things stand (branch, uncommitted work, open PRs, ready issues) and suggests what to work on next. Use when the user says /next, "what's next", or starts a session without a task.
---

# /next — where are we, what's next

Keep this cheap: use `git` and `gh`, do not read docs or large files.

1. **Local state**
   - `git status --short` and `git branch --show-current`
   - If on a branch other than `main`: `git log main..HEAD --oneline` (work in progress). If the branch name starts with an issue number, read that issue's latest `## Handoff` comment (`gh issue view <n> --comments`) and lead the report with its **Next** step.
2. **Open pull requests**: `gh pr list --author @me --json number,title,headRefName,statusCheckRollup,reviewDecision`
   - Note any with failing checks or waiting for merge.
3. **Issues**: `gh issue list --state open --limit 30 --json number,title,labels,body`
   - **Ready** = no `in-progress` label and every "Depends on #N" in the body is closed (`gh issue view N --json state`).
   - **Blocked** = has an unmerged dependency.
4. **Report** (max ~15 lines):
   - Unfinished work (current branch, uncommitted files, PRs needing attention) — always first.
   - Top 3 ready issues, with a one-line reason each (priority labels first, then bugs, then oldest).
   - Anything blocked.
5. Ask which one to take. When the user picks an issue:
   - `git switch main && git pull`
   - `git switch -c <number>-<short-kebab-name>`
   - `gh issue edit <number> --add-label in-progress`
   - Then continue with `/plan`.
