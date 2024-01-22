#!/bin/bash

set -e

# Variables
BACKUP_DIR="/backup/full"
TIMESTAMP=$(date +%Y_%m_%d_%H_%M_%S)
BACKUP_FILE="$BACKUP_DIR/full_backup_$TIMESTAMP.sql"

# Create backup
pg_dump --dbname=postgresql://u:p@postgres:5432/db -F c -b -v -f $BACKUP_FILE

echo "Backup completed and saved to $BACKUP_FILE"