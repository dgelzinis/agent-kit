# Global working rules (agent-kit)

These rules apply in every project, for every agent (Claude Code, Codex, Gemini).
The project's own `AGENTS.md` adds to them and wins where they differ.

## Project mode
The first lines of the project's `AGENTS.md` say `Mode: product`, `Mode: prototype` or `Mode: sandbox`. No mode stated → treat it as `product`.

| | product (users, payments, real data) | prototype (building, no real users yet) | sandbox (courses, experiments) |
|---|---|---|---|
| Work from an issue | yes | when it helps | no |
| `/k-plan` before code | yes, wait for OK | for bigger changes | no |
| Branch + PR, never commit to `main` | yes | yes | may commit to `main` |
| `/k-review` in a fresh session | yes | optional | no |
| Tests for new logic | yes | for tricky logic | optional |
| `/k-security` | before every release; on auth/payments/user-data changes | before first real users | no |
| `/k-release` | yes | no | no |

The Safety rules below apply in every mode. The rest of this file describes `product`; relax it as the table says.

## How we work
1. **Work comes from a GitHub issue.** Start with `/k-next` if no issue is given. I describe something without an issue → use `/k-task` to write it up, and create the issue after I agree.
2. **Plan before code.** For anything beyond a one-line fix, run `/k-plan` and wait for my OK.
3. **Never commit to the base branch.** One branch per issue: `<issue>-<short-name>` (e.g. `42-loan-what-if`), created from the base branch; pull requests target it. The base branch is `main` unless the project's `AGENTS.md` says `Base branch: <name>`; wherever a skill says `<base>`, use it. Releases are always cut from `main`.
4. **Stay in scope.** Only change what the issue needs. If shared code must change, or you find another problem, comment on the issue (or open a new one) and continue only with my OK.
5. **Done means verified.** Run the project's lint, test and build commands (from its `AGENTS.md` → Commands) until they pass. New logic gets a test; money, dates and permissions always do. All code changes go through `/k-code`, in the mode the plan names: bugs in `fix` mode, restructuring in `refactor` mode and in its own pull request, schema changes in `database` mode; anything that changes what users see goes through `/k-design` twice: a design with a mockup at the plan checkpoint, and a check in the browser before `/k-ship`.
6. **Ship through a pull request.** Use `/k-ship`. The PR title is a Conventional Commit (`feat:`, `fix:`, `refactor:`, `docs:`, `chore:`, `test:`) and the body says `Closes #<issue>`.
7. **Someone else reviews.** `/k-review` runs with a fresh context (a reviewer subagent, or a new session). I merge; agents never merge.
8. **Releases are separate.** Only `/k-release`, only when I ask.

## Checkpoints (how I stay in control)
Once I give you a task, drive the flow yourself; do not wait for me to type the next skill. Stop and wait for me only at these three checkpoints:

1. **Task:** the written task from `/k-task`, before the issue is created. Skipped when I point you at an existing issue.
2. **Plan:** the plan from `/k-plan`, or the split when the task is large. Nothing is built before my OK.
3. **Result:** the pull request(s) with the review verdict. I look at the result and merge.

Between checkpoints carry on by yourself: branch, build, verify, `/k-ship`, review.
- **Large tasks:** when a plan comes out size L, switch to `/k-lead` yourself and present the split as checkpoint 2.
- **Review:** after `/k-ship`, if you can start a subagent with a fresh context (Claude Code: the `reviewer` agent), run `/k-review` through it and fix its blockers before checkpoint 3. If you cannot, tell me to run `/k-review` in a new session.
- **Stop at any time** when: something is unclear and a wrong guess would cost real rework; a Safety rule or the pre-commit hook blocks you; you need to change something outside the issue's scope; a check still fails after two honest attempts. Say in one or two sentences what you need from me.
- **Keep me oriented.** Start each checkpoint with one line, e.g. `Checkpoint 2 of 3: plan for #42`, and end with exactly what I can answer ("ok", or what to change).
- **More control:** if I say "step by step", or the project's Skill settings say `Control: step by step`, wait for me before every skill instead.

## Skills (slash commands)
Kit skills use a prefix so they never collide with a tool's built-in commands (plain `/review`, `/plan`, `/debug`, `/security-review` are built-ins and do something else): **`k-` for doing work, `ka-` for administering the kit and a project's setup.** Claude Code: type `/k-next`. Codex: `$k-next` or pick from `/skills`. Gemini CLI: "activate the k-next skill". If your tool does not list a skill, read its file and follow it. When I ask "what can the kit do?", answer from these tables (or tell me to run `kit help`).

Work skills (`k-`), in `~/GIT/agent-kit/skills/<name>/SKILL.md`:

| Command | For |
|---|---|
| `/k-next` | start of a session: where things stand, what is next |
| `/k-task` | turn a rough idea into a clear issue (what, why, done when) |
| `/k-plan` | plan an issue and wait for approval |
| `/k-code` | the code expert, in one of four modes: `build` a feature, `fix` a bug (failing test first), `refactor` (no behaviour change), `database` (safe migration) |
| `/k-design` | UI and UX: design a screen before building, check it after |
| `/k-content` | text in the project's voice |
| `/k-marketing` | visibility: marketing, SEO and GEO, in four modes: `audit` what is findable today, `plan` who to reach and what to win, `page` for one search intent, `measure` what works |
| `/k-ship` | verify and open a pull request |
| `/k-review` | independent review with a fresh context |
| `/k-security` | security review. Always its own independent skill, never a mode of another; any skill calls it when a change touches sign-in, permissions, payments, personal data, secrets or AI calls |
| `/k-release` | version, tag, release notes |
| `/k-lead` | split and run parallel work on a large task |
| `/k-handoff` | save where work stands before stopping |

Some skills have modes (`/k-code fix`, `/k-design check`, `/ka-project tune`). The skill's `SKILL.md` picks the mode and points to that mode's own steps in a file beside it; read only that file.

Size limit for the kit: at most 15 work skills and 5 admin skills. If I ask for a new skill at the limit, say so and propose which one to replace or merge instead of adding a 16th or 6th.

Admin skills (`ka-`). Run them only when I ask; never start one on your own in the middle of project work:

| Command | File | For |
|---|---|---|
| `/ka-project` | `~/GIT/agent-kit/skills/ka-project/SKILL.md` | `setup`: bring a repo onto the kit; `tune`: create or change its Skill settings |
| `/ka-retro` | `~/GIT/agent-kit/admin/ka-retro/SKILL.md` | monthly kit improvement; available only inside the agent-kit repo |

**Per-project tuning:** a project's `AGENTS.md` may have `## Skill settings` with a `### /<skill>` block. Before running a kit skill, read its block and apply it on top: settings add steps or tighten rules (e.g. stricter security, the project's voice), never loosen Safety. Edit them with `/ka-project tune`.
A project may add its own skills in `.agents/skills/` under new names; do not copy a kit skill into a project to change it.

## Knowledge packs
`~/GIT/agent-kit/stacks/` holds short packs with the industry standard (named, with its source) and the rules that matter for a technology or a problem. Before working in an area, read the packs for it; the table in `~/GIT/agent-kit/stacks/README.md` says which.
- **Technology packs** are the ones the project lists (`Stacks: react-vite, node-express, supabase`).
- **Problem packs** are chosen by what the change touches: `code` (always), `ux` (anything users see), `testing`, `security`, `api`, `payments-stripe`, `ai-llm`, `seo-geo` (public pages and anything about being found).
- Read only what you need. For exact syntax and version-specific behaviour, check the current official docs named in the pack's Standards line; do not rely on memory for fast-moving tools.
- The project's own rules win over a pack. A lesson that applies to the technology or problem, not just the project, belongs in its pack. No pack for a technology you are working in → say so, and propose one.

## Safety
- Never read, print or copy secrets: `.env*` (except `.env.example`), `private/`, `*.pem`, `*.key`, credentials files. If a task seems to need one, stop and ask.
- Repositories on the kit have a pre-commit hook (`kit hooks`): it blocks commits on `main` and commits containing secrets. Never bypass it (`--no-verify`, `KIT_ALLOW_MAIN`, `KIT_ALLOW_SECRET`) without my OK; fix the cause instead.
- Never run destructive commands without my OK: `git push --force`, `git reset --hard`, `rm -rf`, dropping tables, running migrations against production.
- Database changes only through migration files in the repo, via `/k-code database`. Agents never apply migrations to a live database.
- Do not add dependencies without saying why in the PR.

## Context and tokens
- Read what the task needs, not the whole repo. Prefer `grep`/search over opening large files.
- Do not paste long logs; quote the failing lines.
- Docs: update only the docs the change makes wrong. No change logs or ledgers in markdown; history lives in git, issues and PRs.
- A lesson worth keeping becomes a test, a lint rule or one line in the project's `AGENTS.md` → Rules. Not a diary entry.

## Lessons and friction (how the kit improves)
- **Lessons:** when a bug or mistake teaches something beyond the single issue, write symptom → cause → fix → prevention on the issue and add the label `lesson`. Before working in an area, search past lessons: `gh issue list --label lesson --state all --search "<area>"`.
- **Where a lesson ends up:** this project's code → a test or lint rule (else one line in the project's Rules); a technology → its stack pack; how agents work → this kit. `/ka-retro` proposes the promotion; the owner approves.
- **Friction:** when a kit rule or skill is unclear, wrong, or conflicts with the project — or the owner corrects you on how to work — open an issue: `gh issue create -R dgelzinis/agent-kit --label friction --title "<skill or rule>: <problem>" --body "<what happened, project, what would have helped>"`. One line of evidence is enough. Then continue with the owner's instruction.

## Parallel work (when `/k-lead` split an issue)
- Work only in your own worktree and on your own sub-issue.
- Label the sub-issue `in-progress` when you start (`gh issue edit <n> --add-label in-progress`).
- If your sub-issue depends on another that is not merged, stop and say so.

## Communication
- Stopping mid-task or the session is getting long → `/k-handoff` before ending.
- Be brief. At the end of a task: what changed, how it was verified, what is left.
- When unsure about intent, ask one clear question rather than guessing.
