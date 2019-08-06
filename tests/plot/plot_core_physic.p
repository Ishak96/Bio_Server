set key autotitle columnhead

set xtics axis
set ytics axis
set border 0
set grid back ls 12

set xrange [0:2400]
set yrange [0:110]
set tics font ", 25"
set key font ",20"
set ytics 10
set xtics 120

set lmargin 12

set tics scale 3
set mxtics 6
set mytics 5

set xlabel "Time (S)" font "Helvetica, 30" offset 0,-1,0
set ylabel "Charge of the CPU's (%)"  font "Helvetica, 30" offset -2,0,0

set title "The avrage of the CPU usage (Dioxine) delta = 4" font "Helvetica, 30"
set terminal png size 3000,1500;
set output 'all_physic_dioxine.png'

# plot for[n=2:9] 'all_cpu_avg.dat' u 1:n with lines lw 4
plot 'data_logical4.dat' using 1:2 title "4 activated core" w l lw 4, \
	 'data_logical8.dat' using 1:2 title "8 activated core" w l lw 4, \
	 'data_logical12.dat' using 1:2 title "12 activated core" w l lw 4, \
	 'data_logical16.dat' using 1:2 title "16 activated core" w l lw 4, \
	 'data_logical20.dat' using 1:2 title "20 activated core" w l lw 4, \
	 'data_logical24.dat' using 1:2 title "24 activated core" w l lw 4, \
	 'data_logical28.dat' using 1:2 title "28 activated core" w l lw 4, \
	 'data_logical32.dat' using 1:2 title "32 activated core" w l lw 4