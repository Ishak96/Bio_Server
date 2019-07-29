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

set title "The avrage of the CPU usage (Glyphosate) delta = 1" font "Helvetica, 30"
set terminal png size 3000,1500;
set output 'm_all_physic_glyphosate.png'

# plot for[n=2:9] 'all_cpu_avg.dat' u 1:n with lines lw 4
plot 'm_data_logical1.dat' using 1:2 title "1 activated core" w l lw 4, \
	 'm_data_logical2.dat' using 1:2 title "2 activated core" w l lw 4, \
	 'm_data_logical3.dat' using 1:2 title "3 activated core" w l lw 4, \
	 'm_data_logical4.dat' using 1:2 title "4 activated core" w l lw 4, \
	 'm_data_logical5.dat' using 1:2 title "5 activated core" w l lw 4, \
	 'm_data_logical6.dat' using 1:2 title "6 activated core" w l lw 4, \
	 'm_data_logical7.dat' using 1:2 title "7 activated core" w l lw 4, \
	 'm_data_logical8.dat' using 1:2 title "8 activated core" w l lw 4