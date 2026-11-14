# agent-kit guide

How the kit is put together, how to use it day to day, and how changes reach your projects.

## 1. What the kit is

One folder (`~/GIT/agent-kit`, backed up to a private GitHub repo) that holds how you work with coding agents. Claude Code, Codex and Gemini all read it, in every project.

There are three layers. Each one adds to the one above and wins where they disagree:

| Layer | Where | Holds |
|---|---|---|
| **Kit** | `~/GIT/agent-kit/AGENTS.md`, `skills/` | How you work: plan → branch → PR → review, safety rules, the slash commands |
| **Knowledge packs** | `~/GIT/agent-kit/stacks/` | Per technology (Supabase, React/Vite, Node/Express, Next.js) and per problem (code design, UX, testing, security, APIs, payments, AI features): the industry standard, named with its source, and the rules that matter. `stacks/README.md` says which to read when |
| **Project** | `<project>/AGENTS.md` | This project's facts: mode, stacks, commands, architecture, rules, design and voice, release steps |

Each project's `AGENTS.md` starts with:
- `Mode: product | prototype | sandbox` — how strict the process is (see `AGENTS.md` → Project mode). No mode means `product`.
- `Stacks: …` — which stack packs apply.

## 2. How changes reach your projects

The kit is **linked**, not copied. `install.sh` puts links in the places each tool reads:

| Tool | Reads |
|---|---|
| Claude Code | `~/.claude/CLAUDE.md`, `~/.claude/skills/<name>`, `~/.claude/agents/reviewer.md` |
| Codex | `~/.codex/AGENTS.md`, `~/.agents/skills/<name>` |
| Gemini CLI | `~/.gemini/GEMINI.md`, `~/.agents/skills/<name>` |

All of them point back into this folder. So:

| You change… | What to do |
|---|---|
| A skill, a stack pack, or the global `AGENTS.md` | Nothing. It applies in the next agent session, in every project. Commit and push to keep the backup. |
| **Add or rename a skill** | Run `sh install.sh` once in this folder (it creates the new links). Not per project. |
| The `kit` helper (`bin/`) | Nothing (linked to `~/.local/bin/kit`). |
| Templates (`templates/project/`) | Nothing for new projects. Existing projects keep their own copies (`AGENTS.md`, `.github/`); ask `/ka-project setup` in a project to bring it up to date if needed. |

Per-project files (`<project>/AGENTS.md`, `<project>/CLAUDE.md`, `<project>/.github/`) change only inside that project, when its facts change.

Notes:
- Start a **new** agent session after a change; a running session keeps what it loaded at start.
- When Claude edits the kit from a cloud session it cannot overwrite `AGENTS.md` (it is Claude's live global rules file). It saves `AGENTS.new.md` instead; apply it with `mv AGENTS.new.md AGENTS.md`. Editing it yourself needs no extra step.
- `install.sh` is safe to run any time. Anything it replaces is first copied to `~/.agent-kit-backup/<time>/`.

## 3. First-time setup (once per computer)

```sh
git clone https://github.com/dgelzinis/agent-kit.git ~/GIT/agent-kit   # skip on the computer where it was created
cd ~/GIT/agent-kit && sh install.sh
brew install gh && gh auth login                                        # if not done yet
```

What `install.sh` does:
1. Links the global rules into Claude Code, Codex and Gemini (backing up any existing file).
2. Links every skill into `~/.agents/skills` and `~/.claude/skills`, one link per skill, so skills you installed yourself stay.
3. Links the reviewer subagent for Claude Code.
4. Adds to `~/.claude/settings.json` (merged, never overwritten): blocks reading `.env`, `private/` and key files; allows reading this kit.
5. Installs the `kit` command to `~/.local/bin`.

Labels used by the workflow, once per repo (`/ka-project setup` does this for projects):
```sh
# in agent-kit
gh label create friction --color FBCA04; gh label create retro --color 1D76DB
# in each project
for l in in-progress:FBCA04 sub-issue:C5DEF5 bug:D73A4A regression:B60205 lesson:0E8A16 security:5319E7; do gh label create "${l%%:*}" --color "${l##*:}" --force; done
```

## 4. Bringing a project onto the kit

In the project: start `claude` or `codex` and type `/ka-project setup`. On a new branch it:
1. Detects the stack and matches stack packs.
2. Suggests a mode and asks you to confirm.
3. Writes a short project `AGENTS.md` (moving long history files to `docs/history/`), adds `CLAUDE.md` (`@AGENTS.md`), CI and issue/PR templates, checks secrets, creates labels.
4. Opens a PR for you to review.

## 5. Daily flow

You decide at three checkpoints; the agent drives everything in between.

1. **Start:** `/k-next` (where things stand) or `/k-task <idea>` (a new task).
2. **Checkpoint 1, task:** you approve the written task. The agent creates the issue and a branch from the base branch.
3. **Checkpoint 2, plan:** you approve the plan. For anything users see, it comes with a design from `/k-design`: who it is for, the flow, every state, and a quick mockup. A plan of size L becomes a split from `/k-lead`, with the question whether to run the workers automatically.
4. The agent builds, verifies, runs the extra checks the project's Skill settings require (`/k-security`, `/k-design`), opens the pull request (`/k-ship`), and has it reviewed by a fresh reviewer subagent where the tool allows (otherwise it asks you to run `/k-review` in a new session). It fixes blockers.
5. **Checkpoint 3, result:** you get the pull request, checks and verdict; you look and merge.

It also stops when something is unclear, a safety rule or the hook blocks it, it needs to go outside the task's scope, or a check keeps failing. Say "step by step" (or set `### Flow` → `Control: step by step` with `/ka-project tune`) to confirm every skill yourself. `/k-handoff` saves the state when you stop; `/k-release` is separate and only on request.

**Base branch.** A project's `AGENTS.md` may say `Base branch: <name>` (default `main`). Issue branches, pull requests, `/k-next`, `/k-ship`, `/k-review`, `/k-lead` and `kit work` follow it. Releases are cut from `main`. The pre-commit hook blocks commits on `main`/`master` only.

**Large tasks.** Automatic mode (Claude Code): the lead starts up to 3 worker subagents in separate worktrees, each going plan → build → pull request, reviews each with a fresh reviewer, and reports at checkpoint 3; dependent parts start after you merge and say "continue". Manual mode (any tool): `kit work <sub-issue>` per part, an agent in each folder, `/k-lead status` to track.

## 6. All commands

Kit skills use two prefixes: `k-` for doing work and `ka-` for administering the kit and a project's setup (`ka-retro` is listed only inside the agent-kit repo). The prefix means a skill cannot collide with a tool's built-in commands (plain `/review`, `/plan`, `/debug`, `/security-review` are built-ins that do something else). Claude Code: `/k-<name>` (type `/k-` or `/ka-` to see them). Codex: `$k-<name>`, or pick from `/skills`. Gemini CLI: say "activate the k-<name> skill" (it asks permission; check with `/skills list`). Any other agent: tell it to read `~/GIT/agent-kit/skills/k-<name>/SKILL.md` and follow it. To look them up: `kit help` in a terminal, the cheat sheet at the top of `README.md`, or ask the agent "what can the kit do?".

| Command | Use it for |
|---|---|
| `/k-next` | Start of a session: what's open, what's next |
| `/k-task` | Turn a rough idea into a clear issue |
| `/k-plan` | Plan an issue; waits for approval |
| `/k-ship` | Verify and open a PR |
| `/k-review` | Independent review in a fresh session |
| `/k-release` | Version, tag, release notes |
| `/k-lead` | Split and track parallel work |
| `/k-code` | The code expert: `build` a feature, `fix` a bug (failing test first), `refactor` (no behaviour change), `database` (safe migration) |
| `/k-handoff` | Save where work stands before stopping |
| `/k-security` | Security review of a change or the whole app |
| `/k-design` | UI and UX: `design` a screen first (flow, states, mockup), `check` the built result after, `system` to create or revise the design system |
| `/k-content` | Text in the project's voice, with options |
| `/k-marketing` | Visibility: marketing, SEO and GEO. `audit` what is findable, `plan` what to win, `page` for one search intent, `measure` what works |
| `/ka-project` | `setup`: bring a repo onto the kit. `tune`: create or change its Skill settings, with questions |
| `/ka-retro` | Monthly kit improvement (run in this folder) |
| `kit work <n>` / `kit done <n>` / `kit list` | Worktrees for parallel agents |
| `kit help` | List all skills with one line each |
| `kit hooks` | Install the pre-commit hook in the current repo |
| `kit stats [--all] [--days N]` | Workflow numbers from GitHub |

**Skills with modes.** `/k-code`, `/k-design` and `/ka-project` are one skill each with several modes. The `SKILL.md` is a short front door that picks the mode (or takes it from you: `/k-code refactor`) and then follows that mode's own steps from `modes/<mode>.md` in the same folder, so each mode keeps its strict rules. One name to remember, no blurred procedures.

## 7. Making each project a bit different (Skill settings)

Skills are the same in every project. A project tunes them in its `AGENTS.md`, in a `## Skill settings` section with one block per skill that needs something different:

```markdown
## Skill settings

### /k-security
Level: strict. Run on every PR touching apps/app/backend, database/ or AI calls.
Extra checks: RLS on every table and column; spend caps on AI endpoints.

### /k-content
Voice: docs/brand/brand-strategy.md (Brand Voice, Terminology). Calm, plain, never hype.
```

- Every kit skill reads its block first and applies it on top of its own steps.
- Settings **add or tighten**; they never loosen the Safety rules. No block = kit default.
- Keep blocks short; point to existing docs (voice, design system, threat model) instead of repeating them.
- **Create or change them with `/ka-project tune`** in the project: it reads what the repo already has, asks a few questions (security strictness, voice, design rules, review must-checks), shows a draft, and writes it after your OK. `/ka-project tune content` changes just one skill.
- Need a genuinely different process? Write a project skill with a **new** name in `<project>/.agents/skills/`. Never copy a kit skill into a project to edit it — the copy stops getting kit improvements.

Mode (product / prototype / sandbox) sets the overall strictness; Skill settings fine-tune single skills inside it.

## 8. Being found: marketing, SEO and GEO (`/k-marketing`)

`/k-marketing` is the visibility expert. It covers marketing, SEO (being found in search engines) and GEO (being cited or named in AI answers). It proposes and checks; the pages themselves are built through the normal flow, with `/k-content` for the words, `/k-design` for the layout and `/k-code` for the code.

| Mode | Use it when you want… | What you get |
|---|---|---|
| `audit` | to know how findable the site or a page is today | A report, most valuable first: what blocks being found, what would win real searches, housekeeping, and what is not worth doing |
| `plan` | a direction | Who to reach, which searches and questions to win, which pages to build in what order, where to be present beyond the site, a rhythm you can sustain, and how it will be measured |
| `page` | one page that wins one search or question | A brief (title, outline, the direct answer first, proof, call to action), then the page built and checked |
| `measure` | to know what is working | Search, AI-assistant and conversion numbers against the baseline; keep, improve or stop; the next three actions |

**Examples**
```
/k-marketing audit the marketing site
/k-marketing plan for couples who manage money together
/k-marketing page for "how to track net worth as a couple"
/k-marketing measure the last 30 days
```

**Rules built in**
- Honest marketing only: no invented numbers, reviews, testimonials or comparisons; no planted mentions, link schemes or keyword stuffing.
- It searches the web for current facts (keywords, competitors, the engines' guidance) rather than relying on memory, and says where it found them.
- It never publishes, posts, emails or submits anything itself. You get the text and the steps.
- No promises: nobody can guarantee a ranking or an AI citation. It gives a direction and a way to measure.
- For `measure` it needs real data. If the agent cannot see your search console or analytics, it tells you which export to provide.

**What the knowledge pack (`stacks/seo-geo.md`) is based on**, as of November 2026:
- Google states that its AI features (AI Overviews, AI Mode) use the same index and ranking systems as Search, so doing SEO well is how to appear there, and that site owners can ignore `llms.txt` files, content chunking, AI-specific rewriting, inauthentic brand mentions and over-reliance on structured data for AI. Source: [Optimizing your website for generative AI features on Google Search](https://developers.google.com/search/docs/fundamentals/ai-optimization-guide).
- Other AI assistants (ChatGPT, Perplexity and others) may weigh signals differently, and the evidence for GEO-specific tactics is contested: vendors report gains from `llms.txt`, independent reviews find AI crawlers mostly ignore it.
- So the pack puts fundamentals first (useful original content, pages crawlers can read, the answer first, fresh and dated content, original data, real presence on sites people trust) and marks `llms.txt` and "schema for AI" as unproven: harmless, never the plan.
- GEO changes fast. `/ka-retro` re-checks this pack against current official guidance, and the skill itself searches before advising.

**Per project.** Run `/ka-project tune marketing` once. It records the audience, markets and languages, the positioning, the project's own SEO or marketing strategy document, the channels in use and whether the agent can see search data, under `### /k-marketing` in the project's Skill settings.

## 9. Lessons, friction and improving the kit

- **Lessons:** when a bug teaches something general, the agent writes symptom → cause → fix → prevention on the issue and labels it `lesson`. Agents search past lessons before working in an area (`gh issue list --label lesson --state all --search "<area>"`).
- **Where a lesson ends up:** project code → a test or lint rule (else one line in the project's Rules); a technology → its stack pack; how agents work → this kit. Prefer enforcing over writing down.
- **Friction:** when a kit rule or skill gets in the way, or you correct an agent on how to work, the agent opens an issue in this repo labelled `friction`.
- **Measure:** `kit stats --all` shows merged PRs, hours to merge, PR size, review blockers, CI failures, bugs, lessons and security findings per project.
- **Improve:** once a month, start an agent in this folder and run `/ka-retro`. It measures, reads lessons and friction, checks whether last month's changes helped, and opens a PR with at most 3 changes plus a `retro` issue with next month's targets. You approve. It never loosens the safety rules.

## 10. Enforcement (rules the computer checks)

Written rules get skipped sometimes. These are enforced:

| Check | Where | What it does |
|---|---|---|
| Pre-commit hook | each repo, installed with `kit hooks` | Blocks commits on `main` (product and prototype mode) and commits that add `.env` files, key files, anything under `private/`, or lines that look like live keys (Stripe, AWS, GitHub, Google, Anthropic/OpenAI, Supabase secret keys, private keys) |
| Claude Code deny rules | `~/.claude/settings.json` (from `install.sh`) | Claude cannot read `.env`, `private/` or key files |
| CI | each repo's `.github/workflows` | Lint, build and tests on every pull request |
| Dependabot | each product repo's `.github/dependabot.yml` + GitHub setting | Pull requests for security updates |
| Branch protection | GitHub → Settings → Rules | `main` only accepts pull requests with green checks (switch on after a week of using branches) |

The hook works for every tool and for you. Bypass only when you mean it: `KIT_ALLOW_MAIN=1 git commit …` or `KIT_ALLOW_SECRET=1 git commit …`. A test fixture that must contain a key-shaped string gets the comment `kit:allow-secret` on that line. The hook lives in `.git/hooks`, so run `kit hooks` once per clone.

## 11. Changing the kit yourself

- Edit a skill or rule → save → commit and push. Done.
- New skill → `skills/k-<name>/SKILL.md` (work), `skills/ka-<name>/SKILL.md` (project admin) or `admin/ka-<name>/SKILL.md` (kit-only, linked just inside this repo) with `name` and `description` at the top, add it to the table in `AGENTS.md` → Skills, run `sh install.sh`.
- New stack pack → `stacks/<tech>.md` (under ~40 lines), then list it in the projects that use it (`Stacks:` line).
- Size limit: at most 15 work skills (`k-`) and 5 admin skills (`ka-`). At the limit, a new skill replaces or merges with an existing one. Every skill's description is loaded into every session, so fewer is better. `kit help` shows the count; `install.sh` warns when the limit is passed.
- Undo a change: `git log` to find it, `git revert <commit>`.
