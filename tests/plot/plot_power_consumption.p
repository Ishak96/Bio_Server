set key autotitle columnhead
set xrange [0:3000]
set yrange [125:165]
set tics font ", 25"
set key font ",20"
set ytics 1
set xtics 100
set xlabel "time (s)" font "Helvetica, 12"
set ylabel "watts power consumption" font "Helvetica, 12"
set title "the power consumption" font "Helvetica, 15"
set terminal png size 3000,1500;
set output 'power_consumption_dioxine.png'
do for [i=1:2] {
    set style line i linewidth 3
}
plot for[n=2:2] 'power_consumption.dat' u 1:n with lines lw 4
# plot 'cpu_usage_power_glyphosate.data' using 1:2 title "Glyphosate" w l, \
	 'cpu_usage_power_dioxine.data' using 1:2 title "Dioxine" w l