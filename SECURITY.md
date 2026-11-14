# Security Policy

Agent Kit includes shell scripts, hooks and instructions that can affect local development environments. Please review the code before installing it and use it with the same care as any third-party developer tool.

## Reporting a vulnerability

Please do not disclose suspected vulnerabilities in a public issue.

Use GitHub's **Report a vulnerability** feature on this repository to send a private report, if it is enabled. Include:

- A description of the affected component and behaviour.
- Steps to reproduce or a proof of concept that does not expose real secrets or personal data.
- The potential impact and any suggested mitigation.

If private vulnerability reporting is unavailable, contact the repository maintainer through their GitHub profile and ask for a private channel.

## Scope

Security reports are especially relevant to:

- `install.sh` and changes to files under the user's home directory.
- `kit` commands and filesystem operations.
- Git hooks and secret-detection patterns.
- Agent permission rules and instructions that affect access to project files.
- Any handling of credentials, environment files or private project data.

Please do not test against systems or data you do not own or have permission to assess.

## Current limitations

The pre-commit hook is a best-effort guardrail, not a complete secret scanner. It can miss secrets and can produce false positives. Agent instructions and permission settings are not a security boundary by themselves. Always use least-privilege credentials, repository protections, code review and provider-side secret scanning where available.
