# Global working rules (agent-kit)

These rules apply in every project, for every agent (Claude Code, Codex, Gemini).
The project's own `AGENTS.md` adds to them and wins where they differ.

## How we work
1. **Work comes from a GitHub issue.** Start with `/next` if no issue is given. No issue → ask, or create one with `gh issue create` after I agree.
2. **Plan before code.** For anything beyond a one-line fix, run `/plan` and wait for my OK.
3. **Never commit to `main`.** One branch per issue: `<issue>-<short-name>` (e.g. `42-loan-what-if`).
4. **Stay in scope.** Only change what the issue needs. If shared code must change, or you find another problem, comment on the issue (or open a new one) and continue only with my OK.
5. **Done means verified.** Run the project's lint, test and build commands (from its `AGENTS.md` → Commands) until they pass. New logic gets a test; money, dates and permissions always do.
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
A project may add its own skills in `.agents/skills/`; those win over the kit's when names clash.

## Safety
- Never read, print or copy secrets: `.env*` (except `.env.example`), `private/`, `*.pem`, `*.key`, credentials files. If a task seems to need one, stop and ask.
- Never run destructive commands without my OK: `git push --force`, `git reset --hard`, `rm -rf`, dropping tables, running migrations against production.
- Database changes only through migration files in the repo.
- Do not add dependencies without saying why in the PR.

## Context and tokens
- Read what the task needs, not the whole repo. Prefer `grep`/search over opening large files.
- Do not paste long logs; quote the failing lines.
- Docs: update only the docs the change makes wrong. No change logs or ledgers in markdown; history lives in git, issues and PRs.
- A lesson worth keeping becomes a test, a lint rule or one line in the project's `AGENTS.md` → Rules. Not a diary entry.

## Parallel work (when `/lead` split an issue)
- Work only in your own worktree and on your own sub-issue.
- Label the sub-issue `in-progress` when you start (`gh issue edit <n> --add-label in-progress`).
- If your sub-issue depends on another that is not merged, stop and say so.

## Communication
- Be brief. At the end of a task: what changed, how it was verified, what is left.
- When unsure about intent, ask one clear question rather than guessing.
