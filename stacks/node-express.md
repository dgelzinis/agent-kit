# Stack pack: Node.js + Express

**Standards:** Express "Production best practices" for security and performance (expressjs.com), the Node.js docs (nodejs.org/docs), and the Twelve-Factor App (12factor.net) for configuration, logs and processes. For routes see the `api` pack; for auth and input see the `security` pack.

## Requests
- Validate every body, query and param on the server (shared schema/rules where the project has them). Reject unknown fields for writes; whitelist what can be updated.
- Authorization in every route that touches data: who is the user, may they do this to *this* record. Middleware order matters — auth before routes, error handler last.
- Async route errors must reach the error handler (wrap handlers or use a helper); an unhandled rejection is a crash or a hung request.
- Errors to clients: status code + safe message. Details only in server logs. Never echo stack traces, SQL or tokens.

## Security
- Rate-limit sign-in, sign-up, password reset, invites, email sending and any AI or paid-API endpoint.
- Cookies: `HttpOnly`, `Secure`, `SameSite`; redirects only to allowed paths (no open redirects).
- CORS: explicit origins, not `*`, when credentials are used. Security headers on (e.g. helmet).
- Secrets from environment variables only; fail at startup if a required one is missing.

## Reliability
- No silent fallbacks to in-memory or fake data when a dependency fails — log and return an error.
- Timeouts on outgoing HTTP calls; retries only for safe/idempotent operations.
- Webhooks (payments etc.): verify the signature, make handling idempotent (same event twice = same result).
- Money math in integer cents or a decimal library, not floating point; round once, at the end.

## Code
- One module system per package (ES modules: `import`/`export`). Keep `index.js` thin: routes in route files, logic in services.
- `npm` scripts are the interface: add new checks there so agents and CI run the same thing.
