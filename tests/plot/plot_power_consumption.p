set key autotitle columnhead

set xtics axis
set ytics axis
set border 0
set grid back ls 12

set xrange [0:550]
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

set title "The power consumption (Glyphosate) using ipmi (activation / desactivation) with diffrent number of application" font "Helvetica, 30"
set terminal png size 4000,1500;
set output 'moyenne_glissantepower_consumption_ipmi_on_off.png'

# plot for[n=2:2] 'm_power_consumption_grafana_glyphosate.dat' u 1:n with lines lw 4
plot 'm_c_u_pc0.dat' using 1:2 title "0 application" w l lw 4, \
	 'm_c_u_pc1.dat' using 1:2 title "1 application" w l lw 4, \
	 'm_c_u_pc3.dat' using 1:2 title "3 application" w l lw 4, \
	 'm_c_u_pc6.dat' using 1:2 title "6 application" w l lw 4, \
	 'm_c_u_pc10.dat' using 1:2 title "10 application" w l lw 4