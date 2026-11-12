---
name: security
description: Security review of a change or a whole app — access control, secrets, input handling, dependencies, AI and payment abuse. Use when the user says /security, before a release of a product-mode project, or on any change touching sign-in, permissions, payments, user data or AI calls.
---

# /security — find what an attacker or a mistake could exploit

Do not edit files. Report findings; fixes go through the normal flow.

## Scope
- `/security` on a branch or PR → the diff against `origin/main`, plus the code it calls.
- `/security app` → the whole project, area by area (start with auth, data access, payments).
Read the project's `AGENTS.md` (Rules, Architecture) and its security docs if listed.

## Check
1. **Access control** — every endpoint and query checks *who* may do *what* on *which* record. Ownership/membership enforced on the server or in the database (e.g. RLS), not only in the UI. New tables/routes get the same protection as old ones. Roles (viewer/editor/admin) cannot escalate.
2. **Authentication & sessions** — cookies (`HttpOnly`, `Secure`, `SameSite`), token expiry, logout clears everything, password reset and invites cannot be reused or guessed.
3. **Input** — validated server-side; no string-built SQL or shell; output escaped (XSS); file uploads type/size-checked; redirects only to allowed URLs.
4. **Secrets** — none in code, logs, client bundles, error messages or git history (`git log -p -S '<key-prefix>'` for suspicious ones). Frontend gets only public keys.
5. **Data exposure** — APIs return only needed fields; errors do not leak internals; personal data not sent to third parties (analytics, AI) without need.
6. **Abuse & cost** — rate limits on sign-in, sign-up, email and AI endpoints; AI prompts cannot be steered into other users' data; spend caps on paid APIs.
7. **Payments** — prices and plan checks on the server; webhooks verify signatures; no trust in client-sent amounts.
8. **Dependencies** — `npm audit --omit=dev` (or the stack's equivalent); note high/critical with a fix path.
9. **Config** — CORS, security headers, debug modes off in production.

## Output
```
## Security review: <scope>
Risk: HIGH | MEDIUM | LOW
### Must fix (exploitable or data at risk) — file:line, scenario, fix
### Should fix (defence in depth)
### Checked, no issue — short list of what was verified
```
Offer to open one GitHub issue per "Must fix" (label `security`).
