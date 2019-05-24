#!/bin/bash

sleepDurationSeconds=$1
numberOfsnap=$2

i=0
x=0

currentDate=$(date "+%Y-%m-%d %H:%M:%S")
date="----------------$currentDate----------------"
echo $date > ../log/power_consumption.log

while [ $i -lt $numberOfsnap ]
do
    sleep $sleepDurationSeconds

    ipmitool dcmi power reading | sed -e "s/  */ /g" >> ../log/power_consumption.log

    if [ $i -eq 0 ]; then
        tmp="t power"
        echo  $tmp > ../plot/power_consumption.dat
    fi

    power_2="$x"
    watts=$(ipmitool dcmi power reading | sed -e "s/  */ /g" | grep 'Instantaneous power reading' | cut -d' ' -f5)

    
    power_2="$power_2 $watts"

    echo $power_2 >> ../plot/power_consumption.dat
    
    i=$(($i + 1))
    x=`echo "$x + $sleepDurationSeconds" | bc -l`
done
