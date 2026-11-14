# Agent Kit

**A reusable operating system for AI-assisted software development.**

Agent Kit brings shared engineering rules, repeatable workflows, technology guidance and quality checks to the coding agents you use across projects.

It is designed for developers who work with more than one agent or codebase and want consistent ways to plan, build, review and ship software — without copying a different pile of instructions into every project.

## What it provides

- **Shared agent instructions** — one set of working rules for Claude Code, Codex and Gemini CLI.
- **Reusable skills** — structured workflows for planning, implementation, design, testing, security, reviews, releases and handoffs.
- **Project-specific context** — each repository keeps its own architecture, stack, commands and product rules.
- **Technology knowledge packs** — focused guidance for tools and recurring engineering concerns.
- **Practical safeguards** — optional pre-commit checks for secrets and direct commits to protected branches.
- **Continuous improvement** — capture recurring lessons and friction, then improve the shared workflow.

## How it is organised

Agent Kit uses three layers. Project-specific instructions take precedence where they add detail, while the shared safety rules remain in force.

| Layer | Contents | Purpose |
|---|---|---|
| **Kit** | `AGENTS.md`, `skills/` | Shared working principles, safeguards and workflows |
| **Knowledge packs** | `stacks/` | Focused technology and problem guidance |
| **Project** | `<project>/AGENTS.md` | Project facts, architecture, commands and local conventions |

The kit is linked into supported agent environments rather than copied. Updating a skill or shared rule makes it available in the next agent session.

## Coding agent integrations

| Agent | Global instructions installed by the kit | Skill discovery |
|---|---|---|
| Claude Code | `~/.claude/CLAUDE.md` | `~/.claude/skills/`; invoke with `/k-…` |
| OpenAI Codex | `~/.codex/AGENTS.md` | `~/.agents/skills/`; use `$k-…` or `/skills` |
| Gemini CLI | `~/.gemini/GEMINI.md` | `~/.agents/skills/`; inspect with `gemini skills list --all` or `/skills list` |

All 15 skill entry files were checked for valid `name` and `description` frontmatter, with names matching their skill directories. The installer uses the documented user-level skill locations, including the shared `~/.agents/skills/` location supported by Codex and Gemini CLI.

The skill format and discovery paths follow the vendors' published conventions: [Claude Code skills](https://code.claude.com/docs/en/skills), [Codex skills](https://learn.chatgpt.com/docs/build-skills), and [Gemini CLI Agent Skills](https://geminicli.com/docs/cli/skills/). The installer smoke test does not launch the agent applications, so verify skill visibility in each installed client after installation.

Agent Kit's core workflows are plain Markdown and shell scripts. Claude Code and Gemini CLI have been manually tested by the maintainer. Codex integration is documented but has not been runtime-tested by the maintainer; treat it as experimental until independently verified.

## Quick start

### Requirements

- macOS or Linux with a POSIX-compatible shell
- Git
- Node.js (required by the installer and `kit stats` helper)
- GitHub CLI (`gh`) for issue, pull-request and workflow commands
- One or more supported coding agents

### Install

Clone it to the default location used by the included skills and templates:

```sh
mkdir -p ~/GIT
git clone https://github.com/dgelzinis/agent-kit.git ~/GIT/agent-kit
cd ~/GIT/agent-kit
sh install.sh
```

The current skill instructions refer to `~/GIT/agent-kit`. If you choose a different location, update those references before relying on the workflows.

The installer links the shared rules and skills into supported agent directories, installs the `kit` helper, and merges Claude Code permission rules into its settings.

Before running it, read [what the installer changes](docs/GUIDE.md#3-first-time-setup-once-per-computer). The installer may create or update files in your home directory. Existing files it replaces are backed up under `~/.agent-kit-backup/`.

Start a new agent session after installation.

### Add Agent Kit to a project

Open the target repository in your coding agent and run:

```text
/ka-project setup
```

The setup workflow inspects the project, proposes a working mode and relevant knowledge packs, and prepares project-level instructions and development templates. Review the proposed changes before accepting them.

## Daily workflow

The default workflow is built around three human approval points:

1. **Task** — agree on the problem and what done means.
2. **Plan** — review the approach before implementation begins.
3. **Result** — inspect the pull request, verification and independent review before merging.

Between those checkpoints, the agent can carry out the agreed work: create a branch, implement, test, run checks and prepare a pull request. Agents do not merge or release without an explicit request.

Start a session with:

```text
/k-next
```

Turn a rough idea into a task:

```text
/k-task users cannot tell how much they still owe
```

See the complete [skill reference and examples](docs/GUIDE.md).

## Included skills

**Development:** `k-next`, `k-task`, `k-plan`, `k-code`, `k-lead`, `k-ship`, `k-review`, `k-handoff`

**Product quality:** `k-design`, `k-content`, `k-security`, `k-marketing`, `k-release`

**Project administration:** `ka-project`, `ka-retro`

Use `kit help` to see the installed skills and their descriptions.

## Safety and boundaries

Agent Kit provides safeguards, not a guarantee that generated code or a repository is secure.

- Review the shared rules and installer before using them.
- Keep API keys, credentials, private data and environment files out of Git.
- Review every proposed command, migration and permission change.
- Run the checks appropriate to your project and review generated changes.
- Keep project-specific secrets and confidential business context outside the shared kit.
- Agents do not merge pull requests or deploy releases unless explicitly instructed.

The pre-commit hook is an additional guardrail. It is not a replacement for secret scanning, code review, repository permissions or CI.

## Documentation

- [Full guide](docs/GUIDE.md)
- [Shared agent rules](AGENTS.md)
- [Knowledge packs](stacks/README.md)
- [Installer](install.sh)
- [Pre-commit hook](hooks/pre-commit)

## Contributing

Bug reports, improvements and additional knowledge packs are welcome. Read [CONTRIBUTING.md](CONTRIBUTING.md) before opening an issue or pull request.

## Security

Please do not report vulnerabilities in a public issue. See [SECURITY.md](SECURITY.md) for responsible disclosure instructions.

## License

Agent Kit is licensed under the [MIT License](LICENSE).
