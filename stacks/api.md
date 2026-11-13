# Problem pack: HTTP APIs (any backend with routes)

**Standards:** HTTP semantics (RFC 9110) for methods and status codes; REST resource conventions; RFC 9457 "Problem Details" as a model for error bodies; OpenAPI (openapis.org) when the API is documented or public.

## Shape
- Resources are nouns, plural: `GET /loans`, `GET /loans/:id`, `POST /loans`, `PATCH /loans/:id`, `DELETE /loans/:id`. Actions that do not fit: `POST /loans/:id/close`.
- `GET` never changes anything. `PUT`/`DELETE` are safe to repeat. `POST` that creates money movement, emails or records accepts an idempotency key so a retry does not do it twice.
- Consistent field names and formats across endpoints: ISO 8601 dates in UTC, money as integer minor units or decimal strings with a currency, ids as strings.

## Status codes and errors
- 200/201/204 for success; 400 invalid input; 401 not signed in; 403 not allowed; 404 not found (also for records the user may not see); 409 conflict; 422 validation; 429 rate limited; 5xx only for our own failures.
- One error shape everywhere: a stable machine code, a human message, and per-field details for validation. No stack traces, SQL or internal names.

## Behaviour
- Validate every body, query and path parameter against a schema; reject unknown fields on writes.
- Authenticate and authorise in every route (see the security pack). Rate-limit anything expensive or abusable.
- Lists are paginated with a default and a maximum page size; filtering and sorting only on allowed fields.
- Timeouts on every outgoing call; retries only for idempotent operations, with backoff.
- Changing a response in a way that breaks existing clients needs a new version or a migration period.

## Operating it
- Log each request with a request id, the user id, status and duration; no bodies with personal data.
- A health endpoint that checks real dependencies. Document new or changed endpoints where the project keeps its API docs.
