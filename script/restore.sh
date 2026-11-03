#!/usr/bin/env bash
set -euo pipefail
# Usage: ./scripts/restore.sh backup.dump target_database
DUMP_FILE="${1:?Usage: restore.sh backup.dump target_database}"
TARGET_DB="${2:?Usage: restore.sh backup.dump target_database}"
createdb "$TARGET_DB"
pg_restore --dbname="$TARGET_DB" --no-owner --exit-on-error "$DUMP_FILE"
echo "Restore completed into $TARGET_DB"
