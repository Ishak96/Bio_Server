set xrange [0:110]
set yrange [130:180]
set xlabel "% usage of cpu" font "Helvetica, 12"
set ylabel "power consumption (watts) " font "Helvetica, 12"
set title "The power consumption by the charge of the CPU" font "Helvetica, 15"
set terminal png size 3000,1500;
set output 'power_cpu_usage.png'
do for [i=1:2] {
    set style line i linewidth 3
}
plot for[n=2:2] 'cpu_usage_power.data' u 1:n with line