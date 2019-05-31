set xrange [0:70]
set yrange [125:165]
set tics font ", 25"
set key font ",20"
set ytics 1
set xtics 10
set xlabel "% usage of cpu" font "Helvetica, 12"
set ylabel "power consumption (watts) " font "Helvetica, 12"
set title "The power consumption by the charge of the CPU" font "Helvetica, 15"
set terminal png size 3000,1500;
set output 'power_cpu_usage.png'
do for [i=1:2] {
    set style line i linewidth 3
}
plot for[n=2:2] 'cpu_usage_power.data' u 1:n with line lw 4 title "Dioxine charge-decharge"