#!/bin/sh
# -*- mode: sh; -*- vim: ft=sh:ts=2:sw=2:norl:et:
# Time-stamp: <2025-07-27 19:31:02 cf>
# Box: cf [Linux 6.15.6-zen1-1-zen x86_64 GNU/Linux]

# Set backup directories
BACKUP_TARGET="$HOME/Documents/Backups/4-sys/"
BACKUP_DIR="/var/local/sys/backups/"
BACKUP_DATE=$(date +"%Y-%m-%d")
BACKUP_NAME="syscfg_$BACKUP_DATE.tar.gz"
BACKUP_PATH="$BACKUP_DIR/$BACKUP_NAME"
REMOTE_BACKUP="slw:~/Backups/"

# Ensure backup directory exists
mkdir -p "$BACKUP_DIR"

# Create daily backup archive
tar -zcvf "$BACKUP_PATH" -C "$BACKUP_TARGET" .

# Sync backup to remote host
rsync -avz "$BACKUP_PATH" "$REMOTE_BACKUP"

# Cleanup old local backups (older than 7 days)
find "$BACKUP_DIR" -type f -mtime +7 -delete

# Cleanup old files in backup target (older than 1 day)
find "$BACKUP_TARGET" -type f -mtime +1 -delete
