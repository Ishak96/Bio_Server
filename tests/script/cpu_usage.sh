#!/bin/bash

sleepDurationSeconds=$1
numberOfsnap=$2

i=0
x=0
zero=0

#command to get the number of core
CORE_NUMBER=$(grep -c ^processor /proc/cpuinfo)
#put the interval and the number of cors into a string
INTERVAL="interval=$1 -- number of cors=$CORE_NUMBER"
echo $INTERVAL > ../log/cpu_usage.log

while [ $i -lt $numberOfsnap ]
do
    previousStats=$(cat /proc/stat)

    sleep $sleepDurationSeconds

    currentDate=$(date "+%Y-%m-%d %H:%M:%S")

    CPU_USAGE="----------------$currentDate----------------\n BEGIN\n"

    currentStats=$(cat /proc/stat)    

    cpus=$(echo "$currentStats" | grep -P 'cpu' | awk -F " " '{print $1}')

    if [ $i -eq $zero ]; then
        tmp="t $cpus"
        echo  $tmp > ../plot/data_logical.dat
    fi

    data_plot="$x"
    for cpu in $cpus
    do
        currentLine=$(echo "$currentStats" | grep "$cpu ")
        user=$(echo "$currentLine" | awk -F " " '{print $2}')
        nice=$(echo "$currentLine" | awk -F " " '{print $3}')
        system=$(echo "$currentLine" | awk -F " " '{print $4}')
        idle=$(echo "$currentLine" | awk -F " " '{print $5}')
        iowait=$(echo "$currentLine" | awk -F " " '{print $6}')
        irq=$(echo "$currentLine" | awk -F " " '{print $7}')
        softirq=$(echo "$currentLine" | awk -F " " '{print $8}')
        steal=$(echo "$currentLine" | awk -F " " '{print $9}')
        guest=$(echo "$currentLine" | awk -F " " '{print $10}')
        guest_nice=$(echo "$currentLine" | awk -F " " '{print $11}')

        previousLine=$(echo "$previousStats" | grep "$cpu ")
        prevuser=$(echo "$previousLine" | awk -F " " '{print $2}')
        prevnice=$(echo "$previousLine" | awk -F " " '{print $3}')
        prevsystem=$(echo "$previousLine" | awk -F " " '{print $4}')
        previdle=$(echo "$previousLine" | awk -F " " '{print $5}')
        previowait=$(echo "$previousLine" | awk -F " " '{print $6}')
        previrq=$(echo "$previousLine" | awk -F " " '{print $7}')
        prevsoftirq=$(echo "$previousLine" | awk -F " " '{print $8}')
        prevsteal=$(echo "$previousLine" | awk -F " " '{print $9}')
        prevguest=$(echo "$previousLine" | awk -F " " '{print $10}')
        prevguest_nice=$(echo "$previousLine" | awk -F " " '{print $11}')    

        PrevIdle=$((previdle + previowait))
        Idle=$((idle + iowait))

        PrevNonIdle=$((prevuser + prevnice + prevsystem + previrq + prevsoftirq + prevsteal))
        NonIdle=$((user + nice + system + irq + softirq + steal))

        PrevTotal=$((PrevIdle + PrevNonIdle))
        Total=$((Idle + NonIdle))

        totald=$((Total - PrevTotal))
        idled=$((Idle - PrevIdle))

        if [ $totald -eq $zero ]; then
            CPU_Percentage="0"
        else
            CPU_Percentage=$(awk "BEGIN {print ($totald - $idled)/$totald*100}")    
        fi

        CPU_USAGE="$CPU_USAGE\t\t$cpu $CPU_Percentage%\n"
        data_plot="$data_plot $CPU_Percentage"
    done
    
    CPU_USAGE="$CPU_USAGE DONE"

    echo $CPU_USAGE >> ../log/cpu_usage.log
    echo $data_plot >> ../plot/data_logical.dat
    
    i=$(($i + 1))
    x=`echo "$x + $sleepDurationSeconds" | bc -l`
done