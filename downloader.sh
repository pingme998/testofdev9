#!/bin/bash
cloudname1=$(cat /cloudvale|sed "s/,/\n/g"|grep value |sed "s/value='//g" |sed "s/')//g")
threats1=$(cat /threats|sed "s/,/\n/g"|grep value |sed "s/value='//g" |sed "s/')//g")
mkdir /tmp/$cloudname1
touch /tmp/$cloudname1/progression.log
log="/progression.log"

match="SEED"

aria2c --dir=/home/$cloudname1 --input-file=/home/$cloudname1/urls.txt --max-concurrent-downloads=1 --connect-timeout=60 --max-connection-per-server=$threats1 --split=$threats1 --min-split-size=1M --human-readable=true --download-result=full --file-allocation=none > "$log" 2>&1 &
pid=$!
while sleep 5
do
clear
cat /progression.log | grep ETA |tail -1
    if grep --quiet 'SEED\|(OK):download completed' "$log"
    then
        pkill aria2c
        exit 0
    fi
done
