#!/bin/bash

set -e

# Variables
PG_HOST="localhost"
PG_PORT="5432"
PG_DATABASE="db"
PG_USER="u"
BACKUP_DIR="/backup/reverse_delta"
FULL_BACKUP_DIR="$BACKUP_DIR/full_backup"
REVERSE_DELTA_DIR="$BACKUP_DIR/reverse_delta_backup_$(date +%Y_%m_%d_%H_%M_%S)"
WAL_ARCHIVE_DIR="$BACKUP_DIR/wal_archive"

# Perform a full backup using pg_dump
pg_dump -h $PG_HOST -p $PG_PORT -U $PG_USER -d $PG_DATABASE -F c -b -v -f "$FULL_BACKUP_DIR/backup.sql" --no-password

# Archive the current WAL files
mkdir -p $WAL_ARCHIVE_DIR
pg_wal_archive_command="cp %p $WAL_ARCHIVE_DIR/%f"
psql -h $PG_HOST -p $PG_PORT -U $PG_USER -d $PG_DATABASE -c "SELECT pg_switch_wal();" --no-password

# Copy the changes since the full backup to the reverse delta directory
rsync -a --compare-dest=$FULL_BACKUP_DIR "$FULL_BACKUP_DIR/" "$REVERSE_DELTA_DIR/"

echo "Reverse Delta backup created at $REVERSE_DELTA_DIR"