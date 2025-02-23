#!/bin/bash

# Default values
SOURCE=${1:-/etc}
DESTINATION=${2:-/mnt/storj2TB/backups}
BACKUPS_TO_KEEP=${3:-3}
COMPRESSION=${4:-yes}

# Create a timestamp
TIMESTAMP=$(date +"%Y%m%d%H%M")

# Use rsync to transfer data in destination directory
rsync -arvz --delete $SOURCE $DESTINATION/uncompressed

# If compression is set to yes, create a compressed archive
if [ "$COMPRESSION" = "yes" ]; then
    tar -cjvf $DESTINATION/compressed/$TIMESTAMP.tar.bz2 -C $DESTINATION/uncompressed

fi

# Remove old backups
BACKUP_COUNT=$(ls -l $DESTINATION/compressed/*.tar.bz2 | wc -l)
while [ $BACKUP_COUNT -gt $BACKUPS_TO_KEEP ]
do
    OLDEST_BACKUP=$(ls -t $DESTINATION/compressed/*.tar.bz2 | tail -1)
    rm $OLDEST_BACKUP
    BACKUP_COUNT=$(ls -l $DESTINATION/compressed/*.tar.bz2 | wc -l)
done