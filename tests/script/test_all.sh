#!/bin/bash

interval=10
repeat=3000

./cpu_usage.sh $interval $repeat &
./power_consumption.sh $interval $repeat &
./app_manager.sh