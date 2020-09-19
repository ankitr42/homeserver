#!/bin/bash

# This script should be run as root.
# 

# Photo Album Paths
# Albums folders should not have any sub-folders
# photos=/mnt/raid/cloud/ankit/files/Photos
photos=./Photos
mailto=ankitr.42@gmail.com
logdir=./photos-backup/
logfile=${logdir}/photos-$(date -I).log

mkdir --parents $logdir

startup=$(</proc/uptime awk '{print $1}')
shutdownwhendone=$(echo "$startup < 420" | bc -l)

# 1-Way copy, no-delete, create new albums by foldernames
rclone copy $photos gphotos-test:album -P --log-file=${logfile} -v

if [ $? -eq 0 ]; then
    parsedlog=$(<${logfile} grep 'Transferred')
    echo $parsedlog | mail -s "Photo Backup Success" "$mailto"
else
    echo "Failed" | mail -s "Photo Backup Error" -A $logfile  "$mailto"
fi

