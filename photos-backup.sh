#!/bin/bash

# This script should be run as root.
# 

# Photo Album Paths
# Albums folders should not have any sub-folders
photos=/mnt/raid/cloud/ankit/files/Photos
mailto=ankitr.42@gmail.com
logdir=./photos-backup
logfilename=photos-$(date -I).log
logfile=$logdir/$logfilename

mkdir --parents $logdir

startup=$(</proc/uptime awk '{print $1}')
shutdownwhendone=$(echo "$startup < 420" | bc -l)

# 1-Way copy, no-delete, create new albums by foldernames
rclone copy $photos gphotos-ankit:album -P --log-file=$logfile -v

if [ $? -eq 0 ]; then
    # Send a summary mail when successful.
    parsedlog=$(<$logfile grep 'Transferred')
    echo $parsedlog | mail -s "Photo Backup Success" "$mailto"
else
    # Send the error log when failed.
    echo "Failed" | mail -s "Photo Backup Error" --content-filename=$logfilename --content-type=text/plain -A $logfile  "$mailto"
fi

if [ $shutdownwhendone -eq 1 ]; then
    echo 'Powering off'
    poweroff
fi