#!/bin/bash

#Snort alert log location

alert_file="/var/log/snort/snort.alert.fast"

#execute Shell script location

local_script="/home/gardneny/test.sh"

#Tail the log file and search for the pattern

tail -F $alert_file | while read line; do
if echo "$line" | grep -q "Brute"; then
echo "Alert found: $line"
bash "$local_script"
fi
done
