---
name: k-refactor
description: Restructure code without changing what it does — tests green before, small steps, tests after each step, nothing else mixed in. Use when the user says /k-refactor or asks to clean up, simplify, split, rename or reorganise code.
---

# /k-refactor — change the structure, not the behaviour

> **Project settings first:** if the project's `AGENTS.md` has `## Skill settings` → `### /k-refactor`, read it and apply it on top of this skill. Settings add steps or tighten rules; they never loosen the kit's Safety rules.

A refactor is done when the code is simpler and every test gives the same result as before.

1. **Scope.** Work from an issue that says what to restructure and why (no issue → create one). State what is in scope and what is not. A refactor is its own pull request: no features, no bug fixes, no dependency upgrades, no formatting of untouched files.
2. **Baseline.** Run the project's lint, build and tests **before changing anything**. Not green → stop and say so; a refactor does not start on red.
3. **Safety net.** Find which tests cover the code you will touch. Thin or missing → first add tests that pin down the current behaviour (including its edge cases), commit them separately, and show they pass on the old code.
4. **Plan the steps** (`/k-plan` for anything beyond one file): a sequence of small moves, each of which leaves everything working. One file or component at a time.
5. **Do one step, then check.** After each step run the relevant tests; after the last, the project's full checks. A test fails → undo that step and take a smaller one. Never edit a test to make it pass, unless the test only checked internal structure (say so in the pull request).
6. **Keep behaviour identical.** Same inputs, same outputs, same errors, same public names and API shapes. Calculations give exactly the same numbers. If a caller must change, change all callers in the same step (`grep` for them).
7. **Found a bug or something else worth changing?** Do not fix it here. Open an issue (label `bug` if it is one) and carry on.
8. **Remove what the refactor made dead** (unused functions, files, imports) and nothing else.
9. **Prove it** in the pull request (`/k-ship`): what moved where, the baseline and final test results, which tests were added first, anything checked by hand, and the issues opened along the way.
