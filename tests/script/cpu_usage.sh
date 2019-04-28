#!/bin/bash

x=0
#command to get the number of core
CORS_NUMBER=$(grep -c ^processor /proc/cpuinfo)
#put the interval and the number of cors into a string
INTERVAL="interval=$1 -- number of cors=$CORS_NUMBER"
echo $INTERVAL > ../log/cpu_usage.log
#get the name of the core
NAME_CORS=$(mpstat -P ALL | fgrep ":" | grep -v "%" | grep -v "Moyenne" | awk '{ printf "CORE[%s] ", $2}')
NAME_CORS="t $NAME_CORS"
echo  $NAME_CORS > ../plot/data_logical.dat

j=0
while sleep $1
 do
 	if [ $j -le $2 ]
 	then
		#use date commande to get the actual date
		DATE=$(date "+%Y-%m-%d %H:%M:%S")
		#use mpstat to get an report processors related statistics
		CPU_USAGE=$(mpstat -P ALL 1 1| fgrep ":" | grep -v "%" | grep -v "Moyenne" | awk 'function GSUB(F) {
												gsub(",",".",$F)
											    }

											    {
												GSUB($2);
												GSUB($3);
												GSUB($6);
												GSUB($12);
												v=100-$6-$12;
												printf "[%s %s %s %s %.2f]\\n", $2, $3, $6, $12, v
											   }'
			   		)
		DATA_PLOT=$(mpstat -P ALL 1 1| fgrep ":" | grep -v "%" | grep -v "Moyenne" | awk 'function GSUB(F) {
												gsub(",",".",$F)
											    }

											    {
												GSUB($6);
												GSUB($12);
												printf "%.2f ", 100-$6-$12
											   }'
			   		)
		
		DATA_PLOT="$x $DATA_PLOT"
		CPU_USAGE="---------------$DATE---------------\n BEGIN\n$CPU_USAGE DONE"
		
		echo $CPU_USAGE >> ../log/cpu_usage.log
		echo $DATA_PLOT >> ../plot/data_logical.dat
		
		x=$(($x + $1))
		j=$(($j + 1))
	else
		break;
	fi
 done
