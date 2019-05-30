set key autotitle columnhead
set xrange [0:110]
set yrange [125:180]
set xlabel "time (s)" font "Helvetica, 12"
set ylabel "watts power consumption" font "Helvetica, 12"
set title "the power consumption" font "Helvetica, 15"
set terminal png size 3000,1500;
set output 'power_consumption_dioxine.png'
do for [i=1:2] {
    set style line i linewidth 3
}
plot 'cpu_usage_power_glyphosate.data' using 1:2 title "Glyphosate" w l, \
	 'cpu_usage_power_dioxine.data' using 1:2 title "Dioxine" w l