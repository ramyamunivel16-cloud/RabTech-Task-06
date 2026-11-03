# Backup, Restore & Disaster Recovery Runbook

## Backup policy (sample policy; adapt to your environment)
- Nightly full logical backup using `pg_dump -Fc`.
- Keep daily backups for 7 days and weekly backups for 4 weeks.
- Store a second encrypted copy outside the database host/account.
- Restrict backup access; backups contain the same sensitive data as the database.
- For tighter recovery objectives, configure PostgreSQL physical backups and WAL archiving for point-in-time recovery (PITR).

## Create a backup
```bash
chmod +x scripts/backup.sh scripts/restore.sh
./scripts/backup.sh inventory_capstone backups
```
Verify the checksum:
```bash
sha256sum -c backups/<backup-file>.dump.sha256
```

## Test restore (never overwrite the source database during a test)
```bash
./scripts/restore.sh backups/<backup-file>.dump inventory_restore_test
```
Check tables and row counts:
```bash
psql -d inventory_restore_test -c '\dt'
psql -d inventory_restore_test -c 'SELECT COUNT(*) FROM products;'
```

## Recovery steps
1. Declare the incident and identify the latest known-good backup.
2. Create a clean target database or provision a replacement PostgreSQL instance.
3. Verify backup checksum and access permissions.
4. Restore the dump to the target database.
5. Validate schema, key row counts, constraints, and application queries.
6. If using PITR, restore base backup and replay archived WAL to the selected recovery time.
7. Reconnect application only after validation and approval.
8. Record incident timeline, data-loss window, recovery duration, and follow-up actions.

## Recovery objectives
Document business-approved Recovery Point Objective (RPO: acceptable data loss) and Recovery Time Objective (RTO: acceptable downtime). Example training targets: RPO 24 hours with nightly backups; RTO 2 hours, subject to restore testing and database size.

## Important
A backup is not proven until a restore test succeeds. Keep at least one copy isolated from the primary system and periodically practice this runbook.
