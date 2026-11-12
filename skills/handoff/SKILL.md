---
name: handoff
description: End a session cleanly — save where the work stands on the issue so the next session or agent can continue without re-reading everything. Use when the user says /handoff, is stopping for the day, or the context is getting long.
---

# /handoff — leave the work ready for the next session

The issue is the memory. Write there, not in a markdown ledger.

1. **Save the code state.**
   - Uncommitted work worth keeping → commit it on the branch (`wip: …` is fine) and push.
   - Experiments not worth keeping → say so; do not delete without the user's OK.
2. **Post a handoff comment** on the issue (`gh issue comment <n> --body-file …`), max ~20 lines:
   ```
   ## Handoff — <date>
   **Branch:** <branch> (pushed: yes/no) · **PR:** #<n> or none
   **Done:** what works now, with how it was checked.
   **Next:** the very next step, concrete enough to start without reading the whole thread.
   **Open questions:** decisions waiting for the owner.
   **Watch out:** traps found (file:line), flaky checks, things that looked wrong but are intended.
   ```
3. **Labels:** keep `in-progress` if work continues; remove it if the issue is free for someone else.
4. If the session found a lasting lesson (not specific to this issue), add the label `lesson` to the issue and propose where it belongs: a test, a lint rule, a stack pack, or one line in the project's `AGENTS.md` → Rules. If a kit rule or skill got in the way, open a `friction` issue in agent-kit.
5. Tell the user the next session should start with `/next`, which will pick up this handoff.
