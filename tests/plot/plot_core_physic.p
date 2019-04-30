set key autotitle columnhead
set xrange [0:400]
set yrange [0:150]
set xlabel "time (s)" font "Helvetica, 12"
set ylabel "% usage of cores" font "Helvetica, 12"
set title "CPU usage of the different physical cores" font "Helvetica, 15"
# number of physical cores + 2
do for [i=1:6] {
    set style line i linewidth 3
}
# number of physical cores + 2
plot for[n=2:6] 'data_physical.dat' u 1:n with lines