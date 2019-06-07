set key autotitle columnhead

set xtics axis
set ytics axis
set border 0
set grid back ls 12

set xrange [0:3000]
set yrange [125:165]
set tics font ", 25"
set key font ",20"
set ytics 1
set xtics 120

set lmargin 12

set xlabel "Time (S)" font "Helvetica, 30" offset 0,-1,0
set ylabel "power consumption (watts) " font "Helvetica, 30" offset -2,0,0

set title "the power consumption of dioxine" font "Helvetica, 30"
set terminal png size 3000,1500;
set output 'power_consumption_dioxine.png'

plot for[n=2:2] 'power_consumption.dat' u 1:n with lines lw 4
# plot 'cpu_usage_power_glyphosate.data' using 1:2 title "Glyphosate" w l lw 4, \
	 'cpu_usage_power_dioxine.data' using 1:2 title "Dioxine" w l lw 4