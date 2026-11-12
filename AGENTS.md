# Global working rules (agent-kit)

These rules apply in every project, for every agent (Claude Code, Codex, Gemini).
The project's own `AGENTS.md` adds to them and wins where they differ.

## Project mode
The first lines of the project's `AGENTS.md` say `Mode: product`, `Mode: prototype` or `Mode: sandbox`. No mode stated → treat it as `product`.

| | product (users, payments, real data) | prototype (building, no real users yet) | sandbox (courses, experiments) |
|---|---|---|---|
| Work from an issue | yes | when it helps | no |
| `/plan` before code | yes, wait for OK | for bigger changes | no |
| Branch + PR, never commit to `main` | yes | yes | may commit to `main` |
| `/review` in a fresh session | yes | optional | no |
| Tests for new logic | yes | for tricky logic | optional |
| `/security` | before every release; on auth/payments/user-data changes | before first real users | no |
| `/release` | yes | no | no |

The Safety rules below apply in every mode. The rest of this file describes `product`; relax it as the table says.

## How we work
1. **Work comes from a GitHub issue.** Start with `/next` if no issue is given. No issue → ask, or create one with `gh issue create` after I agree.
2. **Plan before code.** For anything beyond a one-line fix, run `/plan` and wait for my OK.
3. **Never commit to `main`.** One branch per issue: `<issue>-<short-name>` (e.g. `42-loan-what-if`).
4. **Stay in scope.** Only change what the issue needs. If shared code must change, or you find another problem, comment on the issue (or open a new one) and continue only with my OK.
5. **Done means verified.** Run the project's lint, test and build commands (from its `AGENTS.md` → Commands) until they pass. New logic gets a test; money, dates and permissions always do. Bugs go through `/debug`; UI changes get a `/design-check` before `/ship`.
6. **Ship through a pull request.** Use `/ship`. The PR title is a Conventional Commit (`feat:`, `fix:`, `refactor:`, `docs:`, `chore:`, `test:`) and the body says `Closes #<issue>`.
7. **Someone else reviews.** `/review` runs in a fresh session. I merge; agents never merge.
8. **Releases are separate.** Only `/release`, only when I ask.

## Skills (slash commands)
If your tool does not list these as commands, read the file and follow it.

| Command | File |
|---|---|
| `/next` | `~/GIT/agent-kit/skills/next/SKILL.md` |
| `/plan` | `~/GIT/agent-kit/skills/plan/SKILL.md` |
| `/ship` | `~/GIT/agent-kit/skills/ship/SKILL.md` |
| `/review` | `~/GIT/agent-kit/skills/review/SKILL.md` |
| `/release` | `~/GIT/agent-kit/skills/release/SKILL.md` |
| `/lead` | `~/GIT/agent-kit/skills/lead/SKILL.md` |
| `/setup-project` | `~/GIT/agent-kit/skills/setup-project/SKILL.md` |
| `/debug` | `~/GIT/agent-kit/skills/debug/SKILL.md` |
| `/handoff` | `~/GIT/agent-kit/skills/handoff/SKILL.md` |
| `/security` | `~/GIT/agent-kit/skills/security/SKILL.md` |
| `/design-check` | `~/GIT/agent-kit/skills/design-check/SKILL.md` |
| `/content` | `~/GIT/agent-kit/skills/content/SKILL.md` |
| `/db-change` | `~/GIT/agent-kit/skills/db-change/SKILL.md` |
| `/retro` | `~/GIT/agent-kit/skills/retro/SKILL.md` (monthly, from the agent-kit repo) |
A project may add its own skills in `.agents/skills/`; those win over the kit's when names clash.

## Stack packs
The project's `AGENTS.md` lists its technologies (`Stacks: react-vite, node-express, supabase`). Before working in one of those areas, read `~/GIT/agent-kit/stacks/<name>.md` (short; only the packs you need). Lessons that apply to the technology, not just the project, belong in its pack.

## Safety
- Never read, print or copy secrets: `.env*` (except `.env.example`), `private/`, `*.pem`, `*.key`, credentials files. If a task seems to need one, stop and ask.
- Never run destructive commands without my OK: `git push --force`, `git reset --hard`, `rm -rf`, dropping tables, running migrations against production.
- Database changes only through migration files in the repo, via `/db-change`. Agents never apply migrations to a live database.
- Do not add dependencies without saying why in the PR.

## Context and tokens
- Read what the task needs, not the whole repo. Prefer `grep`/search over opening large files.
- Do not paste long logs; quote the failing lines.
- Docs: update only the docs the change makes wrong. No change logs or ledgers in markdown; history lives in git, issues and PRs.
- A lesson worth keeping becomes a test, a lint rule or one line in the project's `AGENTS.md` → Rules. Not a diary entry.

## Lessons and friction (how the kit improves)
- **Lessons:** when a bug or mistake teaches something beyond the single issue, write symptom → cause → fix → prevention on the issue and add the label `lesson`. Before working in an area, search past lessons: `gh issue list --label lesson --state all --search "<area>"`.
- **Where a lesson ends up:** this project's code → a test or lint rule (else one line in the project's Rules); a technology → its stack pack; how agents work → this kit. `/retro` proposes the promotion; the owner approves.
- **Friction:** when a kit rule or skill is unclear, wrong, or conflicts with the project — or the owner corrects you on how to work — open an issue: `gh issue create -R dgelzinis/agent-kit --label friction --title "<skill or rule>: <problem>" --body "<what happened, project, what would have helped>"`. One line of evidence is enough. Then continue with the owner's instruction.

## Parallel work (when `/lead` split an issue)
- Work only in your own worktree and on your own sub-issue.
- Label the sub-issue `in-progress` when you start (`gh issue edit <n> --add-label in-progress`).
- If your sub-issue depends on another that is not merged, stop and say so.

## Communication
- Stopping mid-task or the session is getting long → `/handoff` before ending.
- Be brief. At the end of a task: what changed, how it was verified, what is left.
- When unsure about intent, ask one clear question rather than guessing.
