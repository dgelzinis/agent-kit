---
name: k-next
description: Start of a session. Shows where things stand (branch, uncommitted work, open PRs, ready issues) and suggests what to work on next. Use when the user says /k-next, "what's next", or starts a session without a task.
---

# /k-next — where are we, what's next

> **Project settings first:** if the project's `AGENTS.md` has `## Skill settings` → `### /k-next`, read it and apply it on top of this skill. Settings add steps or tighten rules; they never loosen the kit's Safety rules.

Keep this cheap: use `git` and `gh`, do not read docs or large files.
`<base>` is the project's `Base branch:` from its `AGENTS.md` (default `main`).

1. **Local state**
   - `git status --short` and `git branch --show-current`
   - If on a branch other than `<base>`: `git log origin/<base>..HEAD --oneline` (work in progress). If the branch name starts with an issue number, read that issue's latest `## Handoff` comment (`gh issue view <n> --comments`) and lead the report with its **Next** step.
2. **Open pull requests**: `gh pr list --author @me --json number,title,headRefName,statusCheckRollup,reviewDecision`
   - Note any with failing checks or waiting for merge.
3. **Issues**: `gh issue list --state open --limit 30 --json number,title,labels,body`
   - No open issues: say so and offer `/k-task` to write one up from what the user wants to do (or from the project's roadmap, if it has one).
   - **Ready** = no `in-progress` label and every "Depends on #N" in the body is closed (`gh issue view N --json state`).
   - **Blocked** = has an unmerged dependency.
4. **Report** (max ~15 lines):
   - Unfinished work (current branch, uncommitted files, PRs needing attention) — always first.
   - Top 3 ready issues, with a one-line reason each (priority labels first, then bugs, then oldest).
   - Anything blocked.
5. Ask which one to take. When the user picks an issue:
   - Uncommitted changes or unpushed work on the current branch → stop and ask what to do with them first (commit, `/k-handoff`, or leave).
   - `git switch <base> && git pull`
   - `git switch -c <number>-<short-kebab-name>`
   - `gh issue edit <number> --add-label in-progress` (label missing → `gh label create in-progress --color FBCA04` first)
   - Then continue with `/k-plan`.
