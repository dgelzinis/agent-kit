---
name: ka-project
description: Set up and tune a project for the agent-kit. setup brings a repository onto the kit (project AGENTS.md, CLAUDE.md, CI, templates, hook, labels); tune creates or changes the project's Skill settings (security strictness, content voice, design rules, review must-checks, how much control). Use when the user says /ka-project, starts in a repo that is not on the kit, or wants a project to behave differently from the kit defaults.
---

# /ka-project — set up and tune a project

An admin skill: run it only when the owner asks.

| The owner wants… | Mode | Steps in |
|---|---|---|
| this repository brought onto the kit (it has no `AGENTS.md` starting with `Mode:`), or its setup brought up to date | **setup** | `modes/setup.md` |
| this project stricter, softer or different in how a skill behaves; a voice, design rules or review checks recorded | **tune** | `modes/tune.md` |

- `/ka-project setup` and `/ka-project tune` force the mode; `/ka-project tune <skill>` tunes one skill.
- Setup runs tune as one of its steps.
- Read **only** the chosen mode's file, in this skill's folder (`~/GIT/agent-kit/skills/ka-project/modes/<mode>.md`), and follow it.
