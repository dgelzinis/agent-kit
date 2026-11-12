# agent-kit

One place for how I work with coding agents (Claude Code, Codex, Gemini) across all projects.

- `AGENTS.md` — global rules, loaded by every agent in every project.
- `skills/` — the workflow, as slash commands: `/next`, `/plan`, `/ship`, `/review`, `/release`, `/lead`, `/setup-project`, plus `/debug`, `/handoff`, `/security`, `/design-check`, `/content`, `/db-change`, and `/retro` (monthly improvement).
- Project modes — each project's `AGENTS.md` starts with `Mode: product | prototype | sandbox`; the global rules relax accordingly (see `AGENTS.md` → Project mode).
- `stacks/` — stack packs: short rules per technology (supabase, react-vite, node-express, nextjs). Projects list theirs in `Stacks:`.
- `claude/agents/reviewer.md` — the reviewer as a Claude Code subagent.
- `templates/project/` — what `/setup-project` puts in a repo: project `AGENTS.md`, `CLAUDE.md`, CI, issue and PR templates (in `github/`, copied into a repo as `.github/`).
- `bin/kit` — worktree helper for parallel work.
- `install.sh` — links all of it into each tool. Run again after pulling changes.

## Install (once per computer)
```sh
cd ~/GIT/agent-kit
git init && git add -A && git commit -m "chore: agent-kit v1"   # first time only; then push to a private GitHub repo
sh install.sh
brew install gh && gh auth login                                # if not done yet
```

## The flow (same in every project and every tool)
| Step | You say / do | What happens |
|---|---|---|
| Start | `claude` or `codex`, then `/next` | Unfinished work, open PRs, top ready issues |
| Pick | "work on #12" | Branch `12-…`, issue labelled `in-progress` |
| Plan | `/plan` | Plan posted on the issue; agent waits for your OK |
| Build | "ok" | Code + tests, project checks pass |
| PR | `/ship` | Pushed, PR opened with `Closes #12`, CI runs |
| Review | new terminal, fresh session: `/review` | Blockers / should fix / nits; builder fixes blockers |
| Look | you | Click through the preview or local build, phone + laptop |
| Merge | you (`gh pr merge --squash --delete-branch`) | Deploys, issue closes |
| Release | `/release`, when you choose | Release PR → tag → GitHub release with notes |

Along the way: `/debug` for bugs (failing test first), `/design-check` before shipping UI, `/content` for any text, `/security` before releases and on auth/payment/data changes, `/handoff` when you stop mid-task.

## Parallel work (optional)
`/lead #12` splits a big issue into sub-issues that don't touch the same files, then tells you to run
`kit work <sub-issue>` and start `claude`/`codex` in each worktree. Ask the lead `/lead status` any time.
Keep it to 2–3 workers; you are the one reviewing and merging.

## Measuring and improving
- `kit stats` (this repo) or `kit stats --all` (every product/prototype project): merged PRs, hours to merge, PR size, review blockers, CI failures, bugs, lessons, security findings.
- Agents label issues `lesson` when a bug teaches something general, and open `friction` issues here when a kit rule or skill gets in the way.
- Once a month, in this folder: start an agent and run `/retro`. It measures, finds patterns, and opens a PR with at most 3 kit changes plus a `retro` issue with next month's targets. You approve.
- One-time setup of this repo's labels: `gh label create friction --color FBCA04 && gh label create retro --color 1D76DB`.

## Changing the kit
Edit a skill or `AGENTS.md`, commit, done — every project picks it up in its next session (they are links).
New skill: add `skills/<name>/SKILL.md`, list it in `AGENTS.md`, run `sh install.sh`.
