#!/bin/bash

interval=10
repeat=290
zero=0

app_interval=120
app_repeat=10

arr_one_full=()

function run_app(){
	i=0
	pid=0
	while [ $i -lt $1 ]
	do
		while true; do true; done &
		pid=$(echo $!)
		arr_one_full+=("$pid")
		i=$(($i + 1))
		sleep $2
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
			sleep $2
		done;
	fi
}

function c_u_p_c(){
	x=0
	i=0

	while [ $i -lt $2 ]
	do
		data_power="$x"
		data_cpu="$x"

		previousStats=$(cat /proc/stat)
	    sleep $1

	    currentStats=$(cat /proc/stat)

	    cpus=$(echo "$currentStats" | grep -P 'cpu' | awk -F " " '{print $1}')

	    if [ $i -eq $zero ]; then
        	tmp="t $cpus"
        	echo  $tmp > ../plot/data_logical.dat

        	tmp="t power"
        	echo  $tmp > ../plot/power_consumption.dat
    	fi 

    	Power_Consumption=$(ipmitool dcmi power reading | sed -e "s/  */ /g" | grep 'Instantaneous power reading' | cut -d' ' -f5)

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

		    data_cpu="$data_cpu $CPU_Percentage"
	    done

	    data_power="$data_power $Power_Consumption"

	    echo $data_cpu >> ../plot/data_logical.dat
	    echo $data_power >> ../plot/power_consumption.dat

	    i=$(($i + 1))
	    x=`echo "$x + $1" | bc -l`
	done
}

c_u_p_c $interval $repeat &

run_app $app_repeat $app_interval

sleep 300

kill_app $app_repeat $app_interval

sleep 120

cut -d' ' -f2 ../plot/data_logical.dat | paste -d' ' ../plot/power_consumption.dat - > ../plot/xyz.dat
awk '{print $3,$2}' ../plot/xyz.dat > ../plot/cpu_usage_power.data