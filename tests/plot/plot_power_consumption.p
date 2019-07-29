set key autotitle columnhead

set xtics axis
set ytics axis
set border 0
set grid back ls 12

set xrange [0:2400]
set yrange [90:125]
set tics font ", 25"
set key font ",20"
set ytics 5
set xtics 120

set tics scale 3
set mxtics 6
set mytics 5

set lmargin 12

set xlabel "Time (S)" font "Helvetica, 30" offset 0,-3,0
set ylabel "power consumption (watts) " font "Helvetica, 30" offset -2,0,0

set title "The power consumption (Glyphosate) using ipmi delta = 1" font "Helvetica, 30"
set terminal png size 4000,1500;
set output 'm_power_consumption_glyphosate.png'

# plot for[n=2:2] 'm_power_consumption_grafana_glyphosate.dat' u 1:n with lines lw 4
plot 'm_power_consumption1.dat' using 1:2 title "1 activated core" w l lw 4, \
	 'm_power_consumption2.dat' using 1:2 title "2 activated core" w l lw 4, \
	 'm_power_consumption3.dat' using 1:2 title "3 activated core" w l lw 4, \
	 'm_power_consumption4.dat' using 1:2 title "4 activated core" w l lw 4, \
	 'm_power_consumption5.dat' using 1:2 title "5 activated core" w l lw 4, \
	 'm_power_consumption6.dat' using 1:2 title "6 activated core" w l lw 4, \
	 'm_power_consumption7.dat' using 1:2 title "7 activated core" w l lw 4, \
	 'm_power_consumption8.dat' using 1:2 title "8 activated core" w l lw 4