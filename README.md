# Production Database Migration & Backup Strategy Capstone

A PostgreSQL sample project for an inventory and sales system. It demonstrates versioned up/down migrations, audit logging, stored procedures, a materialized analytical view, and a practical backup/restore guide.

## Requirements
- PostgreSQL 14+ (15+ recommended)
- `psql` command-line client

## Repository layout
- `migrations/`: ordered, reversible schema/data changes
- `procedures/`: business procedure and audit trigger
- `views/`: materialized view for sales analytics
- `scripts/`: refresh and backup/restore helpers
- `docs/`: disaster recovery runbook

## Apply migrations
Run from the repository root, against a development database:

```bash
psql -v ON_ERROR_STOP=1 -d inventory_capstone -f migrations/001_initial_schema.up.sql
psql -v ON_ERROR_STOP=1 -d inventory_capstone -f migrations/002_audit_and_sales.up.sql
psql -v ON_ERROR_STOP=1 -d inventory_capstone -f migrations/003_analytics_view.up.sql
```

To roll back, execute the corresponding `.down.sql` files in reverse order (003, 002, 001). Back up first; down migrations can remove data or objects.

## Example
```sql
CALL record_sale(1, 2, 3, 19.99);
REFRESH MATERIALIZED VIEW sales_daily_summary;
SELECT * FROM sales_daily_summary ORDER BY sale_date DESC;
```

The example call assumes product ID 1, customer ID 2, quantity 3, and unit price 19.99 exist.

## Proof checklist
- [ ] Run all up migrations successfully
- [ ] Insert/update a product and verify `audit_log`
- [ ] Run `record_sale` and verify inventory decreases
- [ ] Refresh and query `sales_daily_summary`
- [ ] Create a custom-format backup and test restoring it into a separate database
- [ ] Add terminal screenshots and notes to this README before submission

## Safety
Use a disposable practice database. Do not run down migrations or restore commands against production data without review and a verified backup.
