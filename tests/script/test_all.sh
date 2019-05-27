#!/bin/bash

interval=10
repeat=3000

./cpu_usage.sh $interval $repeat &
./power_consumption.sh $interval $repeat &
./app_manager.sh

cut -d' ' -f2 ../plot/data_logical.dat | paste -d' ' ../plot/power_consumption.dat - > ../plot/xyz.dat
awk '{print $3,$2}' ../plot/xyz.dat > ../plot/cpu_usage_power.data