#!/bin/bash
IFS=$'\n'

NOW=$(date +"%Y-%m-%d")
logfile=/scripts/logs/log-$NOW.log

# Use a lockfile containing the pid of the running process
# If script crashes and leaves lockfile around, it will have a different pid so
# will not prevent script running again.
# 
lf=/scripts/PostProcessingComskip.pid
# create empty lock file if none exists
cat /dev/null >> $lf
read lastPID < $lf
# if lastPID is not null and a process with that pid exists , exit
[ ! -z "$lastPID" -a -d /proc/$lastPID ] && exit
echo processAllTv.sh not running so I will continue with pid $$ > $logfile 2>&1
# save my pid in the lock file
echo $$ > $lf
# sleep so plex can finish moving files...
sleep 15

for f in $(find /TvShows -name '*.ts' -o -name '*.mkv'); do
  filename=$(basename "$f")
  extension="${filename##*.}"
  filename="${filename%.*}"
  directory=$(dirname "$f")
  #echo $f and $directory/$filename.edl
  processedName="$directory/$filename.edl"
  if  [ ! -f $processedName ]; then
    echo $processedName does not exist! >> $logfile 2>&1
    /scripts/Comskip/comskip --ini=/scripts/Comskip/comskip.ini $f >> $logfile 2>&1
    # Now we know about commercials, let's cut them out
    # comchap from https://github.com/BrettSheleski/comchap
    /scripts/comchap/comcut --keep-edl --ffmpeg=/usr/bin/ffmpeg --comskip=/scripts/Comskip/comskip --lockfile=/scripts/comchap.lock --comskip-ini=/scripts/Comskip/comskip.ini "$f" "/tmp/${filename}.${extension}" >> $logfile 2>&1
    sleep 5
    # Re-encode as an mp4 file so we keep the original
    /usr/bin/ffmpeg -i "/tmp/${filename}.${extension}" -acodec copy -vcodec copy "${directory}/${filename}.mp4" >> $logfile 2>&1
  fi
done

# We need to do some cleanup!!!
