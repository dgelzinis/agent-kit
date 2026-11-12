# agent-kit

One place for how I work with coding agents (Claude Code, Codex, Gemini) across all projects.

**Full guide: [docs/GUIDE.md](docs/GUIDE.md)** — layers, setup, daily flow, all commands, how changes reach projects, measuring and improving.

## Cheat sheet

Every kit skill starts with `k-`. In Claude Code type `/k-` and the picker lists them all; in Codex type `$k-<name>` or pick from `/skills`. In a terminal, `kit help` prints the list. Or ask the agent: "what can the kit do?"

| When you… | Use |
|---|---|
| start a session, or don't know what's next | `/k-next` |
| picked an issue and want a plan before code | `/k-plan` |
| finished building and want a pull request | `/k-ship` |
| want an independent check of a pull request (fresh session) | `/k-review` |
| found a bug | `/k-debug` |
| need a table, column or data fix | `/k-db-change` |
| changed how something looks | `/k-design-check` |
| need text: headlines, buttons, emails, posts | `/k-content` |
| touched sign-in, payments, user data or AI, or are about to release | `/k-security` |
| stop for the day or mid-task | `/k-handoff` |
| want a new version out | `/k-release` |
| have a feature too big for one agent | `/k-lead` |
| open a project that isn't on the kit yet | `/k-setup-project` |
| want this project stricter, softer or different | `/k-tune` |
| want to improve the kit itself (monthly) | `/k-retro` |

The names avoid the tools' own commands on purpose: plain `/review`, `/plan`, `/debug` and `/security-review` are built into Claude Code or Codex and do something else.

Other tools: the skills are plain Markdown in the open `SKILL.md` format and the rules are a plain `AGENTS.md`. Codex and Gemini CLI pick them up from `~/.agents/skills` and their global rules file (`install.sh` links both). Any other agent can use a skill by being told to read `~/GIT/agent-kit/skills/k-<name>/SKILL.md` and follow it. Claude-only extras: the reviewer subagent and the secret-file deny rules.

## What's in this folder

- `AGENTS.md` — global rules, loaded by every agent in every project.
- `skills/` — the workflow, as slash commands: `/k-next`, `/k-plan`, `/k-ship`, `/k-review`, `/k-release`, `/k-lead`, `/k-setup-project`, plus `/k-debug`, `/k-handoff`, `/k-security`, `/k-design-check`, `/k-content`, `/k-db-change`, and `/k-retro` (monthly improvement).
- Project modes — each project's `AGENTS.md` starts with `Mode: product | prototype | sandbox`; the global rules relax accordingly (see `AGENTS.md` → Project mode).
- `stacks/` — stack packs: short rules per technology (supabase, react-vite, node-express, nextjs). Projects list theirs in `Stacks:`.
- `claude/agents/reviewer.md` — the reviewer as a Claude Code subagent.
- `templates/project/` — what `/k-setup-project` puts in a repo: project `AGENTS.md`, `CLAUDE.md`, CI, issue and PR templates (in `github/`, copied into a repo as `.github/`).
- `bin/kit` — helper: worktrees for parallel work, `kit hooks`, `kit stats`.
- `hooks/pre-commit` — blocks commits on `main` and commits containing secrets; install per repo with `kit hooks`.
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
| Start | `claude` or `codex`, then `/k-next` | Unfinished work, open PRs, top ready issues |
| Pick | "work on #12" | Branch `12-…`, issue labelled `in-progress` |
| Plan | `/k-plan` | Plan posted on the issue; agent waits for your OK |
| Build | "ok" | Code + tests, project checks pass |
| PR | `/k-ship` | Pushed, PR opened with `Closes #12`, CI runs |
| Review | new terminal, fresh session: `/k-review` | Blockers / should fix / nits; builder fixes blockers |
| Look | you | Click through the preview or local build, phone + laptop |
| Merge | you (`gh pr merge --squash --delete-branch`) | Deploys, issue closes |
| Release | `/k-release`, when you choose | Release PR → tag → GitHub release with notes |

Along the way: `/k-debug` for bugs (failing test first), `/k-design-check` before shipping UI, `/k-content` for any text, `/k-security` before releases and on auth/payment/data changes, `/k-handoff` when you stop mid-task.

## Parallel work (optional)
`/k-lead #12` splits a big issue into sub-issues that don't touch the same files, then tells you to run
`kit work <sub-issue>` and start `claude`/`codex` in each worktree. Ask the lead `/k-lead status` any time.
Keep it to 2–3 workers; you are the one reviewing and merging.

## Measuring and improving
- `kit stats` (this repo) or `kit stats --all` (every product/prototype project): merged PRs, hours to merge, PR size, review blockers, CI failures, bugs, lessons, security findings.
- Agents label issues `lesson` when a bug teaches something general, and open `friction` issues here when a kit rule or skill gets in the way.
- Once a month, in this folder: start an agent and run `/k-retro`. It measures, finds patterns, and opens a PR with at most 3 kit changes plus a `retro` issue with next month's targets. You approve.
- One-time setup of this repo's labels: `gh label create friction --color FBCA04 && gh label create retro --color 1D76DB`.

## Changing the kit
The kit is linked into every tool, not copied: a change here applies in every project's next agent session. No per-project step. Only a **new** skill needs `sh install.sh` once. Details: [docs/GUIDE.md → How changes reach your projects](docs/GUIDE.md#2-how-changes-reach-your-projects).

Edit a skill or `AGENTS.md`, commit, done — every project picks it up in its next session (they are links).
New skill: add `skills/<name>/SKILL.md`, list it in `AGENTS.md`, run `sh install.sh`.
