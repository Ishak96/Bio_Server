set key autotitle columnhead
set xrange [0:3500]
set yrange [125:180]
set xlabel "time (s)" font "Helvetica, 12"
set ylabel "watts power consumption" font "Helvetica, 12"
set title "the power consumption" font "Helvetica, 15"
set terminal png size 3000,1500;
set output 'cpower_consumption_glyphosate.png'
do for [i=1:2] {
    set style line i linewidth 3
}
plot for[n=2:2] 'power_consumption.dat' u 1:n with lines