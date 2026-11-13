# agent-kit

One place for how I work with coding agents (Claude Code, Codex, Gemini CLI) across all my projects: the rules, the workflow as skills, per-technology knowledge, and the checks that enforce it.

Write it once here; every project and every tool picks it up. Deeper detail for each section is in **[docs/GUIDE.md](docs/GUIDE.md)**.

## Contents

1. [How it works](#how-it-works)
2. [Quick start](#quick-start)
3. [Cheat sheet: which skill when](#cheat-sheet-which-skill-when)
4. [The daily flow](#the-daily-flow)
5. [Using it in each tool](#using-it-in-each-tool)
6. [Making a project different](#making-a-project-different)
7. [What is enforced](#what-is-enforced)
8. [Parallel work with several agents](#parallel-work-with-several-agents)
9. [Lessons, measuring and improving](#lessons-measuring-and-improving)
10. [Changing the kit](#changing-the-kit)
11. [What's in this folder](#whats-in-this-folder)
12. [Troubleshooting](#troubleshooting)

## How it works

Three layers. Each adds to the one above and wins where they disagree.

| Layer | Where | Holds |
|---|---|---|
| **Kit** | `AGENTS.md`, `skills/` (this folder) | How I work: issue → plan → branch → pull request → review; safety rules; the skills |
| **Stack packs** | `stacks/` (this folder) | Rules and traps per technology: Supabase, React/Vite, Node/Express, Next.js |
| **Project** | `<project>/AGENTS.md` | That project's facts: mode, stacks, commands, architecture, rules, skill settings, release steps |

The kit is **linked** into each tool, not copied. `install.sh` creates the links, so an edit here is live in every project's next agent session.

## Quick start

**On a computer (once):**
```sh
git clone https://github.com/dgelzinis/agent-kit.git ~/GIT/agent-kit   # skip where the folder already exists
cd ~/GIT/agent-kit && sh install.sh
brew install gh && gh auth login                                        # if not done yet
kit help                                                                # check: lists the skills
```
`install.sh` links the rules and skills into Claude Code, Codex and Gemini CLI, adds Claude Code permissions (block reading secrets, allow reading the kit), and installs the `kit` command. It backs up anything it replaces to `~/.agent-kit-backup/` and is safe to run again.

**In a project (once per project):** start an agent in the project and run `/ka-setup-project`. It detects the stack, suggests a mode, writes a short project `AGENTS.md`, adds CI and templates, asks a few questions for the skill settings, installs the pre-commit hook, and opens a pull request for you to review.

## Cheat sheet: which skill when

Two prefixes: **`k-` for doing work, `ka-` for administering the kit and a project's setup.** To look them up: type `/k-` (or `/ka-`) in Claude Code, run `kit help` in a terminal, or ask the agent "what can the kit do?"

**Work (`k-`), in any project:**

| When you… | Use |
|---|---|
| start a session, or don't know what's next | `/k-next` |
| have an idea, a complaint or a request and want it written as a clear task | `/k-task` |
| picked an issue and want a plan before code | `/k-plan` |
| finished building and want a pull request | `/k-ship` |
| want an independent check of a pull request (fresh session) | `/k-review` |
| found a bug | `/k-debug` |
| want to clean up or restructure code without changing what it does | `/k-refactor` |
| need a table, column or data fix | `/k-db-change` |
| changed how something looks | `/k-design-check` |
| need text: headlines, buttons, emails, posts | `/k-content` |
| touched sign-in, payments, user data or AI, or are about to release | `/k-security` |
| stop for the day or mid-task | `/k-handoff` |
| want a new version out | `/k-release` |
| have a feature too big for one agent | `/k-lead` |

**Admin (`ka-`), only when you decide to:**

| When you… | Use | Where |
|---|---|---|
| open a project that isn't on the kit yet | `/ka-setup-project` | in that project |
| want this project stricter, softer or different | `/ka-tune` | in that project |
| want to improve the kit itself (monthly) | `/ka-retro` | only inside `~/GIT/agent-kit` (not listed elsewhere) |

Terminal helper: `kit help` · `kit work <issue>` · `kit done <issue>` · `kit list` · `kit hooks` · `kit stats [--all] [--days N]`

The prefixes are deliberate: plain `/review`, `/plan`, `/debug` and `/security-review` are built into Claude Code or Codex and do something else.

## The daily flow

You start a task and decide at **three checkpoints**. The agent does everything in between by itself; you don't type the next skill.

| | What happens | What you do |
|---|---|---|
| Start | `/k-next` shows where things stand. For a new idea: `/k-task <your idea in your own words>` | Pick an issue, or describe the idea |
| **Checkpoint 1: task** | The agent shows the written task: what, why, "done when", out of scope | "ok", or correct it |
| | It creates the issue and a branch, and writes a plan | — |
| **Checkpoint 2: plan** | The agent shows the plan. If the task is large it shows a split into parts instead, and asks whether to run the workers automatically | "ok", or correct it |
| | It builds, tests, runs the checks the project requires, opens a pull request, has a fresh reviewer agent check it, and fixes the blockers | — |
| **Checkpoint 3: result** | The agent reports: pull request, checks, review verdict, what to look at | Look at it on phone and laptop, then merge |

Each checkpoint starts with a line like `Checkpoint 2 of 3: plan for #42` and ends with what you can answer.

- **It also stops** whenever something is unclear, a safety rule blocks it, it would have to change something outside the task, or a check keeps failing.
- **More control:** say "step by step" and it waits for you before every skill. To make that the rule for a project, set `Control: step by step` with `/ka-tune`.
- **In Codex and Gemini CLI** the review at the end is not automatic: the agent asks you to run `/k-review` in a new session.
- **Stopping mid-task:** `/k-handoff` saves where things stand on the issue; tomorrow's `/k-next` picks it up.
- **Releases** are separate: `/k-release`, only when you ask.
- **Base branch:** issue branches start from, and pull requests go to, `main`. A project whose real work is on a long-lived branch says so in its `AGENTS.md` (`Base branch: redesign`), and every skill and `kit work` follow it.

You can still call any skill directly (`/k-plan`, `/k-ship`, `/k-review`, `/k-debug`, …) when you want one step only.

Work lives in GitHub Issues. Agents never merge and never release on their own.

## Using it in each tool

| Tool | Call a skill | Check it is loaded |
|---|---|---|
| Claude Code | `/k-next` | type `/k-` or `/ka-` |
| Codex | `$k-next`, or pick from `/skills` | `/skills` |
| Gemini CLI | "activate the k-next skill" (it asks permission) | `/skills list` |
| Anything else | "read `~/GIT/agent-kit/skills/k-next/SKILL.md` and follow it" | n/a |

The skills are plain Markdown in the open `SKILL.md` format and the rules are a plain `AGENTS.md`, so nothing is tied to one vendor. Claude-only extras: the reviewer subagent (`claude/agents/reviewer.md`) and the rules that block reading secret files. Projects contain a `CLAUDE.md` with one line, `@AGENTS.md`, because Claude Code does not read `AGENTS.md` by itself.

## Making a project different

Skills are the same everywhere; the project decides how they behave. Three dials, all in the project's `AGENTS.md`:

1. **Mode** (first line): `Mode: product | prototype | sandbox`. Product = full process. Prototype = branches, lighter planning and review. Sandbox = safety rules only. No mode means product.
2. **Stacks**: `Stacks: react-vite, node-express, supabase`. Agents read only those packs from `stacks/`.
3. **Skill settings**: one short block per skill that needs something different.

```markdown
## Skill settings

### /k-security
Level: strict. Run on every pull request touching the backend, database or AI calls.

### /k-content
Voice: docs/brand/voice.md. Calm, plain, never hype.
```

Every skill reads its block first. Settings add steps or tighten rules; they never loosen the safety rules. Create or change them with `/ka-tune` (it asks a few questions and writes the section after your OK). Never copy a kit skill into a project to change it; for a truly different process, write a project skill with a new name in `<project>/.agents/skills/`.

## What is enforced

| Check | Where | What it does |
|---|---|---|
| Pre-commit hook | each repo: `kit hooks` (once per clone) | Blocks commits on `main` in product and prototype projects, and commits with `.env` files, key files, anything under `private/`, or lines that look like live keys |
| Claude Code deny rules | `~/.claude/settings.json` (from `install.sh`) | Claude cannot read `.env`, `private/` or key files |
| CI | each repo's `.github/workflows` | Lint, build and tests on every pull request |
| Dependabot | each product repo | Pull requests for security updates |
| Branch protection | GitHub → Settings → Rules | `main` accepts only pull requests with green checks |

Bypass the hook only when you mean it: `KIT_ALLOW_MAIN=1 git commit …` or `KIT_ALLOW_SECRET=1 git commit …`. A test fixture that must contain a key-shaped string gets the comment `kit:allow-secret` on that line. Agents are told never to bypass it without your OK.

## Parallel work with several agents

Large tasks get a lead automatically: when a plan comes out as size L, the agent switches to `/k-lead` and shows you a split into 2–4 parts that do not touch the same files (you can also call `/k-lead #12` yourself). With the split it asks one question: run the workers automatically, or will you drive them?

- **Automatic** (Claude Code): the lead starts up to 3 workers, each in its own copy of the code. Each plans, builds, tests and opens a pull request; a fresh reviewer checks each one. The lead reports all of them at checkpoint 3. Parts that depend on another part wait until you have merged it and said "continue".
- **You drive** (any tool): the lead tells you to run `kit work <sub-issue>` and start an agent in each new folder. `/k-lead status` shows who is done, blocked or in conflict.

The lead never writes product code and never merges. It suggests driving it yourself for payments, sign-in, permissions and database changes. Automatic saves your time, not tokens: three workers cost about three times as much.

## Lessons, measuring and improving

- **Lessons:** when a bug teaches something general, the agent records symptom → cause → fix → prevention on the issue and labels it `lesson`. Where it ends up: project code → a test or lint rule; a technology → its stack pack; how agents work → this kit.
- **Friction:** when a kit rule or skill gets in the way, or you correct an agent on how to work, it opens an issue in this repo labelled `friction`.
- **Numbers:** `kit stats` (current repo) or `kit stats --all` (every product and prototype project): merged pull requests, hours to merge, size, review blockers, CI failures, bugs, lessons, security findings.
- **Monthly:** start an agent in this folder and run `/ka-retro`. It measures, reads lessons and friction, checks whether last month's changes helped, and opens a pull request with at most 3 changes plus a `retro` issue with next month's targets. You approve. It never loosens the safety rules.

## Changing the kit

| You change… | What to do |
|---|---|
| A skill, a stack pack or `AGENTS.md` | Save, commit, push. Live in every project's next session. |
| Add or rename a skill | Work skill → `skills/k-<name>/`; project admin → `skills/ka-<name>/`; kit-only → `admin/ka-<name>/`. List it in `AGENTS.md` → Skills and run `sh install.sh` once (here, not per project). |
| Templates in `templates/project/` | Nothing for new projects. Existing projects keep their copies; `/ka-setup-project` can update one. |

**Size limit: at most 15 work skills (`k-`) and 5 admin skills (`ka-`).** At the limit, a new skill replaces or merges with an existing one. `kit help` shows the current count and `install.sh` warns when the limit is passed. Each skill stays well under 80 lines; stack packs under 40 lines. Undo a change with `git revert <commit>`.

When Claude edits the kit from a cloud session it cannot overwrite `AGENTS.md` (it is Claude's live rules file) and saves `AGENTS.new.md` instead; apply it with `mv AGENTS.new.md AGENTS.md`.

## What's in this folder

| Path | What it is |
|---|---|
| `AGENTS.md` | Global rules for every agent in every project |
| `skills/k-*/SKILL.md` | The 14 work skills, linked into every tool |
| `skills/ka-*/SKILL.md` | The 2 project admin skills (`ka-setup-project`, `ka-tune`), linked into every tool |
| `admin/ka-*/SKILL.md` | Kit-only admin skills (`ka-retro`); `install.sh` links them into this repo's own `.claude/skills` and `.agents/skills`, so they appear only when you work here |
| `stacks/` | Stack packs: `supabase`, `react-vite`, `node-express`, `nextjs` |
| `claude/agents/reviewer.md` | The reviewer as a Claude Code subagent |
| `hooks/pre-commit` | The pre-commit check installed by `kit hooks` |
| `bin/kit`, `bin/kit-stats.mjs` | The `kit` terminal helper |
| `templates/project/` | What `/ka-setup-project` puts in a repo: `AGENTS.md`, `CLAUDE.md`, and `github/` (copied in as `.github/`: CI, issue and pull request templates, Dependabot) |
| `install.sh` | Links everything into each tool |
| `docs/GUIDE.md` | The full guide |

## Troubleshooting

| Problem | Fix |
|---|---|
| A skill is not listed in the tool | Run `sh install.sh`, then start a **new** session. Gemini CLI: `gemini skills link ~/GIT/agent-kit/skills`. |
| `/review` or `/plan` did something unexpected | Those are the tool's built-ins. Kit skills are `/k-review`, `/k-plan`. |
| `kit: command not found` | Add `export PATH="$HOME/.local/bin:$PATH"` to `~/.zshrc`, open a new terminal. |
| Commit blocked on `main` | Intended. `git switch -c <issue>-<name>` and commit there. |
| Commit blocked for a secret that is not one | `KIT_ALLOW_SECRET=1 git commit …`, or mark the line `kit:allow-secret`. |
| `gh` errors about login or scope | `gh auth login`; for workflow files `gh auth refresh -s workflow`. |
| A rule changed but the agent ignores it | Running sessions keep what they loaded. Start a new one. |
| Want the old global files back | They are in `~/.agent-kit-backup/<time>/`. |
