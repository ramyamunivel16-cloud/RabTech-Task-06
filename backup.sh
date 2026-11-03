#!/usr/bin/env bash
set -euo pipefail
# Usage: ./scripts/backup.sh database_name [backup_directory]
DB_NAME="${1:?Usage: backup.sh database_name [backup_directory]}"
BACKUP_DIR="${2:-backups}"
mkdir -p "$BACKUP_DIR"
STAMP="$(date -u +%Y%m%dT%H%M%SZ)"
OUT="$BACKUP_DIR/${DB_NAME}_${STAMP}.dump"
pg_dump --format=custom --no-owner --file="$OUT" "$DB_NAME"
sha256sum "$OUT" > "$OUT.sha256"
echo "Backup written: $OUT"
