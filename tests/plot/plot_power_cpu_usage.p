set xtics axis
set ytics axis
set border 0
set grid back ls 12

set xrange [0:65]
set yrange [125:165]
set tics font ", 25"
set key font ",20"
set ytics 1
set xtics 5

set lmargin 12

set xlabel "Charge og the CPU's (%)" font "Helvetica, 30" offset 0,-1,0
set ylabel "Power consumption (watts) " font "Helvetica, 30" offset -2,0,0

set title "The power consumption by the charge of the CPU (Dioxine)" font "Helvetica, 30"
set terminal png size 3000,1500;
set output 'power_cpu_usage.png'

plot for[n=2:2] 'cpu_usage_power.data' u 1:n with line lw 4 title "Dioxine charge-decharge"