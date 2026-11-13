---
name: ka-retro
description: Monthly improvement run for the agent-kit — measure how the workflow performed across projects, turn lessons and friction into tests, rules or kit changes, and check whether last month's changes helped. Use when the user says /ka-retro or on the monthly schedule.
---

# /ka-retro — measure, learn, improve the kit

Run from `~/GIT/agent-kit`. Output is a pull request to this repo that the owner approves. Never merge it yourself.

## Guardrails
- Never loosen anything in `AGENTS.md` → Safety, and never remove a safety check, review or test requirement for `product` mode. Only the owner changes those.
- At most **3 proposals** per retro, each one small and with its evidence and the number it should move.
- The kit holds at most 15 work skills (`k-`) and 5 admin skills (`ka-`). A proposal for a new skill at the limit must name the one it replaces or merges with. A skill nobody used in two retros is a candidate to remove.
- Skills stay short (a `SKILL.md` well under ~80 lines; stack packs under ~40). Prefer replacing text over adding it.

## 1. Measure
- `kit stats --all --days 30` (and the previous period with `--days 60` for comparison). Note per project: merged PRs, median hours to merge, median PR size, review blockers per PR, CI failure rate, bugs/regressions opened, lessons, security findings.
- Token and cost totals if the owner provides them (Claude Code / Codex usage reports).
- Read last retro's summary (latest closed issue labelled `retro` in this repo) for the targets it set.

## 2. Collect what went wrong
- Friction: `gh issue list -R <owner>/agent-kit --label friction --state open --json number,title,body`.
- Lessons: in each active project (the repos `kit stats --all` listed: folders under `~/GIT` whose `AGENTS.md` says `Mode: product` or `prototype`), `gh issue list --label lesson --state all --search "updated:>=<30 days ago>" --json number,title,body,comments`.
- Review findings: blocker comments from the reviewer (`Verdict: BLOCKED`) — what kinds of problems recur?

## 3. Find patterns
Group findings. A pattern needs **2+ occurrences**. For each, decide where the fix belongs:
| Pattern is about | Fix |
|---|---|
| One project's code | A test or lint rule in that project (open an issue there with the proposal) |
| A technology, seen in 2+ projects | A line in `stacks/<tech>.md` |
| How agents work (skipped step, wrong order, unclear skill) | Change to a skill or `AGENTS.md` |
| A rule that is now enforced by a test | Remove the text version (**retire**) |

## 4. Check last month's changes
For each change the last retro made: did its target number move? If not after two retros, propose reverting or rethinking it.

## 4b. Keep the knowledge packs current
Pick one or two packs in `stacks/` (oldest reviewed first, or those behind this month's lessons). Check them against the current official docs named in their Standards line (search the web; do not rely on memory). Outdated or wrong advice → a correction counts as one of this retro's proposals.

## 5. Propose
- Branch `retro/<yyyy-mm>`, make the ≤3 changes, open a PR titled `chore(retro): <yyyy-mm>` with, per change: evidence (links), the change, the metric and target.
- Project-level proposals → issues in those projects (label `lesson`), linked from the PR.
- Close friction issues that the PR resolves (`Closes #…`); comment on the rest why not now.
- Open an issue labelled `retro` in this repo with the metrics table and the targets for next month (that is next retro's baseline).
