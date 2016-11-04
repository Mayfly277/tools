#!/bin/bash

######################################################################
# Simple bash tool to launch and monitor one command
# To use this just launch you're command in background like this
# command & ./monitor.sh $!
# or ./monitor.sh <pid>
######################################################################

if [ $? != 0 ]
then
    echo "Usage monitor command" >&2 ;
    exit 1
fi
CMD_PID=$1

FREQUENCE=0.5
echo 'Launch monitoring'

memTotal=$(cat /proc/meminfo |head -1| sed -r 's/MemTotal.\s*([0-9]+) kB/\1/g')

echo "TIME         | CPU % | MEM % | MEM in Mo"
# While process running
while [ -n "$(ps -p $CMD_PID | grep -v "PID TTY")" ]
do
    currentTime=$(date +"%T.%3N")
    stat=$(ps u -p $CMD_PID | tail -1 | sed 's/  */ /g' | sed 's/,/\./g')

    # CPU
    nPercCpu=$(echo $stat| cut -d ' ' -f 3 | sed 's/\./,/g')

    # MEM
    memCalc=$(echo $stat| cut -d ' ' -f 4)
    nPercMem=$(echo "$memCalc" |sed 's/\./,/g')
    memUsage=$(echo "($memTotal*$memCalc)/100000"|bc -l|sed 's/\./,/g')

    # PRINT
    printf "| %s | %3.3f | %3.3f | %3.3f |\n" "$currentTime" "$nPercCpu" "$nPercMem" "$memUsage"
    sleep $FREQUENCE
done
