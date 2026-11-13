---
name: k-lead
description: Orchestrate a large task across several agents working in parallel. Splits it into sub-issues with dependencies, runs or coordinates the workers, has each pull request reviewed, tracks status and conflicts. Never writes product code and never merges. Use when the user says /k-lead, or by yourself when a plan comes out size L.
---

# /k-lead — orchestrate parallel work

> **Project settings first:** if the project's `AGENTS.md` has `## Skill settings` → `### /k-lead` or `### Flow`, read it and apply it on top of this skill. Settings add steps or tighten rules; they never loosen the kit's Safety rules.

You are the lead. You split, start or coordinate workers, track and warn. Workers build. The owner approves the split and merges.
Never edit product code yourself. Never merge. At most 3 workers at a time. `<base>` is the project's `Base branch:` (default `main`).

## 1. Split (checkpoint 2 of 3)
1. Read the issue (`gh issue view <n> --comments`), the project's `AGENTS.md`, and only the code needed to see boundaries.
2. Propose 2–4 sub-issues that **do not edit the same files**. Typical split: data/API · UI · tests/demo data. For each: title `[#<n>] <part>`, "What", "Done when", **"Files/areas it may touch"**, **"Depends on #…"** (if any). Say which can run at the same time and which wait.
3. Show the split and ask one question: **"Run the workers automatically, or will you drive them yourself?"** Suggest *yourself* when a part touches payments, sign-in, permissions or a database migration, or when your tool cannot start subagents. Skill settings (`### Flow` → `Large tasks:`) may already answer it.
4. Wait for the OK. Then create the sub-issues (`gh issue create … --label sub-issue`, body piped with `--body-file -`) and add a checklist of them to the parent issue.

## 2a. Automatic (needs a tool that can start subagents in separate worktrees, e.g. Claude Code)
1. **Start a wave:** for each sub-issue with no unmerged dependency (max 3), start a worker subagent in its own worktree, on branch `<sub-issue>-<short-name>` from `origin/<base>`, with this brief:
   - the sub-issue number, and to read it and the project's `AGENTS.md`;
   - run the project's install command first (a fresh worktree has no packages; it has no `.env` either: if the work cannot be verified without one, stop and report);
   - `/k-plan` (post the plan on the sub-issue; proceed without waiting if it stays inside the sub-issue's "Done when" and "may touch" list, otherwise stop and report), build, verify, `/k-ship` up to the opened pull request;
   - stay inside "Files/areas it may touch"; anything outside → stop and report, do not edit.
2. **When a worker returns:** check that its pull request exists and targets `<base>`, that CI passes (`gh pr checks`), and that its plan and diff stayed in scope (`gh pr diff <pr> --name-only`).
3. **Review:** start a reviewer subagent with a fresh context on each pull request (`/k-review <pr>`). Blockers → send a worker back to fix them in the same worktree. At most two rounds; still blocked → stop and report.
4. **Conflicts:** two open pull requests touch the same file → say which to merge first; the other is rebased after that merge.
5. **Checkpoint 3 of 3: report and stop.** A table: sub-issue · pull request · CI · review verdict · what the owner should look at. Then the order to merge in, and what is still waiting for those merges.
6. **Next wave:** when the owner says "continue" after merging, start the sub-issues that are now unblocked (step 1). All sub-issues closed → propose closing the parent issue and clean up the worktrees.
7. A worker that fails twice, needs something outside its scope, or cannot verify its work → stop, report what happened, and ask.

## 2b. Manual (any tool)
For each sub-issue that is ready now, tell the owner how to start a worker:
```
kit work <sub-issue>                  # creates ../<repo>-<sub-issue>, a worktree and branch from <base>
cd ../<repo>-<sub-issue> && claude    # or: codex
# in the worker: "work on #<sub-issue>: /k-plan"
```
A new worktree has no installed packages and no `.env`: the worker runs the project's install command first; the owner copies any `.env` it needs.

## /k-lead status (either mode)
For the parent issue, check each sub-issue: issue state, label, its pull request (branches are named `<sub-issue>-…`: `gh pr list --state all --json number,state,headRefName` and match the prefix), CI (`gh pr checks <pr>`).
Report as a table: sub-issue · worker state · pull request · CI · next action. Then:
- **Unblocked:** dependency merged → say which can start now (automatic mode: offer to start it).
- **Conflicts:** two open pull requests touch the same file → say which to merge first and which must rebase.
- **Stuck:** a worker needs shared changes → propose how, ask the owner.
- **Done:** all sub-issues closed → propose closing the parent; clean up worktrees (`kit done <n>` for manual ones).
