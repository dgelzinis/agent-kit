# Mode: build — a new feature, from the approved plan

Build what the plan says, no more. The plan and the issue's "Done when" points are the contract.

1. **Start from the plan.** Re-read the approved plan and the "Done when" points on the issue. No approved plan → `/k-plan` first (except a one-line change).
2. **Branch.** Be on `<issue>-<short-name>`, created from the project's base branch.
3. **Find the pattern.** Before writing something new, find how the project already does the same kind of thing (a similar route, component, hook, test) and follow it. Reuse shared helpers and components; do not add a second way to do something.
4. **Build in small steps,** each of which leaves the project working. Commit at sensible points (Conventional Commit messages).
5. **Tests with the code.** Every "Done when" point that can be tested gets a test. Money, dates, permissions and anything that calculates always do. Tests assert behaviour, not implementation details.
6. **Handle the unhappy paths:** empty and missing data, errors from the network or database, a user without permission, very large values. Missing data is shown as missing, never as zero.
7. **Keep it simple.** No speculative options, layers or settings the task does not need. No new dependency without saying why in the pull request.
8. **Needs a schema change?** Do that part by `modes/database.md`. **Changes what users see?** `/k-design` check before shipping. **Found a bug or a mess nearby?** Open an issue; do not fix it here.
9. **Docs:** update only the docs this change makes wrong (the project's `AGENTS.md` lists which matter).
10. **Verify and ship:** run the project's lint, build and tests until they pass; walk through each "Done when" point and note how it is met; then `/k-ship`.
