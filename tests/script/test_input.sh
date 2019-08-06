#!/bin/bash
zero=0

function input_dioxine_on_off(){
	for a in 1 3 4 6 10
	do
		number_core=32
		interval=0
		it_tmp=1
		echo "t nbc nbapp" > ../plot/input_dioxine_"$a".dat
		for (( t=0; t<=7500; t++ ))
		do  
			if [ $t -gt 60 ]; then
				if [ $t -lt  3780 ]; then
					if [ $interval -eq $zero ];then
						number_core=$(($number_core - 1))
						interval=120
					else
						interval=$(($interval - 1))
					fi
				else
					if [ $interval -eq $zero ];then
						number_core=$(($number_core + 1))
						interval=120
					else
						interval=$(($interval - 1))
					fi
				fi
			fi
			
			if [ $it_tmp -eq 1 ]; then
				echo "$t $a $number_core" >> ../plot/input_dioxine_"$a".dat
				it_tmp=10
			else
				it_tmp=$(($it_tmp - 1))
			fi
		done
	done
}

function input_glyphosate_on_off(){
	for a in 0 1 3 6 10
	do
		number_core=8
		interval=0
		it_tmp=1
		echo "t nbc nbapp" > ../plot/input_glyphosate_"$a".dat
		for (( t=0; t<=1800; t++ ))
		do  
			if [ $t -gt 60 ]; then
				if [ $t -lt  900 ]; then
					if [ $interval -eq $zero ];then
						number_core=$(($number_core - 1))
						interval=120
					else
						interval=$(($interval - 1))
					fi
				else
					if [ $interval -eq $zero ];then
						number_core=$(($number_core + 1))
						interval=120
					else
						interval=$(($interval - 1))
					fi
				fi
			fi

			if [ $it_tmp -eq 1 ]; then
				echo "$t $a $number_core" >> ../plot/input_glyphosate_"$a".dat
				it_tmp=10
			else
				it_tmp=$(($it_tmp - 1))
			fi
		done
	done
}


input_glyphosate_on_off

input_dioxine_on_off