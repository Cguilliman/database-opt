#!/bin/bash

set -e

# Variables
BACKUP_DIR="/backup/incr"
TIMESTAMP=$(date +%Y_%m_%d_%H_%M_%S)
BASE_BACKUP_DIR="$BACKUP_DIR/base_backup"
INCREMENTAL_BACKUP_DIR="$BACKUP_DIR/incremental_backup_$TIMESTAMP"

# Create base backup if it doesn't exist
if [ ! -d "$BASE_BACKUP_DIR" ]; then
    pg_basebackup --dbname=postgresql://u:p@localhost:5432/db -D $BASE_BACKUP_DIR -F t -X stream -P -v -Z 9 --no-password
    echo "Base backup created at $BASE_BACKUP_DIR"
fi

# Create incremental backup
pg_basebackup --dbname=postgresql://u:p@localhost:5432/db -D $INCREMENTAL_BACKUP_DIR -F t -X stream -P -v -Z 9 --no-password --wal-method=fetch
echo "Incremental backup created at $INCREMENTAL_BACKUP_DIR"