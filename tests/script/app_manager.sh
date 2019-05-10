#!/bin/bash

quit=0
help=1

arr_dd=()
arr_rand=()
arr_one_full=()
arr_cat=()

function run_proc {
	pid=0
	i=0
	case $2 in
		e ) ./$1 & ;;
		s ) case $1 in
			dd ) 
				while [ $i -lt $3 ]
				  do
				  	sleep $4
				  	dd if=/dev/zero of=/dev/null &
				  	pid=$(echo $!)
				  	arr_dd+=("$pid")
				  	i=$(($i + 1))
				  done ;;
			rand )
				while [ $i -lt $3 ]
				  do
				  	sleep $4
				  	while true; do echo $((13**99)) 1> /dev/null 2>&1; done &
				  	pid=$(echo $!)
				  	arr_rand+=("$pid")
				  	i=$(($i + 1))
				  done ;;
			one_full ) 
				while [ $i -lt $3 ]
				  do
				  	sleep $4
				  	while true; do true; done &
				  	pid=$(echo $!)
				  	arr_one_full+=("$pid")
				  	i=$(($i + 1))
				  done ;;
			cat ) 
				while [ $i -lt $3 ]
				  do
				  	sleep $4
				  	cat /dev/urandom > /dev/null &
				  	pid=$(echo $!)
				  	arr_cat+=("$pid")
				  	i=$(($i + 1))
				  done ;;
			* ) echo "[app] = [dd|rand|one_full|cat]" ;;
		esac ;;
		* ) echo "invalid argument";;
	esac
}

function kill_proc {
	i=0
	case $1 in
		dd ) case $2 in
			all ) killall dd ;;
			* ) 
				for p in "${arr_dd[@]}"
				 do
				 	sleep $3
				 	kill $p 2>/dev/null
				 	unset arr_dd[$i]
				 	i=$(($i + 1))
				 	if [ $i -eq $2 ]; then
				 		break;
				 	fi
				 done ;;
			esac ;;
		rand ) 
				for p in "${arr_rand[@]}"
				 do
				 	sleep $3
				 	kill $p 2>/dev/null
				 	unset arr_rand[$i]
				 	i=$(($i + 1))
				 	if [ $i -eq $2 ]; then
				 		break;
				 	fi
				 done ;;
		one_full ) 
				for p in "${arr_one_full[@]}"
				 do
				 	sleep $3
				 	kill $p 2>/dev/null
				 	unset arr_one_full[$i]
				 	i=$(($i + 1))
				 	if [ $i -eq $2 ]; then
				 		break;
				 	fi
				 done;;
		cat )
				for p in "${arr_cat[@]}"
				 do
				 	sleep $3
				 	kill $p 2>/dev/null
				 	unset arr_cat[$i]
				 	i=$(($i + 1))
				 	if [ $i -eq $2 ]; then
				 		break;
				 	fi
				 done ;;
		* ) echo "[app] = [dd|rand|one_full|cat]" ;;
	esac
}

while [ $quit -eq 0 ]
 do

 	if [ $help -eq 1 ]; then
 		echo "[*.c | script] [e|s] [run|kill] [Integer] [Integer]"
 		help=0
 	fi

	read -p "Enter your app: [app] [mode] [apply] [repeat] [interval]: " app mode apply repeat interval
	
	case $app in
		quit ) quit=1 ;;
		help ) help=1 ;;
		* ) case $apply in
			run ) run_proc $app $mode $repeat $interval;;
			kill ) kill_proc $app $repeat $interval;;
			* ) help=1 ;;
		esac ;;
	esac
 done