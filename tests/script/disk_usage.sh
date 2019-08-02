#!/bin/bash
interval=1
repeat=20
zero=0

disks=$(df -H | grep -vE '^Filesystem|tmpfs|cdrom|mmcblk0p1' | sed -e "s/  */ /g" | cut -d' ' -f1 | grep -v 'Sys')
disks="total $disks"

disk_print_name(){
	currentDate=$(date "+%H:%M:%S")
	date="----  $currentDate  ----"
	echo $date > ../plot/disk_usage.dat

	d="t "
	for disk in $disks
	do
		d_tmp=$(echo "$disk" | cut -d'/' -f3)

		d="$d $d_tmp"
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
			d_tmp=$(echo "$disk" | cut -d'/' -f3)

			usage_d=$(df --total -hl | sed -e "s/  */ /g" | grep "$d_tmp" | cut -d' ' -f5)
			
			data_disk="$data_disk $usage_d"
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