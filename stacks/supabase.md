# Stack pack: Supabase / PostgreSQL

## Access
- Row-level security is the real boundary. Every table: `ALTER TABLE … ENABLE ROW LEVEL SECURITY` plus explicit policies. No policy = no access for clients (good default); a broad policy = everyone's data.
- "Update own row" policies expose **every column** of that row. Protect server-owned columns (plan, role, billing, flags) with a trigger or column-level grants.
- The service-role key bypasses RLS: backend only, never in frontend code, logs or the browser. The anon key is public by design; RLS is what protects data.
- Policies that check membership through another table: index that table's lookup columns and keep the check in a `SECURITY DEFINER` function with a fixed `search_path` to avoid recursion and slow queries.
- Test access with two real users: user B must not read or change user A's rows.

## Schema changes
- Use `/db-change`. Migrations are files in the repo, numbered, re-runnable; never edit the schema in the dashboard without a matching file.
- A migration in the repo is not a migration applied. Verify it is live (query the table/column) after applying; PostgREST error `PGRST205`/`42P01` means the table is missing.
- After schema changes, PostgREST may need its schema cache reloaded (`NOTIFY pgrst, 'reload schema';`).
- Money: `numeric(14,2)` (or finer), never `float`. Time: `timestamptz`. Dates without time: `date`.

## Client usage
- Always handle `{ data, error }`; an `error` is not an empty result.
- Default page size limits results (often 1000 rows): paginate or aggregate in SQL for anything that can grow.
- Use `.select('needed, columns')`, not `*`, for anything user-facing.
- Auth cookies: clear every domain variant on logout; refresh tokens rotate, store the new one.
