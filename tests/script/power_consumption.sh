#!/bin/bash

min_interval=0.5
min_repeat=60
san_chek=0
time=0
i=0

function sanity_check {
	san_chek=1
	value_interval=$1
	if (( $(bc -l <<< "${value_interval/e/E} >= ${min_interval/e/E}") ))
	 then
	 	mult=$(bc <<<"$value_interval * $2")
	 	if (( $(bc -l <<< "${mult/e/E} < ${min_repeat/e/E}") ))
	 	 then
	 	 	repeat_sug=$(bc <<<"$min_repeat / $value_interval")
	 	 	echo "Number of readings should be at least $repeat_sug."
	 	 	san_chek=0
	 	fi
	else
		echo "invalid interval value must be greater than 0.5"
		san_chek=0
	fi
}

while [ $san_chek -eq 0 ]
 do
	read -p "interval / n° of repetitions:" interval repeat
	sanity_check $interval $repeat
done

echo "OK ...";

currentDate=$(date "+%Y-%m-%d %H:%M:%S")
currentDate="----------------$currentDate----------------"
echo $currentDate > ../log/power_consumption.log


powerstat -R $interval $repeat | grep -v [A-Za-z] | grep -v - | sed -e "s/  */ /g" | cut -d" " -f10 >> ../log/power_consumption.log

input="../log/power_consumption.log"
while IFS= read -r line
do
	if [ $i -eq 0 ]; then
		new_line="t power"
		printf "$new_line\n" > ../plot/data_power.dat
	elif [ $i -gt 1 ]; then
		new_line="$time $line"  	
		printf "$new_line\n" >> ../plot/data_power.dat
		time=`echo "$time + $interval" | bc -l`
	fi
	i=$(($i + 1))
done < "$input"