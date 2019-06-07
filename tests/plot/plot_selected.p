set key autotitle columnhead

set xtics axis
set ytics axis
set border 0
set grid back ls 12

set xrange [0:3000]
set yrange [0:110]
set tics font ", 25"
set key font ",20"
set ytics 10
set xtics 120

set xlabel "Time (S)" font "Helvetica, 30" offset 0,-1,0
set ylabel "Charge of the CPU's (%)"  font "Helvetica, 30" offset -2,0,0

set title "CPU usage of dioxine server (cpu avg)" font "Helvetica, 30"
set terminal png size 3000,1500;
set output 'core_dioxine_cpu.png'

plot for[n=2:2] 'data_physical_cpu.dat' u 1:n with lines lw 4