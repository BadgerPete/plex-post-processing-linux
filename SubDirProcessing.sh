#!/bin/bash
IFS=$'\n'

NOW=$(date +"%Y-%m-%d")
logfile=/scripts/logs/log-$NOW.log

# Use a lockfile containing the pid of the running process
# If script crashes and leaves lockfile around, it will have a different pid so
# will not prevent script running again.
# 
lf=/scripts/SubDirProcessing.pid
# create empty lock file if none exists
cat /dev/null >> $lf
read lastPID < $lf
# if lastPID is not null and a process with that pid exists , exit
[ ! -z "$lastPID" -a -d /proc/$lastPID ] && exit
echo SubDirProcessing not running so I will continue > $logfile 2>&1
# save my pid in the lock file
echo $$ > $lf
# sleep so plex can finish moving files...
sleep 15

for f in $(find /TvShows -name '*.ts'); do
  filename=$(basename "$f")
  extension="${filename##*.}"
  filename="${filename%.*}"
  directory=$(dirname "$f")
  #echo $f and $directory/$filename.edl
  processedName="$directory/$filename.edl"
  if  [ ! -f $processedName ]; then
    echo $processedName does not exist! >> $logfile 2>&1
    /scripts/Comskip/comskip --ini=/scripts/Comskip/comskip.ini $f >> $logfile 2>&1
  fi
done
