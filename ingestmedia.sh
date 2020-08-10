#!/bin/bash

# This script should be run as root.

# Intended to be run as a cron job that
# checks the given directory for new movies
# and copies them to the configured directory.
# Additionally can also run a task after the
# copy. E.g., triggering a refresh of the plex
# library or sending an email.

# Checks for new folders and copies those that
# contain a .ready file and !contain a .copied
# file.
# After copy, a .copied file is created in the
# folders to indicate that the copy was done
# successfully.
# The status files are removed from the destination.


pms=/snap/plexmediaserver/current/Plex\ Media\ Scanner

inputmovies=/mnt/raid/transfer/plex/movies
outputmovies=/mnt/raid/media/movies

inputmusicen=/mnt/raid/transfer/plex/music/english
inputmusichi=/mnt/raid/transfer/plex/music/hindi
outputmusicen=/mnt/raid/media/music/english
outputmusicen=/mnt/raid/media/music/hindi


# Copy media function $1 = input, $2 = output
copymedia() {
    ret=0
    cd /"$1"
    for d in */; do
        if [ -e "$d"/.ready -a ! -e "$d"/.copied ]; then
            cp -r -f -v "$d"/ "$2"
            if [ "$?" -eq "0" ]; then
                touch "$d"/.copied
                rm "$2"/"$d"/.ready
                ret=1
            fi
        fi
    done
    return $ret
}

echo $(date)

# Copy new movies copymedia(inputdir, outputdir)
echo "Copying movies..."
copymedia $inputmovies $outputmovies
moviesret=$?

# Copy new music
echo "Copying music..."
copymedia $inputmusicen $outputmusicen
enmusicret=$?

copymedia $inputmusichi $outputmusichi
himusicret=$?

#if [ "$moviesret" -eq "1" ]; then
    #"$pms" -scan --refresh --directory "$outputmovies"
#fi

#if [ "$enmusicret" -eq "1" ]; then
    #"$pms" --scan --refresh --directory "$outputmusicen"
#fi

#if [ "$himusicret" -eq "1" ]; then
    #"$pms" --scan --refresh --directory "$outputmusichi"
#fi

echo "Done"