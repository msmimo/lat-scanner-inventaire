# LAT Scanner Inventaire — Project Skeleton

Independent successor to APEX1/APEX2 (see [README.md](README.md) for that system). Same static-HTML-on-GitHub-Pages + Supabase + Resend pattern, but with a full part-lifecycle state machine, mold/seat registry, Huot warehouse module, and audit trail. No login yet (phase 2).

## Structure

| Path | Purpose |
|---|---|
| `index.html` | Dashboard — quick counts by status, links to all modules |
| `scanner.html` | Core flow: pick table + position, scan/type a part, validate status, forced-production override + maintenance type |
| `postes.html` | Grid view of a table's positions and what's currently installed |
| `pieces.html` | Search/filter parts by status, manual status change |
| `entrepot.html` | Warehouse module — mark a part "Chez Huot", soft-delete mis-scanned shipments |
| `historique.html` | History log (filterable, deletable-with-audit) + point-in-time snapshot by table/datetime |
| `config.html` | Minimal admin-lite: create tables, mold/seat numbers (even/odd enforced), positions |
| `shared/api.js` | Supabase config placeholders + fetch helpers + history/audit helpers |
| `shared/style.css` | Shared styles |
| `sql/schema.sql` | Full Postgres schema, RLS policies, notification trigger — run this first in a **new, dedicated Supabase project** |
| `edge-functions/send-notification/index.ts` | Template Edge Function that batches unsent `notifications_attente` rows and emails them via Resend. Needs a cron job (pg_cron) to run periodically, same pattern as the existing APEX `send-history-report` function |

## Setup steps

1. Create a **new Supabase project** (separate from the one backing APEX1/APEX2).
2. Run [`sql/schema.sql`](sql/schema.sql) in the SQL editor.
3. Fill in `SUPABASE_URL` / `SUPABASE_KEY` at the top of [`shared/api.js`](shared/api.js).
4. Open [`config.html`](config.html) and create at least one table, some mold/seat numbers, and positions before using the scanner.
5. Deploy the edge function, set `RESEND_API_KEY` (can reuse the existing verified `rtacoulee.com` domain) and `EMAIL_TO`, and add a pg_cron job calling it every few minutes (mirrors the existing `check-history-notification` job).
6. Host the HTML files on GitHub Pages (or open locally) once the Supabase project is wired up.

## What's implemented (phase 1, per spec)

- Even/odd validation for mold (pair) / seat (impair) numbers, enforced by a DB check constraint.
- Only `Inventaire - Prêt` parts can be installed; anything else triggers an error + forced-production override with mandatory maintenance-type selection.
- Replacing an installed part auto-flips the old one to `Inventaire - À entretenir`.
- Every install/replace/status-change/shipment writes to `historique` (with `debut_statut`/`fin_statut`) and `audit_logs`.
- A DB trigger queues a row in `notifications_attente` on every `historique` insert, ready for the email edge function.
- Point-in-time snapshot lookup by table + datetime.
- Huot warehouse module with soft-delete + audit trail for mis-scans.

## Not yet implemented (phase 2, per Maggie's own priority list)

- Login / role-based permissions (Operator / Supervisor / Magasin / Admin) — currently just a free-text "operator name" prompt stored in `localStorage`.
- Report center / exports.
- Multi-site support.
- Richer admin UI for editing/deactivating existing tables, positions, mold/seat records (currently create-only).
