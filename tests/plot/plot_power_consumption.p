set key autotitle columnhead
set xrange [0:120]
set yrange [0:120]
set xlabel "time (s)" font "Helvetica, 12"
set ylabel "watts power consumption" font "Helvetica, 12"
set title "the power consumption" font "Helvetica, 15"
do for [i=1:2] {
    set style line i linewidth 3
}
plot for[n=2:2] 'data_power.dat' u 1:n with lines