#!/bin/bash
cloudname=$(cat /cloudvale|sed "s/,/\n/g"|grep value |sed "s/value='//g" |sed "s/')//g")
threats=$(cat /threats|sed "s/,/\n/g"|grep value |sed "s/value='//g" |sed "s/')//g")
og="progression.log"
match="SEED"

aria2c --dir=/home/$cloudname --input-file=/urls.txt --max-concurrent-downloads=1 --connect-timeout=60 --max-connection-per-server=$threats --split=$threats --min-split-size=1M --human-readable=true --download-result=full --file-allocation=none > "$log" 2>&1 &
pid=$!
while sleep 5
do
    if fgrep --quiet "SEED" "$log"
    then
        kill $pid
        pkill aria2c
        exit 0
    fi
done
