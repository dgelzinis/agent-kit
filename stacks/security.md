# Problem pack: security (every project that has users or data)

**Standards:** OWASP Top 10 (owasp.org/Top10) for the common failures; OWASP ASVS (owasp.org/www-project-application-security-verification-standard) as the checklist of what "secure" means; OWASP Cheat Sheet Series (cheatsheetseries.owasp.org) for how to do each thing. `/k-security` reviews against these; this pack is for building it right the first time.

## Access control (the most common serious failure)
- Deny by default. Every route and query checks who the user is **and** whether they may touch *this* record. Enforce it on the server or in the database, never only in the UI.
- Use ids the user cannot guess or swap freely; still check ownership on every access.
- Roles are checked server-side from the session, never from a field the client sends.

## Authentication and sessions
- Use the platform's auth (do not write your own password storage or token scheme). Session cookies: `HttpOnly`, `Secure`, `SameSite`.
- Rate-limit sign-in, sign-up, reset and invite endpoints. Reset and invite links are single-use and expire.
- Log out clears every token and cookie variant.

## Input and output
- Validate on the server against a schema: type, length, range, allowed values. Reject unknown fields on writes.
- Parameterised queries only; never build SQL, shell commands or HTML from strings. Escape output; no raw HTML from user content.
- File uploads: check type and size, store outside the web root, never execute.

## Secrets and data
- Secrets come from the environment or a secret manager; never in code, logs, client bundles or error messages. Rotate any secret that was exposed.
- Collect the least personal data that works; send the least to third parties; encrypt in transit always.
- Errors shown to users say what to do, not how the system works. Details go to server logs, without personal data or tokens.

## Supply chain and configuration
- Keep dependencies patched (`npm audit`, Dependabot); add a dependency only from a maintained, widely used source.
- Production has debug off, security headers on (CSP, HSTS, no sniff), CORS limited to known origins.
- Log security events (sign-ins, permission failures, admin actions) so an incident can be reconstructed.
