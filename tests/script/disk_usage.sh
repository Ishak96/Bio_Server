#!/bin/bash
interval=1
repeat=100
zero=0

disks=$(lsblk -io KNAME,TYPE | grep 'disk'| sed -e "s/  */ /g" | cut -d' ' -f1)
disks="total $disks loop"

disk_print_name(){
	currentDate=$(date "+%H:%M:%S")
	date="----  $currentDate  ----"
	echo $date > ../plot/disk_usage.dat

	d="t "
	for disk in $disks
	do
		d="$d $disk"
	done

	echo $d >> ../plot/disk_usage.dat
}

function d_u(){
	x=0
	i=0

	while [ $i -lt $2 ]
	do
		data_disk="$x"

		for disk in $disks
		do
			usage_d=$(df --total -hl | sed -e "s/  */ /g" | grep "$disk" | cut -d' ' -f5 | cut -d'%' -f1)

			tot=0
			div=0
			for value in $usage_d
			do
				tot=$(($tot + $value))
				div=$(($div + 1))
			done
			moy=$(($tot / $div))
			data_disk="$data_disk $moy"
		done

		echo $data_disk >> ../plot/disk_usage.dat

	    i=$(($i + 1))
	    x=`echo "$x + $1" | bc -l`

	    sleep $1
	done

	currentDate=$(date "+%H:%M:%S")
	date="----  $currentDate  ----"
	echo $date >> ../plot/disk_usage.dat
}

disk_print_name

d_u $interval $repeat