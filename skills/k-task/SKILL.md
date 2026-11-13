---
name: k-task
description: Turn a rough idea, complaint or request into a clear task — what and why, checkable "done when" points, out of scope, size — and create the GitHub issue after the owner's OK. Use when the user says /k-task, describes something they want without an issue, or asks for help writing a good prompt or task.
---

# /k-task — from a rough idea to a task nobody can misread

> **Project settings first:** if the project's `AGENTS.md` has `## Skill settings` → `### /k-task`, read it and apply it on top of this skill. Settings add steps or tighten rules; they never loosen the kit's Safety rules.

You write the task; building happens in the skills that follow. This is checkpoint 1 of 3.

1. **Listen.** Take the request as given, in any language and however rough. Restate it in one sentence to check you understood.
2. **Look before you ask.** Search the code, the project's `AGENTS.md`, its design and voice docs, open issues (`gh issue list --search "<keywords>"`) and past lessons (`--label lesson`) for what already answers the open points. An existing issue covers it → say so and offer to update that one instead.
3. **Ask only what is still unclear:** at most 4 short questions, each with a suggested answer where you can. Typical gaps: who it is for; what "done" looks like to the owner; what must not change; how urgent. Nothing unclear → ask nothing.
4. **Write the task** in the project's issue template:
   - **Title:** the outcome, in plain words (not the solution).
   - **What and why:** 2–4 sentences. The problem and who has it; evidence if there is any (feedback, a number, an error).
   - **Done when:** 2–5 points the owner can check by looking or by a test. Each one observable ("the remaining balance is the first number in each loan card, on phone and desktop"), none vague ("works well", "is improved").
   - **Out of scope:** what this deliberately does not do, especially the things an eager agent would add.
   - **Depends on / Notes:** related issues, design docs, screenshots.
   - Describe the outcome, not the implementation, unless the owner asked for a specific approach.
5. **Check the size.** S (under an hour), M (half a day), L (bigger). L → propose a split into smaller tasks that each deliver something visible, and say which comes first.
6. **Name the kind and the next skill:** feature → `/k-plan`, then `/k-code build`; bug → `/k-code fix`; cleanup → `/k-code refactor`; wording → `/k-content`; schema → `/k-code database`. Suggest labels (`bug`, `security`).
7. **Show the draft and wait.** Apply corrections. After the OK: pipe the body to `gh issue create --title "…" --body-file -` (plus labels), and give the issue number. Then continue with the next skill from step 6 without waiting to be asked (for a feature: branch, then `/k-plan`). Stop here instead if the owner only wanted the task written down ("just the task", building a backlog, several tasks in a row).

## /k-task quick <request>
No issue. Rewrite a one-off request for the current session as a clear instruction: goal, the facts that matter, what "done" looks like, what not to touch. Show it, and on OK carry it out. Use it for small things that do not deserve an issue; in `product` mode anything that changes behaviour still gets an issue.
