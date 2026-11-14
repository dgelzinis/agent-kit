# agent-kit

One place for how I work with coding agents (Claude Code, Codex, Gemini CLI) across all my projects: the rules, the workflow as skills, per-technology knowledge, and the checks that enforce it.

Write it once here; every project and every tool picks it up. Deeper detail for each section is in **[docs/GUIDE.md](docs/GUIDE.md)**.

## Contents

1. [How it works](#how-it-works)
2. [Quick start](#quick-start)
3. [Cheat sheet: which skill when](#cheat-sheet-which-skill-when)
4. [Examples: what to type](#examples-what-to-type)
5. [The daily flow](#the-daily-flow)
6. [Using it in each tool](#using-it-in-each-tool)
7. [Making a project different](#making-a-project-different)
8. [What is enforced](#what-is-enforced)
9. [Being found: marketing, SEO and GEO](#being-found-marketing-seo-and-geo)
10. [Parallel work with several agents](#parallel-work-with-several-agents)
11. [Lessons, measuring and improving](#lessons-measuring-and-improving)
12. [Changing the kit](#changing-the-kit)
13. [What's in this folder](#whats-in-this-folder)
14. [Troubleshooting](#troubleshooting)

## How it works

Three layers. Each adds to the one above and wins where they disagree.

| Layer | Where | Holds |
|---|---|---|
| **Kit** | `AGENTS.md`, `skills/` (this folder) | How I work: issue → plan → branch → pull request → review; safety rules; the skills |
| **Knowledge packs** | `stacks/` (this folder) | The industry standard and the practical rules per technology (Supabase, React/Vite, Node/Express, Next.js) and per problem (code design, UX, testing, security, APIs, payments, AI features) |
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

**In a project (once per project):** start an agent in the project and run `/ka-project setup`. It detects the stack, suggests a mode, writes a short project `AGENTS.md`, adds CI and templates, asks a few questions for the skill settings, installs the pre-commit hook, and opens a pull request for you to review.

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
| want code written or changed: a feature (`build`), a bug (`fix`), a cleanup (`refactor`), a table or column (`database`) | `/k-code` (it picks the mode; or say `/k-code fix`) |
| want a screen designed before it is built, design options, a check of how something looks, or a design system created or changed | `/k-design` (modes: `design`, `check`, `system`) |
| need text: headlines, buttons, emails, posts | `/k-content` |
| want the product found: marketing, SEO, visibility in AI answers | `/k-marketing` (modes: `audit`, `plan`, `page`, `measure`) |
| touched sign-in, payments, user data or AI, or are about to release (the other skills also call it by themselves) | `/k-security` |
| stop for the day or mid-task | `/k-handoff` |
| want a new version out | `/k-release` |
| have a feature too big for one agent | `/k-lead` |

**Admin (`ka-`), only when you decide to:**

| When you… | Use | Where |
|---|---|---|
| open a project that isn't on the kit yet, or want a project stricter, softer or different | `/ka-project` (modes: `setup`, `tune`) | in that project |
| want to improve the kit itself (monthly) | `/ka-retro` | only inside `~/GIT/agent-kit` (not listed elsewhere) |

Terminal helper: `kit help` · `kit work <issue>` · `kit done <issue>` · `kit list` · `kit hooks` · `kit stats [--all] [--days N]`

The prefixes are deliberate: plain `/review`, `/plan`, `/debug` and `/security-review` are built into Claude Code or Codex and do something else.

## Examples: what to type

Real prompts, in your own words. The agent picks the skills and stops at the three checkpoints. Lines without a slash are plain messages to the agent.

**Start and stop a session**
```
/k-next
```
```
/k-handoff
```

**A new idea, a complaint, feedback from a user**
```
/k-task people can't see how much they still owe on the loans page
```
```
/k-task new users don't understand what to do first after signing up
```
Several at once, without starting any of them:
```
Use /k-task to write up these four items as separate tasks. Show me all the drafts together before creating the issues, then stop.
```

**Work on what is already listed**
```
work on #4
```
```
go one by one
```

**A bug**
```
/k-task the logout button sometimes leaves the previous account signed in
```
The plan names the mode (`fix`): failing test first, then the fix.

**A cleanup, with no change in behaviour**
```
/k-code refactor split the assistant service into smaller files; nothing users see may change
```

**A database change**
```
/k-task we need to store a nickname per holding
```
The plan uses `database` mode: a migration file, access rules, and exact steps for you to apply it live.

**Design and UX**

Don't know yet what to improve:
```
/k-design check the Liabilities page
```
Want to see options before anything is built:
```
/k-design options for the Liabilities page: make the remaining balance easier to see
```
Know what you want changed:
```
/k-task the loan cards feel cramped on the phone, make them easier to read
```
A whole flow:
```
/k-design check the whole first-time experience: sign up, first portfolio, first Check-in
```

**A design system**

Create one in a project that has none:
```
/k-design system create a design system based on the screens we have
```
Change the look everywhere:
```
/k-design system the cards feel heavy, lighten borders and spacing across the app
```

**Text**
```
/k-content three options for the headline on the pricing page
```

**Marketing, SEO and visibility in AI answers**

How findable is the site today, and what should be fixed first:
```
/k-marketing audit the marketing site
```
A direction: who to reach and which searches and questions to win:
```
/k-marketing plan for couples who manage money together
```
One page built to win one search:
```
/k-marketing page for "how to track net worth as a couple"
```
What is working (you provide the search console or analytics export if the agent has no access):
```
/k-marketing measure the last 30 days
```

**Security**

One change, or everything a branch adds:
```
/k-security
```
```
Run /k-security on everything redesign adds over main. Report the findings and stop. Do not fix anything yet.
```
The whole app:
```
/k-security app
```

**Review a pull request with fresh eyes**
```
/k-review 12
```

**Finishing a long-lived branch before it goes live**
```
What is still open before redesign can go live? Check the plan docs, the Open handoffs list, and anything marked untested or "not done". Give me a short list, most important first. Do not create issues yet.
```
Then turn the must-haves into tasks with `/k-task`, work through them, run `/k-security` and `/k-design check` on the whole thing, and only then:
```
Open a pull request from redesign into main. Do not merge it.
```
You merge it yourself: merging into `main` is what deploys.

**Merging, when you want the agent to do it for you**
```
I approve merging pull request #12 into redesign. First confirm that its target branch is redesign and that the CI checks are green. If either is not true, stop and tell me. Do not touch main.
```

**A feature too big for one agent**
```
/k-lead #50
```
```
/k-lead status
```
You rarely need to type the first one: a plan that comes out large switches to the lead by itself.

**A release**
```
/k-release
```

**More control, or less**
```
step by step
```
The agent then waits for you before every skill, not only at the three checkpoints.

**Set up or tune a project**
```
/ka-project setup
```
```
/ka-project tune security should be strict here, and the voice is playful and short
```

**Improve the kit itself** (monthly, inside `~/GIT/agent-kit`)
```
/ka-retro
```

**Useful one-liners at any time**
```
what can the kit do?
```
```
What could go wrong with this plan? What are you not doing?
```
```
Is this pull request set to merge into redesign, and not into main? Answer yes or no.
```

## The daily flow

You start a task and decide at **three checkpoints**. The agent does everything in between by itself; you don't type the next skill.

| | What happens | What you do |
|---|---|---|
| Start | `/k-next` shows where things stand. For a new idea: `/k-task <your idea in your own words>` | Pick an issue, or describe the idea |
| **Checkpoint 1: task** | The agent shows the written task: what, why, "done when", out of scope | "ok", or correct it |
| | It creates the issue and a branch, and writes a plan | — |
| **Checkpoint 2: plan** | The agent shows the plan. For anything users see, it includes a design with a quick mockup. If the task is large it shows a split into parts instead, and asks whether to run the workers automatically | "ok", or correct it |
| | It builds, tests, runs the checks the project requires, opens a pull request, has a fresh reviewer agent check it, and fixes the blockers | — |
| **Checkpoint 3: result** | The agent reports: pull request, checks, review verdict, what to look at | Look at it on phone and laptop, then merge |

Each checkpoint starts with a line like `Checkpoint 2 of 3: plan for #42` and ends with what you can answer.

- **It also stops** whenever something is unclear, a safety rule blocks it, it would have to change something outside the task, or a check keeps failing.
- **More control:** say "step by step" and it waits for you before every skill. To make that the rule for a project, set `Control: step by step` with `/ka-project tune`.
- **In Codex and Gemini CLI** the review at the end is not automatic: the agent asks you to run `/k-review` in a new session.
- **Stopping mid-task:** `/k-handoff` saves where things stand on the issue; tomorrow's `/k-next` picks it up.
- **Releases** are separate: `/k-release`, only when you ask.
- **Base branch:** issue branches start from, and pull requests go to, `main`. A project whose real work is on a long-lived branch says so in its `AGENTS.md` (`Base branch: redesign`), and every skill and `kit work` follow it.

You can still call any skill directly (`/k-plan`, `/k-ship`, `/k-review`, `/k-code fix`, …) when you want one step only.

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

Every skill reads its block first. Settings add steps or tighten rules; they never loosen the safety rules. Create or change them with `/ka-project tune` (it asks a few questions and writes the section after your OK). Never copy a kit skill into a project to change it; for a truly different process, write a project skill with a new name in `<project>/.agents/skills/`.

## What is enforced

| Check | Where | What it does |
|---|---|---|
| Pre-commit hook | each repo: `kit hooks` (once per clone) | Blocks commits on `main` in product and prototype projects, and commits with `.env` files, key files, anything under `private/`, or lines that look like live keys |
| Claude Code deny rules | `~/.claude/settings.json` (from `install.sh`) | Claude cannot read `.env`, `private/` or key files |
| CI | each repo's `.github/workflows` | Lint, build and tests on every pull request |
| Dependabot | each product repo | Pull requests for security updates |
| Branch protection | GitHub → Settings → Rules | `main` accepts only pull requests with green checks |

Bypass the hook only when you mean it: `KIT_ALLOW_MAIN=1 git commit …` or `KIT_ALLOW_SECRET=1 git commit …`. A test fixture that must contain a key-shaped string gets the comment `kit:allow-secret` on that line. Agents are told never to bypass it without your OK.

## Being found: marketing, SEO and GEO

`/k-marketing` is the visibility expert, in four modes: `audit` (how findable is the site today, and what to fix), `plan` (who to reach and which searches and questions to win), `page` (one page built for one search intent) and `measure` (what is working, from real data). It proposes and checks; `/k-content`, `/k-design` and `/k-code` build. It only does honest marketing, searches the web for current facts, never publishes anything itself and never promises a ranking. Its knowledge pack, `stacks/seo-geo.md`, follows the search engines' own guidance and treats `llms.txt` and "schema for AI" as unproven. Details and sources: [docs/GUIDE.md](docs/GUIDE.md#8-being-found-marketing-seo-and-geo-k-marketing).

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
| Add a mode to a skill | Add `modes/<mode>.md` in that skill's folder and a row in its `SKILL.md` table. No install step. Prefer this to a new skill when it is the same expertise at another moment. |
| Add or rename a skill | Work skill → `skills/k-<name>/`; project admin → `skills/ka-<name>/`; kit-only → `admin/ka-<name>/`. List it in `AGENTS.md` → Skills and run `sh install.sh` once (here, not per project). |
| Templates in `templates/project/` | Nothing for new projects. Existing projects keep their copies; `/ka-project setup` can update one. |

**Size limit: at most 15 work skills (`k-`) and 5 admin skills (`ka-`).** At the limit, a new skill replaces or merges with an existing one. `kit help` shows the current count and `install.sh` warns when the limit is passed. Each skill stays well under 80 lines; stack packs under 40 lines. Undo a change with `git revert <commit>`.

When Claude edits the kit from a cloud session it cannot overwrite `AGENTS.md` (it is Claude's live rules file) and saves `AGENTS.new.md` instead; apply it with `mv AGENTS.new.md AGENTS.md`.

## What's in this folder

| Path | What it is |
|---|---|
| `AGENTS.md` | Global rules for every agent in every project |
| `skills/k-*/` | The 13 work skills, linked into every tool. A skill with modes keeps each mode's steps in `modes/<mode>.md` beside its `SKILL.md` |
| `skills/ka-*/` | The project admin skill `ka-project` (modes `setup`, `tune`), linked into every tool |
| `admin/ka-*/SKILL.md` | Kit-only admin skills (`ka-retro`); `install.sh` links them into this repo's own `.claude/skills` and `.agents/skills`, so they appear only when you work here |
| `stacks/` | Knowledge packs, each naming the industry standard and its source. Technology: `supabase`, `react-vite`, `node-express`, `nextjs`. Problem: `code` and `ux` (always), `testing`, `security`, `api`, `payments-stripe`, `ai-llm`, `seo-geo`. `stacks/README.md` says which to read when |
| `claude/agents/reviewer.md` | The reviewer as a Claude Code subagent |
| `hooks/pre-commit` | The pre-commit check installed by `kit hooks` |
| `bin/kit`, `bin/kit-stats.mjs` | The `kit` terminal helper |
| `templates/project/` | What `/ka-project setup` puts in a repo: `AGENTS.md`, `CLAUDE.md`, and `github/` (copied in as `.github/`: CI, issue and pull request templates, Dependabot) |
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
