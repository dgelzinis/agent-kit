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
1. **Work comes from a GitHub issue.** Start with `/k-next` if no issue is given. No issue → ask, or create one with `gh issue create` after I agree.
2. **Plan before code.** For anything beyond a one-line fix, run `/k-plan` and wait for my OK.
3. **Never commit to `main`.** One branch per issue: `<issue>-<short-name>` (e.g. `42-loan-what-if`).
4. **Stay in scope.** Only change what the issue needs. If shared code must change, or you find another problem, comment on the issue (or open a new one) and continue only with my OK.
5. **Done means verified.** Run the project's lint, test and build commands (from its `AGENTS.md` → Commands) until they pass. New logic gets a test; money, dates and permissions always do. Bugs go through `/k-debug`; UI changes get a `/k-design-check` before `/k-ship`.
6. **Ship through a pull request.** Use `/k-ship`. The PR title is a Conventional Commit (`feat:`, `fix:`, `refactor:`, `docs:`, `chore:`, `test:`) and the body says `Closes #<issue>`.
7. **Someone else reviews.** `/k-review` runs in a fresh session. I merge; agents never merge.
8. **Releases are separate.** Only `/k-release`, only when I ask.

## Skills (slash commands)
All kit skills start with `k-` so they never collide with a tool's built-in commands (`/review`, `/plan`, `/debug`, `/security-review` are built-ins and do something else). Claude Code: type `/k-next`. Codex: type `$k-next` or pick it from `/skills`. If your tool does not list a skill, read its file and follow it. When I ask "what can the kit do?", answer from this table (or tell me to run `kit help`).

| Command | File |
|---|---|
| `/k-next` | `~/GIT/agent-kit/skills/k-next/SKILL.md` |
| `/k-plan` | `~/GIT/agent-kit/skills/k-plan/SKILL.md` |
| `/k-ship` | `~/GIT/agent-kit/skills/k-ship/SKILL.md` |
| `/k-review` | `~/GIT/agent-kit/skills/k-review/SKILL.md` |
| `/k-release` | `~/GIT/agent-kit/skills/k-release/SKILL.md` |
| `/k-lead` | `~/GIT/agent-kit/skills/k-lead/SKILL.md` |
| `/k-setup-project` | `~/GIT/agent-kit/skills/k-setup-project/SKILL.md` |
| `/k-debug` | `~/GIT/agent-kit/skills/k-debug/SKILL.md` |
| `/k-handoff` | `~/GIT/agent-kit/skills/k-handoff/SKILL.md` |
| `/k-security` | `~/GIT/agent-kit/skills/k-security/SKILL.md` |
| `/k-design-check` | `~/GIT/agent-kit/skills/k-design-check/SKILL.md` |
| `/k-content` | `~/GIT/agent-kit/skills/k-content/SKILL.md` |
| `/k-db-change` | `~/GIT/agent-kit/skills/k-db-change/SKILL.md` |
| `/k-tune` | `~/GIT/agent-kit/skills/k-tune/SKILL.md` |
| `/k-retro` | `~/GIT/agent-kit/skills/k-retro/SKILL.md` (monthly, from the agent-kit repo) |
**Per-project tuning:** a project's `AGENTS.md` may have `## Skill settings` with a `### /<skill>` block. Before running a kit skill, read its block and apply it on top: settings add steps or tighten rules (e.g. stricter security, the project's voice), never loosen Safety. Edit them with `/k-tune`.
A project may add its own skills in `.agents/skills/` under new names; do not copy a kit skill into a project to change it.

## Stack packs
The project's `AGENTS.md` lists its technologies (`Stacks: react-vite, node-express, supabase`). Before working in one of those areas, read `~/GIT/agent-kit/stacks/<name>.md` (short; only the packs you need). Lessons that apply to the technology, not just the project, belong in its pack.

## Safety
- Never read, print or copy secrets: `.env*` (except `.env.example`), `private/`, `*.pem`, `*.key`, credentials files. If a task seems to need one, stop and ask.
- Repositories on the kit have a pre-commit hook (`kit hooks`): it blocks commits on `main` and commits containing secrets. Never bypass it (`--no-verify`, `KIT_ALLOW_MAIN`, `KIT_ALLOW_SECRET`) without my OK; fix the cause instead.
- Never run destructive commands without my OK: `git push --force`, `git reset --hard`, `rm -rf`, dropping tables, running migrations against production.
- Database changes only through migration files in the repo, via `/k-db-change`. Agents never apply migrations to a live database.
- Do not add dependencies without saying why in the PR.

## Context and tokens
- Read what the task needs, not the whole repo. Prefer `grep`/search over opening large files.
- Do not paste long logs; quote the failing lines.
- Docs: update only the docs the change makes wrong. No change logs or ledgers in markdown; history lives in git, issues and PRs.
- A lesson worth keeping becomes a test, a lint rule or one line in the project's `AGENTS.md` → Rules. Not a diary entry.

## Lessons and friction (how the kit improves)
- **Lessons:** when a bug or mistake teaches something beyond the single issue, write symptom → cause → fix → prevention on the issue and add the label `lesson`. Before working in an area, search past lessons: `gh issue list --label lesson --state all --search "<area>"`.
- **Where a lesson ends up:** this project's code → a test or lint rule (else one line in the project's Rules); a technology → its stack pack; how agents work → this kit. `/k-retro` proposes the promotion; the owner approves.
- **Friction:** when a kit rule or skill is unclear, wrong, or conflicts with the project — or the owner corrects you on how to work — open an issue: `gh issue create -R dgelzinis/agent-kit --label friction --title "<skill or rule>: <problem>" --body "<what happened, project, what would have helped>"`. One line of evidence is enough. Then continue with the owner's instruction.

## Parallel work (when `/k-lead` split an issue)
- Work only in your own worktree and on your own sub-issue.
- Label the sub-issue `in-progress` when you start (`gh issue edit <n> --add-label in-progress`).
- If your sub-issue depends on another that is not merged, stop and say so.

## Communication
- Stopping mid-task or the session is getting long → `/k-handoff` before ending.
- Be brief. At the end of a task: what changed, how it was verified, what is left.
- When unsure about intent, ask one clear question rather than guessing.
