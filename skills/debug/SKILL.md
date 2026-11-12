---
name: debug
description: Fix a bug the reliable way — reproduce it, capture it in a failing test, fix the cause, prove it with the test. Use when the user says /debug or reports something broken.
---

# /debug — reproduce, test, fix, prove

Do not guess-and-patch. A bug is fixed when a test that failed now passes.

1. **Understand the report.** From the issue or the user: what happened, what was expected, where (page, endpoint, data), since when. Missing a step to reproduce → ask one precise question.
2. **Check history first.** `gh issue list --label lesson --state all --search "<area>"`, and the project's history docs if any (e.g. `docs/history/`). A repeat bug usually has a known cause.
3. **Reproduce.** Smallest way that shows it: a unit test, a script, a request, or the browser. Write down the exact steps and the actual vs expected result.
4. **Failing test.** Add a test that fails for exactly this reason (name it after the behaviour, e.g. `REGRESSION: …`). Run it and show it fails.
5. **Find the cause.** Trace from the symptom to the root cause; read only the code on that path. State the cause in one or two sentences before changing anything.
6. **Fix the cause, not the symptom.** Smallest change that makes the test pass. Look for the same mistake elsewhere (`grep` the pattern) and list other occurrences.
7. **Prove it.** The new test passes, the project's full checks pass (lint, build, tests).
8. **Record it** on the issue (`gh issue comment`): symptom → cause → fix → test name → prevention. Label the issue `bug` (and `regression` if it worked before). If this kind of bug can come back elsewhere, add the label `lesson` and propose where the prevention belongs (test/lint rule, project Rules, stack pack).
9. Continue with `/ship`.
