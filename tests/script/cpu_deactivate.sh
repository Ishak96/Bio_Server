#!/bin/bash

quit=0
help=1
number_core_physical=32

function disable_enable {
	com="/sys/devices/system/cpu/cpu$1/online"
	echo $2 | sudo tee com
}

function on_cpu {
	case $1 in
		begin )
			i=$2
			while [ $i -le 31 ]; do
				core_physical=$(($i + $number_core_physical))
				disable_enable 1 $i
				disable_enable 1 $core_physical
				i=$(($i + 1))
			done
		;;
		end )
			i=$((31 - $2))
			while [ $i -ge 0 ]; do
				core_physical=$(($i + $number_core_physical))
				disable_enable 1 $i
				disable_enable 1 $core_physical
				i=$(($i - 1))
			done
		;;
		* ) help=1 ;;
	esac	
}

function off_cpu {
	case $1 in
		begin ) 
			i=$2
			while [ $i -le 31 ]; do
				core_physical=$(($i + $number_core_physical))
				disable_enable 0 $i
				disable_enable 0 $core_physical
				i=$(($i + 1))
			done
		;;
		end ) 
			i=$((31 - $2))
			while [ $i -ge 0 ]; do
				core_physical=$(($i + $number_core_physical))
				disable_enable 0 $i
				disable_enable 0 $core_physical				
				i=$(($i - 1))
			done
		;;
		* ) help=1 ;;
	esac
}

while [ $quit -eq 0 ]
 do

 	if [ $help -eq 1 ]; then
 		echo "[on|off] [begin|end] [Integer]"
 		help=0
 	fi

	read -p "Enter your choice:" apply mode number
	
	case $apply in
		quit ) quit=1 ;;
		help ) help=1 ;;
		on ) on_cpu $mode $number;;
		off ) off_cpu $mode $number;;
		* ) help=1 ;;
	esac
 done