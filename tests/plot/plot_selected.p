set key autotitle columnhead
set xrange [0:400]
set yrange [0:150]
set xlabel "time (s)" font "Helvetica, 12"
set ylabel "% usage of cores" font "Helvetica, 12"
set title "CPU usage of the different physical cores" font "Helvetica, 15"
do for [i=1:2] {
    set style line i linewidth 3
}
plot for[n=2:2] 'data_physical_cpu.dat' u 1:n with lines