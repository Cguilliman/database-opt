#!/bin/bash

set -e

# Variables
PG_HOST="localhost"
PG_PORT="5432"
PG_DATABASE="db"
PG_USER="u"
BACKUP_DIR="/backup/cdp"
WAL_ARCHIVE_DIR="$BACKUP_DIR/wal_archive"
LATEST_WAL_FILE="$BACKUP_DIR/latest_wal_file"

# Start pg_receivewal in the background
pg_receivewal -h $PG_HOST -p $PG_PORT -U $PG_USER -D $WAL_ARCHIVE_DIR --no-password &

# Capture the latest WAL file
sleep 5  # Adjust this as needed to ensure pg_receivewal has started
ls -1t $WAL_ARCHIVE_DIR | head -n 1 > $LATEST_WAL_FILE

# Regularly check for new WAL files and create backups
while true; do
    sleep 60  # Adjust this interval as needed

    # Check for a new WAL file
    NEW_WAL_FILE=$(ls -1t $WAL_ARCHIVE_DIR | head -n 1)

    if [ "$NEW_WAL_FILE" != "$(cat $LATEST_WAL_FILE)" ]; then
        # Create a backup using rsync or your preferred backup tool
        BACKUP_DIR="$BACKUP_DIR/backup_$(date +%Y%m%d%H%M%S)"
        rsync -a --compare-dest=$WAL_ARCHIVE_DIR "$WAL_ARCHIVE_DIR/" "$BACKUP_DIR/"
        
        # Update the latest WAL file
        echo "$NEW_WAL_FILE" > $LATEST_WAL_FILE

        echo "Backup created at $BACKUP_DIR"
    fi
done