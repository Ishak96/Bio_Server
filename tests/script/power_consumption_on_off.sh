#!/bin/bash

sleepDurationSeconds=2
numberOfsnap=275
number_core_physical=8

zero=0

arr_one_full=()

function disable_enable {
	com="/sys/devices/system/cpu/cpu$2/online"
	echo $1 > $com
}

function run_app(){
	i=0
	pid=0
	while [ $i -lt $1 ]
	do
		while true; do true; done &
		pid=$(echo $!)
		arr_one_full+=("$pid")
		i=$(($i + 1))
	done;
}

function kill_app(){
	i=0
	if [ $1 -ne $zero ]; then
		for p in "${arr_one_full[@]}"
		do
			kill $p 2>/dev/null
			unset arr_one_full[$i]
			i=$(($i + 1))
			if [ $i -eq $1 ]; then
				break;
			fi
		done;
	fi
}

function c_u_p_c(){
	x=0
	i=0

	while [ $i -lt $2 ]
	do
		data="$x"
		previousStats=$(cat /proc/stat)
	    sleep $1

	    Power_Consumption=$(ipmitool dcmi power reading | sed -e "s/  */ /g" | grep 'Instantaneous power reading' | cut -d' ' -f5)

	    currentStats=$(cat /proc/stat)    

		currentLine=$(echo "$currentStats" | grep "cpu ")
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

	    previousLine=$(echo "$previousStats" | grep "cpu ")
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

	    data="$data $CPU_Percentage $Power_Consumption"
	    echo $data >> ../plot/c_u_p_c"$3".dat

	    i=$(($i + 1))
	    x=`echo "$x + $1" | bc -l`
	done
}

for i in 0 1 3 6 10
do
	currentDate=$(date "+%H:%M:%S")
	echo  "---- $currentDate ----" > ../plot/c_u_p_c"$i".dat
	echo  "t cpu($i) power($i)" >> ../plot/c_u_p_c"$i".dat

	c_u_p_c $sleepDurationSeconds $numberOfsnap $i &

	sleep 60

	run_app $i

	for j in 1 2 3 4 5 6 7 8 9 10 11 12 13 14
	do
		if [ $j -le 7 ]; then
			core_physical=$(($j + $number_core_physical))
			disable_enable 0 $j
			disable_enable 0 $core_physical
			sleep 30
		else
			activate=$(($j - 7))
			core_physical=$(($activate + $number_core_physical))
			disable_enable 1 $activate
			disable_enable 1 $core_physical
			sleep 30
		fi
	done 

	kill_app $i

	sleep 120

	currentDate=$(date "+%H:%M:%S")
	echo  "---- $currentDate ----" >> ../plot/c_u_p_c"$i".dat

done