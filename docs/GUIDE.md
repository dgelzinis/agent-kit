# agent-kit guide

How the kit is put together, how to use it day to day, and how changes reach your projects.

## 1. What the kit is

One folder (`~/GIT/agent-kit`, backed up to a private GitHub repo) that holds how you work with coding agents. Claude Code, Codex and Gemini all read it, in every project.

There are three layers. Each one adds to the one above and wins where they disagree:

| Layer | Where | Holds |
|---|---|---|
| **Kit** | `~/GIT/agent-kit/AGENTS.md`, `skills/` | How you work: plan → branch → PR → review, safety rules, the slash commands |
| **Stack packs** | `~/GIT/agent-kit/stacks/` | Rules and traps per technology (Supabase, React/Vite, Node/Express, Next.js) |
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
| Templates (`templates/project/`) | Nothing for new projects. Existing projects keep their own copies (`AGENTS.md`, `.github/`); ask `/k-setup-project` in a project to bring it up to date if needed. |

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

Labels used by the workflow, once per repo (`/k-setup-project` does this for projects):
```sh
# in agent-kit
gh label create friction --color FBCA04; gh label create retro --color 1D76DB
# in each project
for l in in-progress:FBCA04 sub-issue:C5DEF5 bug:D73A4A regression:B60205 lesson:0E8A16 security:5319E7; do gh label create "${l%%:*}" --color "${l##*:}" --force; done
```

## 4. Bringing a project onto the kit

In the project: start `claude` or `codex` and type `/k-setup-project`. On a new branch it:
1. Detects the stack and matches stack packs.
2. Suggests a mode and asks you to confirm.
3. Writes a short project `AGENTS.md` (moving long history files to `docs/history/`), adds `CLAUDE.md` (`@AGENTS.md`), CI and issue/PR templates, checks secrets, creates labels.
4. Opens a PR for you to review.

## 5. Daily flow

| Step | You say / do | What happens |
|---|---|---|
| Start | `claude` or `codex`, then `/k-next` | Unfinished work (and the last `/k-handoff`), open PRs, top ready issues |
| Pick | "work on #12" | Branch `12-…`, issue labelled `in-progress` |
| Plan | `/k-plan` | Plan posted on the issue; the agent waits for your OK |
| Build | "ok" | Code + tests; `/k-debug` for bugs, `/k-db-change` for database changes, `/k-content` for text |
| Check UI | `/k-design-check` | Screenshots at phone/tablet/desktop against the design rules |
| PR | `/k-ship` | Checks pass, PR opened with `Closes #12`, CI runs |
| Review | new terminal, fresh session: `/k-review` | Verdict posted on the PR; the builder fixes blockers |
| Look | you | Click through it on phone and laptop |
| Merge | you (`gh pr merge --squash --delete-branch`) | Deploys, issue closes |
| Stop mid-task | `/k-handoff` | Where things stand, saved on the issue for the next session |
| Release | `/k-release`, when you choose | `/k-security` first for products, then release PR → tag → GitHub release |

Parallel work on a big issue: `/k-lead #12` splits it into sub-issues; `kit work <n>` creates a worktree per sub-issue; start an agent in each; `/k-lead status` tracks them. Keep it to 2–3 workers.

## 6. All commands

Every kit skill starts with `k-`, so it cannot collide with a tool's built-in commands (plain `/review`, `/plan`, `/debug`, `/security-review` are built-ins that do something else). Claude Code: `/k-<name>` (type `/k-` to see them all). Codex: `$k-<name>`, or pick from `/skills`. Any other agent: tell it to read `~/GIT/agent-kit/skills/k-<name>/SKILL.md` and follow it. To look them up: `kit help` in a terminal, the cheat sheet at the top of `README.md`, or ask the agent "what can the kit do?".

| Command | Use it for |
|---|---|
| `/k-next` | Start of a session: what's open, what's next |
| `/k-plan` | Plan an issue; waits for approval |
| `/k-ship` | Verify and open a PR |
| `/k-review` | Independent review in a fresh session |
| `/k-release` | Version, tag, release notes |
| `/k-lead` | Split and track parallel work |
| `/k-setup-project` | Bring a repo onto the kit |
| `/k-debug` | Bug → failing test → fix → proof |
| `/k-handoff` | Save where work stands before stopping |
| `/k-security` | Security review of a change or the whole app |
| `/k-design-check` | Visual/UX check in a browser |
| `/k-content` | Text in the project's voice, with options |
| `/k-db-change` | Safe database migrations |
| `/k-tune` | Create or change a project's Skill settings, with questions |
| `/k-retro` | Monthly kit improvement (run in this folder) |
| `kit work <n>` / `kit done <n>` / `kit list` | Worktrees for parallel agents |
| `kit help` | List all skills with one line each |
| `kit hooks` | Install the pre-commit hook in the current repo |
| `kit stats [--all] [--days N]` | Workflow numbers from GitHub |

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
- **Create or change them with `/k-tune`** in the project: it reads what the repo already has, asks a few questions (security strictness, voice, design rules, review must-checks), shows a draft, and writes it after your OK. `/k-tune content` changes just one skill.
- Need a genuinely different process? Write a project skill with a **new** name in `<project>/.agents/skills/`. Never copy a kit skill into a project to edit it — the copy stops getting kit improvements.

Mode (product / prototype / sandbox) sets the overall strictness; Skill settings fine-tune single skills inside it.

## 8. Lessons, friction and improving the kit

- **Lessons:** when a bug teaches something general, the agent writes symptom → cause → fix → prevention on the issue and labels it `lesson`. Agents search past lessons before working in an area (`gh issue list --label lesson --state all --search "<area>"`).
- **Where a lesson ends up:** project code → a test or lint rule (else one line in the project's Rules); a technology → its stack pack; how agents work → this kit. Prefer enforcing over writing down.
- **Friction:** when a kit rule or skill gets in the way, or you correct an agent on how to work, the agent opens an issue in this repo labelled `friction`.
- **Measure:** `kit stats --all` shows merged PRs, hours to merge, PR size, review blockers, CI failures, bugs, lessons and security findings per project.
- **Improve:** once a month, start an agent in this folder and run `/k-retro`. It measures, reads lessons and friction, checks whether last month's changes helped, and opens a PR with at most 3 changes plus a `retro` issue with next month's targets. You approve. It never loosens the safety rules.

## 9. Enforcement (rules the computer checks)

Written rules get skipped sometimes. These are enforced:

| Check | Where | What it does |
|---|---|---|
| Pre-commit hook | each repo, installed with `kit hooks` | Blocks commits on `main` (product and prototype mode) and commits that add `.env` files, key files, anything under `private/`, or lines that look like live keys (Stripe, AWS, GitHub, Google, Anthropic/OpenAI, Supabase secret keys, private keys) |
| Claude Code deny rules | `~/.claude/settings.json` (from `install.sh`) | Claude cannot read `.env`, `private/` or key files |
| CI | each repo's `.github/workflows` | Lint, build and tests on every pull request |
| Dependabot | each product repo's `.github/dependabot.yml` + GitHub setting | Pull requests for security updates |
| Branch protection | GitHub → Settings → Rules | `main` only accepts pull requests with green checks (switch on after a week of using branches) |

The hook works for every tool and for you. Bypass only when you mean it: `KIT_ALLOW_MAIN=1 git commit …` or `KIT_ALLOW_SECRET=1 git commit …`. A test fixture that must contain a key-shaped string gets the comment `kit:allow-secret` on that line. The hook lives in `.git/hooks`, so run `kit hooks` once per clone.

## 10. Changing the kit yourself

- Edit a skill or rule → save → commit and push. Done.
- New skill → `skills/<name>/SKILL.md` with `name` and `description` at the top, add it to the table in `AGENTS.md` → Skills, run `sh install.sh`.
- New stack pack → `stacks/<tech>.md` (under ~40 lines), then list it in the projects that use it (`Stacks:` line).
- Keep the kit small: about 10–15 skills. Every skill's description is loaded into every session.
- Undo a change: `git log` to find it, `git revert <commit>`.
