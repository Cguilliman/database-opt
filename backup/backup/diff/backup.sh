#!/bin/bash

set -e

# Variables
PG_HOST="localhost"
PG_PORT="5432"
PG_DATABASE="db"
PG_USER="u"
BACKUP_DIR="backup/diff/"
BASE_BACKUP_DIR="$BACKUP_DIR/base_backup"
DIFFERENTIAL_BACKUP_DIR="$BACKUP_DIR/differential_backup_$(date +%Y_%m_%d_%H_%M_%S)"
WAL_ARCHIVE_DIR="$BACKUP_DIR/wal_archive"

# Create base backup if it doesn't exist
if [ ! -d "$BASE_BACKUP_DIR" ]; then
    pg_basebackup -h $PG_HOST -p $PG_PORT -U $PG_USER -D $BASE_BACKUP_DIR -F t -X stream -P -v -Z 9 --no-password
    echo "Base backup created at $BASE_BACKUP_DIR"
fi

# Archive the current WAL files
mkdir -p $WAL_ARCHIVE_DIR
pg_wal_archive_command="cp %p $WAL_ARCHIVE_DIR/%f"
psql -h $PG_HOST -p $PG_PORT -U $PG_USER -d $PG_DATABASE -c "SELECT pg_switch_wal();" --no-password

# Create a differential backup using the archived WAL files
pg_basebackup -h $PG_HOST -p $PG_PORT -U $PG_USER -D $DIFFERENTIAL_BACKUP_DIR -F t -X stream -P -v -Z 9 --no-password --wal-method=fetch
echo "Differential backup created at $DIFFERENTIAL_BACKUP_DIR"