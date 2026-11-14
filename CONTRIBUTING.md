# Contributing

Thanks for considering a contribution to Agent Kit.

The goal is to make AI-assisted software development more consistent, understandable and safe across projects and coding agents. Contributions should improve a reusable workflow rather than encode assumptions that only make sense in one private codebase.

## Before you start

- Read the [README](README.md) and [full guide](docs/GUIDE.md).
- Search existing issues and pull requests before opening a new one.
- For substantial changes, open an issue first to discuss the problem and intended behaviour.
- Do not include credentials, private project data, customer information or proprietary material in issues or pull requests.

## What makes a good contribution

- A clear problem or user need.
- A small, focused change.
- Instructions that work outside the original author's machine and projects.
- Official documentation or reliable references for technology-specific guidance.
- Verification steps, including what was tested and what remains unverified.

## Pull requests

Please include:

1. **Why** — the problem this change addresses.
2. **What** — the behaviour or documentation changed.
3. **Verification** — commands run and results, or a clear note that it was not tested.
4. **Compatibility** — any effect on Claude Code, Codex, Gemini CLI or existing project setups.
5. **Safety** — any new shell commands, permissions, file operations or handling of sensitive data.

Keep changes focused. Avoid adding dependencies unless they provide clear value. Do not weaken security checks or remove approval points without discussing the trade-off.

## Skills and knowledge packs

- Skills should have a clear trigger, scope, workflow and expected output.
- Keep reusable guidance in `skills/`; keep technology or problem-specific references in `stacks/`.
- Prefer concise, actionable guidance over long generic prompt text.
- Cite authoritative sources when documenting external standards or fast-changing tool behaviour.
- Avoid embedding private project names, local secrets, personal paths or assumptions about a particular employer.

## Code and shell changes

Treat installer and hook changes as security-sensitive. Explain exactly what files are created, modified, removed or backed up. Test on a clean environment where possible, and preserve existing user configuration.

By submitting a contribution, you confirm that you have the right to submit it and that it does not knowingly include third-party material you are not permitted to contribute.
